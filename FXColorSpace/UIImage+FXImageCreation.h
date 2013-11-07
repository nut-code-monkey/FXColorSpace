//
//  UIImage+creation.h
//  OneTouchFX
//
//  Created by Max on 30.10.13.
//  Copyright (c) 2013 Max Lunin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FXColorSpace.h"

typedef RGBA(^FXImageGRBAGenerator)(FXPoint point);

@interface UIImage (FXImageCreation)

-(instancetype)FX_hystogrammWithSize:( CGSize )size;
+(instancetype)FX_imageWitSize:( CGSize )size generator:( FXImageGRBAGenerator )generator;

@end
