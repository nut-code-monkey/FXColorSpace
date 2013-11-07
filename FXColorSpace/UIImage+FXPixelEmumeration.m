//
//  UIImage+AverageColor.m
//  OneTouchFX
//
//  Created by Max on 26.10.13.
//  Copyright (c) 2013 Max Lunin. All rights reserved.
//

#import "UIImage+FXPixelEmumeration.h"
#import "UIColor+FXColorSpace.h"

FXPoint FXMakePoint(size_t x, size_t y)
{
    return (FXPoint){x, y};
}

@implementation UIImage (FXPixelEmumeration)

-(void)FX_enumerateColors:( UIColorPixelEnumerator )uiColorEnumerator
{
    NSParameterAssert(uiColorEnumerator);
    
    CGImageRef imageRef = self.CGImage;
    
    CGDataProviderRef dataProvider = CGImageGetDataProvider(imageRef);
    CFDataRef bitmapData = CGDataProviderCopyData(dataProvider);
    uint8_t* imageBytes = (uint8_t*)CFDataGetBytePtr(bitmapData);
    
    const size_t height = CGImageGetHeight(imageRef);
    const size_t bytesPerRow = CGImageGetBytesPerRow(imageRef);
    
    BOOL stop = NO;
    for (size_t y = 0; y < height && !stop; ++y)
    {
        for (size_t x = 0, rowStart = bytesPerRow*y, pixelStart = 0; pixelStart < bytesPerRow; pixelStart+=4, ++x)
        {
            const size_t i = rowStart + pixelStart;
            
            const size_t R = i;
            const size_t G = i + 1;
            const size_t B = i + 2;
            const size_t A = i + 3;
            const RGBA rgba = FX_RGBA_Make(imageBytes[R], imageBytes[G], imageBytes[B], imageBytes[A]);
            uiColorEnumerator([UIColor FX_colorWithRGBA:rgba], rgba, FXMakePoint(x, y), &stop);
            if (stop) break;
        }
    }
    CFRelease(bitmapData);
}

-(void)FX_enumerateAllPixelsRGBA:( RGBAPixelsEnumerator )rgbaEnumerator;
{
    [self FX_enumerateAllPixelsRGBA:rgbaEnumerator HSBA:nil];
}

-(void)FX_enumerateAllPixelsRGBA:( RGBAPixelsEnumerator )rgbaEnumerator
                            HSBA:( HSBAPixelsEnumerator )hsbaEnumerator
{
    NSParameterAssert(rgbaEnumerator);

    CGImageRef imageRef = self.CGImage;
    
    CGDataProviderRef dataProvider = CGImageGetDataProvider(imageRef);
    CFDataRef bitmapData = CGDataProviderCopyData(dataProvider);
    uint8_t* imageBytes = (uint8_t*)CFDataGetBytePtr(bitmapData);
    
    const size_t height = CGImageGetHeight(imageRef);
    const size_t bytesPerRow = CGImageGetBytesPerRow(imageRef);
    
    if (!hsbaEnumerator)
    {
        BOOL stop = NO;
        for (size_t y = 0; y < height && !stop; ++y)
        {
            for (size_t x = 0, rowStart = bytesPerRow*y, pixelStart = 0; pixelStart < bytesPerRow; pixelStart+=4, ++x)
            {
                size_t i = rowStart + pixelStart;
                
                const size_t R = i;
                const size_t G = i + 1;
                const size_t B = i + 2;
                const size_t A = i + 3;
                
                RGBA rgbaPixel = FX_RGBA_Make(imageBytes[R], imageBytes[G], imageBytes[B], imageBytes[A]);
                
                rgbaEnumerator(rgbaPixel, FXMakePoint(x, y), &stop);
                if (stop) break;
            }
        }
    }
    else
    {
        BOOL stop = NO;
        for (size_t y = 0; y < height && !stop; ++y)
        {
            for (size_t x = 0, rowStart = bytesPerRow*y, pixelStart = 0; pixelStart < bytesPerRow; pixelStart+=4, ++x)
            {
                const size_t i = rowStart + pixelStart;
                
                const size_t R = i;
                const size_t G = i + 1;
                const size_t B = i + 2;
                const size_t A = i + 3;
                
                const RGBA rgbaPixel = FX_RGBA_Make(imageBytes[R], imageBytes[G], imageBytes[B], imageBytes[A]);
                
                FXPoint point = FXMakePoint(x, y);
                rgbaEnumerator(rgbaPixel, point, &stop);
                if (stop) break;
                hsbaEnumerator([[UIColor FX_colorWithRGBA:rgbaPixel] FX_hsba], point, &stop);
                if (stop) break;
            }
        }
    }
    CFRelease(bitmapData);
}

