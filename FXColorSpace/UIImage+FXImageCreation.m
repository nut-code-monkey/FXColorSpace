//
//  UIImage+creation.m
//  OneTouchFX
//
//  Created by Max on 30.10.13.
//  Copyright (c) 2013 Max Lunin. All rights reserved.
//

#import "UIImage+FXImageCreation.h"
#import "UIImage+FXPixelEmumeration.h"

#import <Accelerate/Accelerate.h>

@implementation UIImage (FXImageCreation)

size_t FX_map(size_t x, size_t in_min, size_t in_max, size_t out_min, size_t out_max)
{
    return (x - in_min) * (out_max - out_min) / (in_max - in_min) + out_min;
}

-(instancetype)FX_hystogrammWithSize:( CGSize )size
{
    size_t* histR = calloc(UCHAR_MAX, sizeof(size_t));
    size_t* histG = calloc(UCHAR_MAX, sizeof(size_t));
    size_t* histB = calloc(UCHAR_MAX, sizeof(size_t));
    
    [self FX_enumerateAllPixelsRGBA:^(RGBA rgba, FXPoint point, BOOL* stop)
     {
         histR[rgba.component.r]++;
         histG[rgba.component.g]++;
         histB[rgba.component.b]++;
    }];
    
    size_t hist_max = 0;
    for (size_t i = 0; i < UCHAR_MAX; ++i)
    {
        hist_max = MAX(hist_max, MAX(histR[i], MAX(histG[i], histB[i])));
    }
    for (size_t i = 0; i < UCHAR_MAX; ++i)
    {
        histR[i] = FX_map(histR[i], 0, hist_max, 0, size.height);
        histG[i] = FX_map(histG[i], 0, hist_max, 0, size.height);
        histB[i] = FX_map(histB[i], 0, hist_max, 0, size.height);
    }
    UIImage* image = [UIImage FX_imageWitSize:size
                                    generator:^RGBA(FXPoint point)
                      {
                          size_t i = FX_map(point.x, 0, size.width, 0, UCHAR_MAX);
                          return FX_RGBA_Make(histR[i] < point.y ? 100 : 0,
                                              histG[i] < point.y ? 150 : 0,
                                              histB[i] < point.y ? 200 : 0,
                                              255);
                      }];
    free(histR);
    free(histG);
    free(histB);
    return image;
}

+(instancetype)FX_imageWitSize:( CGSize )size generator:( FXImageGRBAGenerator )generator
{
    NSParameterAssert(!CGSizeEqualToSize(size, CGSizeZero));
    NSParameterAssert(generator);

    size_t width = size.width;
    size_t height = size.height;
    size_t bytesPerRow = 4*width;

    uint8_t* pixelBuffer = (uint8_t*)malloc(bytesPerRow*height);
    if(!pixelBuffer)
    {
        NSLog(@"No pixelbuffer");
        
        return nil;
    }
    
    for (size_t y = 0; y < height; ++y)
    {
        for (size_t x = 0, rowStart = bytesPerRow*y, pixelStart = 0; pixelStart < bytesPerRow; pixelStart+=4, ++x)
        {
            const size_t i = rowStart + pixelStart;

            RGBA rgba = generator(FXMakePoint(x, y));
            for (size_t chanel = 0; chanel < 4; ++chanel)
            {
                pixelBuffer[i+chanel] = rgba.components[chanel];
            }
        }
    }
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    
    CGContextRef context = CGBitmapContextCreate(pixelBuffer,
                                                 width,
                                                 height,
                                                 8,
                                                 bytesPerRow,
                                                 colorSpace,
                                                 kCGBitmapByteOrderDefault|kCGImageAlphaNoneSkipLast);
    
    CGImageRef imageRef = CGBitmapContextCreateImage (context);
    
    UIImage *returnImage = [UIImage imageWithCGImage:imageRef];
    
    CGContextRelease(context);
    free(pixelBuffer);

    CGColorSpaceRelease(colorSpace);
    CGImageRelease(imageRef);
    
    return returnImage;
}
@end
