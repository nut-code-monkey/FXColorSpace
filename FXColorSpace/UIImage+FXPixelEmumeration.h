//
//  UIImage+AverageColor.h
//  OneTouchFX
//
//  Created by Max on 26.10.13.
//  Copyright (c) 2013 Max Lunin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FXColorModels.h"

typedef struct
{
    size_t x;
    size_t y;
} FXPoint;

typedef struct
{
    size_t width;
    size_t height;
} FXSize;

typedef struct
{
    FXPoint origin;
    FXSize size;
} FXRect;

FXPoint FXMakePoint(size_t x, size_t y);
FXSize FXMakeSize(size_t width, size_t height);
FXRect FXMakeRect(size_t x, size_t y, size_t width, size_t height);

typedef void(^RGBAPixelsEnumerator)(RGBA rgba, FXPoint point, BOOL* stop);
typedef void(^HSBAPixelsEnumerator)(HSBA hsba, FXPoint point, BOOL* stop);
typedef RGBA(^RGBAPixelMutator)(RGBA rgba, FXPoint point, BOOL*update, BOOL* stop);
typedef void(^UIColorPixelEnumerator)(UIColor* color, RGBA rgba, FXPoint point, BOOL* stop);
typedef void(^FXUpdateImageCallback)(UIImage* image);

@interface UIImage (FXPixelEmumeration)

-(void)FX_enumerateColors:( UIColorPixelEnumerator )colorEnumerator;

-(BOOL)FX_enumeratePixelsInFrame:( FXRect )frame rgbaEnumerator:( RGBAPixelsEnumerator )rgbaEnumerator;

-(void)FX_enumerateAllPixelsRGBA:( RGBAPixelsEnumerator )rgbaEnumerator;

-(void)FX_enumerateAllPixelsRGBA:( RGBAPixelsEnumerator )rgbaEnumerator
                            HSBA:( HSBAPixelsEnumerator )hsbaEnumerator;

-(UIImage*)FX_imageByMutatePixelsRGBA:( RGBAPixelMutator )rgbaPixelsEnumerator;
-(UIImage*)FX_imageByMutatePixelsRGBA:( RGBAPixelMutator )rgbaPixelsEnumerator
                             newImage:( FXUpdateImageCallback )updateImageCalback;

@end
