//
//  UIImage+NSFastEnumeration.m
//  FXColorSpace
//
//  Created by Max on 04.11.13.
//  Copyright (c) 2013 Max Lunin. All rights reserved.
//

#import "UIImage+NSFastEnumeration.h"
#import "UIColor+FXColorSpace.h"

@implementation UIImage (NSFastEnumeration)

- (NSUInteger)countByEnumeratingWithState:( NSFastEnumerationState* )state
                                  objects:( id __unsafe_unretained [] )buffer
                                    count:( NSUInteger )bufferLength
{
    if(state->state == 0) state->mutationsPtr = &state->extra[0];
    
    const size_t BYTES = 1;
    const size_t WIDTH = 2;
    const size_t HEIGHT = 3;
    const size_t BYTES_PER_ROW = 4;

    if (state->extra[BYTES] == 0)
    {
        CGImageRef imageRef = self.CGImage;
        CGDataProviderRef dataProvider = CGImageGetDataProvider(imageRef);
        CFDataRef bitmapData = CGDataProviderCopyData(dataProvider);
        const void* imageBytes = CFDataGetBytePtr(bitmapData);
        uint8_t* bytes = malloc(sizeof(imageBytes));
        memcpy(bytes, imageBytes, sizeof(imageBytes));
        
        state->extra[BYTES] = (typeof(state->extra[BYTES]))bytes;
        state->extra[WIDTH] = CGImageGetWidth(imageRef);
        state->extra[HEIGHT] = CGImageGetHeight(imageRef);
        state->extra[BYTES_PER_ROW] = CGImageGetBytesPerRow(imageRef);
        
        CFRelease(bitmapData);
    }
    
    const size_t totalPixelsCount = state->extra[WIDTH]*state->extra[HEIGHT];
    NSUInteger count = 0;
    if(state->state < totalPixelsCount)
    {
        state->itemsPtr = buffer;
        uint8_t* bytes = (uint8_t*)state->extra[1];
        
        for (;(count < bufferLength) && state->state < totalPixelsCount; ++count, state->state++)
        {
            size_t y = state->state / state->extra[WIDTH];
            size_t x = state->state % state->extra[WIDTH];
            const size_t i = (state->extra[BYTES_PER_ROW] * y) + (x * 4);
            buffer[count] = [UIColor FX_colorWithRGBA:FX_RGBA_Make(bytes[i], bytes[i+1], bytes[i+2], bytes[i+3])];
        }
        return count;
    }
    else
    {
        uint8_t* bytes = (uint8_t*)state->extra[BYTES];
        free(bytes);
        
        return 0;
    }
    return count;
}

@end