-(UIImage *)FX_imageByMutatePixelsRGBA:(RGBAPixelMutator)rgbaEnumerator
{
    return [self FX_imageByMutatePixelsRGBA:rgbaEnumerator newImage:^(UIImage *img){}];
}

-(UIImage *)FX_imageByMutatePixelsRGBA:( RGBAPixelMutator )rgbaEnumerator
                              newImage:( FXUpdateImageCallback )updateImageCalback
{
    NSParameterAssert(updateImageCalback);
    NSParameterAssert(rgbaEnumerator);

    CGImageRef imageRef = self.CGImage;
    CGDataProviderRef dataProvider = CGImageGetDataProvider(imageRef);
    CFDataRef bitmapData = CGDataProviderCopyData(dataProvider);
    uint8_t* bitmapImageBufferData = (uint8_t*)CFDataGetBytePtr(bitmapData);
        
    size_t width = CGImageGetWidth(imageRef);
    size_t height = CGImageGetHeight(imageRef);
    size_t bytesPerRow = CGImageGetBytesPerRow(imageRef);
    size_t bitsPerComponent = CGImageGetBitsPerComponent(imageRef);

    uint8_t* buffer = malloc(bytesPerRow*height);
    memcpy(buffer, bitmapImageBufferData, bytesPerRow*height);
    CFRelease(bitmapData);
    
    UIImage* (^createImage)() = ^()
    {
        CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
        
        CGContextRef newBitmapContext = CGBitmapContextCreate(buffer,
                                                              width,
                                                              height,
                                                              bitsPerComponent,
                                                              bytesPerRow,
                                                              colorSpace,
                                                              kCGBitmapByteOrderDefault|kCGImageAlphaNoneSkipLast);
        CGImageRef imageRefFromNewContext = CGBitmapContextCreateImage (newBitmapContext);
        
        UIImage *returnImage = [UIImage imageWithCGImage:imageRefFromNewContext];

        CGContextRelease(newBitmapContext);
        CGColorSpaceRelease(colorSpace);
        CGImageRelease(imageRefFromNewContext);
        
        return returnImage;
    };
    
    BOOL stop = NO;
    for (size_t y = 0; y < height && !stop; ++y)
    {
        BOOL shouldUpdate = NO;
        for (size_t x = 0, rowStart = bytesPerRow*y, pixelStart = 0; pixelStart < bytesPerRow; pixelStart+=4, ++x)
        {
            const size_t i = rowStart + pixelStart;
            const size_t R = i;
            const size_t G = i + 1;
            const size_t B = i + 2;
            const size_t A = i + 3;

            const RGBA rgba = FX_RGBA_Make(buffer[R], buffer[G], buffer[B], buffer[A]);
            BOOL update = NO;
            RGBA outPixel = rgbaEnumerator(rgba, FXMakePoint(x, y), &update, &stop);
            buffer[R] = outPixel.component.r;
            buffer[G] = outPixel.component.g;
            buffer[B] = outPixel.component.b;
            buffer[A] = outPixel.component.a;
            
            if (stop) break;
            shouldUpdate = update?:shouldUpdate;
        }
        if (shouldUpdate)
        {
            updateImageCalback(createImage());
        }
    }
    
    UIImage* returnImage = createImage();
    free(buffer);
    return returnImage;
}

@end
