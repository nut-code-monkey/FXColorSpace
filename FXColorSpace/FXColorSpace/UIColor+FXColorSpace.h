//
//  UIColor+FXColorSpace.h
//  OneTouchFX
//
//  Created by Max on 04.11.13.
//  Copyright (c) 2013 Max Lunin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FXColorModels.h"

@interface UIColor (FXColorSpace)

+(instancetype)FX_colorWithRGBA:( RGBA )rgba;
+(instancetype)FX_colorWithHSBA:( HSBA )hsba;
-(HSBA)FX_hsba;
-(RGBA)FX_rgba;


@end
