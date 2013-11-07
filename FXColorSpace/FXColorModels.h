//
//  FXColorSpaceDefinition.h
//  OneTouchFX
//
//  Created by Max on 04.11.13.
//  Copyright (c) 2013 Max Lunin. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef union
{
    double components[3];
    struct
    {
        double y, u, v;
    } component;
}
YUV;

typedef union
{
    uint8_t components[4];
    struct
    {
        uint8_t r, g, b, a;
    } component;
}
RGBA;

typedef union
{
    uint8_t components[3];
    struct
    {
        uint8_t r, g, b;
    } component;
}
RGB;

const RGBA FX_RGBA_Make(uint8_t r, uint8_t g, uint8_t b, uint8_t a);

typedef union
{
    CGFloat components[4];
    struct
    {
        CGFloat hue, saturation, brightness, alpha;
    } component;
}HSBA;

NSString* NSStringWithHSBA(HSBA p);

typedef union
{
    double components[3];
    struct
    {
        double x, y, z;
    } component;
}
XYZ;

const XYZ FX_RGB_2_XYZ( RGB p );
const YUV FX_RGB_2_YUV( RGB rgb );
const YUV FX_RGBA_2_YUV( RGBA rgba );
const RGB FX_YUV_2_RGB( YUV yuv );
const RGBA FX_YUV_2_RGBA( YUV yuv, unsigned char alpha);
