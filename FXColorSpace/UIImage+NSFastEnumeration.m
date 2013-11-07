//
//  UIImage+NSFastEnumeration.m
//  FXColorSpace
//
//  Created by Max on 04.11.13.
//  Copyright (c) 2013 Max Lunin. All rights reserved.
//

#import "UIImage+NSFastEnumeration.h"
#import "UIColor+FXColorSpace.h"
#import <objc/runtime.h>

static char fastEnumeratedBytesKey;

@implementation UIImage (NSFastEnumeration)

-(uint8_t*)FX_fastEnumeratedBytes
{
    NSValue* value = objc_getAssociatedObject(self, &fastEnumeratedBytesKey);
    return [value pointerValue];
}

-(void)FX_setFastEnumeratedBytes:( uint8_t* )bytes
{
    NSValue* value = objc_getAssociatedObject(self, &fastEnumeratedBytesKey);
    uint8_t* oldBytes = [value pointerValue];
    if (oldBytes != bytes)
    {
        free(oldBytes);
    }
    if (bytes)
    {
        objc_setAssociatedObject(self, &fastEnumeratedBytesKey, [NSValue valueWithPointer:bytes], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    else
    {
        objc_setAssociatedObject(self, &fastEnumeratedBytesKey, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
}

- (NSUInteger)countByEnumeratingWithState:( NSFastEnumerationState* )state
                                  objects:( id __unsafe_unretained [] )buffer
                                    count:( NSUInteger )bufferLength
{
    const size_t WIDTH = 2;
    const size_t HEIGHT = 3;
    const size_t BYTES_PER_ROW = 4;
    
    uint8_t* bytes = [self FX_fastEnumeratedBytes];
    if (!bytes)
    {
        state->state = 0;
        state->mutationsPtr = &state->extra[0];
        
        CGImageRef imageRef = self.CGImage;
        CGDataProviderRef dataProvider = CGImageGetDataProvider(imageRef);
        CFDataRef bitmapData = CGDataProviderCopyData(dataProvider);
        const void* imageBytes = CFDataGetBytePtr(bitmapData);
        
        state->extra[WIDTH] = CGImageGetWidth(imageRef);
        state->extra[HEIGHT] = CGImageGetHeight(imageRef);
        state->extra[BYTES_PER_ROW] = CGImageGetBytesPerRow(imageRef);
        
        bytes = malloc(state->extra[BYTES_PER_ROW]*state->extra[HEIGHT]);
        memcpy(bytes, imageBytes, state->extra[BYTES_PER_ROW]*state->extra[HEIGHT]);
        CFRelease(bitmapData);
        
        [self FX_setFastEnumeratedBytes:bytes];
    }

    const size_t totalBytesCount = state->extra[BYTES_PER_ROW]*state->extra[HEIGHT];
    
    NSUInteger outColors = 0;
    
    if(state->state < totalBytesCount)
    {
        state->itemsPtr = buffer;
        for (;(outColors < bufferLength) && state->state < totalBytesCount; ++outColors, state->state += 4)
        {
            buffer[outColors] = [UIColor FX_colorWithRGBA:FX_RGBA_Make(bytes[state->state],
                                                                   bytes[state->state+1],
                                                                   bytes[state->state+2],
                                                                   bytes[state->state+3])];
        }
        return outColors;
    }
    else
    {
        [self FX_setFastEnumeratedBytes:nil];
        return 0;
    }
    return outColors;
}

@end
