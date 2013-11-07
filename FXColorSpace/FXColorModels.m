//
//  FXColorSpaceDefinition.m
//  OneTouchFX
//
//  Created by Max on 04.11.13.
//  Copyright (c) 2013 Max Lunin. All rights reserved.
//

#import "FXColorModels.h"

inline const RGBA FX_RGBA_Make(uint8_t r, uint8_t g, uint8_t b, uint8_t a)
{
    RGBA rgba;
    rgba.component.r = r;
    rgba.component.g = g;
    rgba.component.b = b;
    rgba.component.a = a;
    return rgba;
}

inline NSString* NSStringWithHSBA(HSBA pixel)
{
    return [NSString stringWithFormat:@"{h:%f s:%f b:%f a:%f}",
            pixel.component.hue,
            pixel.component.saturation,
            pixel.component.saturation,
            pixel.component.alpha];
}

inline const YUV FX_RGB_2_YUV( RGB rgb )
{
    YUV yuv;
    yuv.component.y =  0.299   * rgb.component.r  + 0.587    * rgb.component.g   + 0.114    * rgb.component.b;
    yuv.component.u = -0.14713 * rgb.component.r  + -0.28886 * rgb.component.g   + 0.436    * rgb.component.b;
    yuv.component.v =  0.615   * rgb.component.r  + -0.51499 * rgb.component.g   + -0.10001 * rgb.component.b;
    return yuv;
}

inline const YUV FX_RGBA_2_YUV( RGBA rgba )
{
    return FX_RGB_2_YUV((RGB){{rgba.component.r, rgba.component.g, rgba.component.b}});
}

inline const RGBA FX_YUV_2_RGBA( YUV yuv, unsigned char alpha)
{
    RGB rgb = FX_YUV_2_RGB(yuv);
    return (RGBA){{rgb.component.r, rgb.component.g, rgb.component.b, alpha}};
}


inline const RGB FX_YUV_2_RGB( YUV yuv )
{
    RGB rgb;
    rgb.component.r = round(yuv.component.y + /* 0 * yuv.component.u */ + 1.13983*yuv.component.v);
    rgb.component.g = round(yuv.component.y  -0.39465*yuv.component.u    -0.58060*yuv.component.v);
    rgb.component.b = round(yuv.component.y + 2.03211*yuv.component.u   /*  0*yuv.component.v */ );
    return rgb;
}

inline const XYZ FX_RGB_2_XYZ( RGB rgb )
{
    return (XYZ){{
        0.4124564*rgb.component.r + 0.3575761*rgb.component.g + 0.1804375*rgb.component.b,
        0.2126729*rgb.component.r + 0.7151522*rgb.component.g + 0.0721750*rgb.component.b,
        0.0193339*rgb.component.r + 0.1191920*rgb.component.g + 0.9503041*rgb.component.b
    }};
}
