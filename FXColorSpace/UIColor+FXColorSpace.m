//
//  UIColor+FXColorSpace.m
//  OneTouchFX
//
//  Created by Max on 04.11.13.
//  Copyright (c) 2013 Max Lunin. All rights reserved.
//

#import "UIColor+FXColorSpace.h"

@implementation UIColor (FXColorSpace)

+(instancetype)FX_colorWithRGBA:( RGBA )rgba
{
    return [self colorWithRed:rgba.component.r/255.
                        green:rgba.component.g/255.
                         blue:rgba.component.b/255.
                        alpha:rgba.component.a/255];
}

+(instancetype)FX_colorWithHSBA:( HSBA )hsba
{
    return [self colorWithHue:hsba.component.hue
                   saturation:hsba.component.saturation
                   brightness:hsba.component.brightness
                        alpha:hsba.component.alpha];
}

-(RGBA)FX_rgba
{
    CGFloat r, g, b, a;
    [self getRed:&r green:&g blue:&b alpha:&a];
    return FX_RGBA_Make(round(r*255.), round(g*255.), round(b*255.), round(a*255.));
}

-(HSBA)FX_hsba
{
    CGFloat h, s, b, a;
    [self getHue:&h saturation:&s brightness:&b alpha:&a];
    HSBA hsba;
    hsba.component.hue = h;
    hsba.component.saturation = s;
    hsba.component.brightness = b;
    hsba.component.alpha = a;
    return hsba;
}

@end
