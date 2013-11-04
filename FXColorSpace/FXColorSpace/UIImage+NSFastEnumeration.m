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
                                  objects:( id __unsafe_unretained [] )stackBuffer
                                    count:( NSUInteger )stackBufferLength
{
    NSUInteger returnedPixelsCount = 0;
    if(state->state == 0)
    {
        state->mutationsPtr = &state->extra[0];
    }
    
    CGImageRef imageRef = self.CGImage;
    
    CGDataProviderRef dataProvider = CGImageGetDataProvider(imageRef);
    CFDataRef bitmapData = CGDataProviderCopyData(dataProvider);
    uint8_t* imageBytes = (uint8_t*)CFDataGetBytePtr(bitmapData);
    
    const size_t width = CGImageGetWidth(imageRef);
    const size_t height = CGImageGetHeight(imageRef);
    const size_t bytesPerRow = CGImageGetBytesPerRow(imageRef);
    
    const size_t totalPixelsCount = width*height;
    
    if(state->state < totalPixelsCount)
    {
        state->itemsPtr = stackBuffer;
        for (;(returnedPixelsCount < stackBufferLength) && state->state < totalPixelsCount; ++returnedPixelsCount, state->state++)
        {
            size_t y = state->state / width;
            size_t x = state->state % width;
            const size_t i = (bytesPerRow * y) + (x * 4);
            stackBuffer[returnedPixelsCount] = [UIColor FX_colorWithRGBA:FX_RGBA_Make(imageBytes[i],
                                                                                      imageBytes[i+1],
                                                                                      imageBytes[i+2],
                                                                                      imageBytes[i+3])];
        }

        return returnedPixelsCount;
    }
    else
    {
        return 0;
    }

    CFRelease(bitmapData);
    return returnedPixelsCount;
}

@end
