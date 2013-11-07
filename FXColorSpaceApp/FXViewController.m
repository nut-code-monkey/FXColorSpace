//
//  FXViewController.m
//  FXColorSpaceApp
//
//  Created by Max on 04.11.13.
//  Copyright (c) 2013 Max Lunin. All rights reserved.
//

#import "FXViewController.h"
#import "FXColorSpace.h"

@interface FXViewController ()

@end

@implementation FXViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UIImage* uiImage = [UIImage FX_imageWitSize:CGSizeMake(100, 100)
                                           generator:^RGBA(FXPoint point)
                             {
                                 if( (point.x%20 < 10) ^ (point.y%20 < 10) )
                                     return FX_RGBA_Make(200, 200, 200, UCHAR_MAX);
                                 else
                                     return FX_RGBA_Make(UCHAR_MAX, UCHAR_MAX, UCHAR_MAX, UCHAR_MAX);
                             }];
    self.imageView.image = uiImage;
    
    double brightnessSum = 0;
    for (UIColor* color in uiImage){
        brightnessSum += color.FX_hsba.component.brightness;
    }
    double averageImageBrightness = brightnessSum / (uiImage.size.width*uiImage.size.height);
    NSLog(@"avg: %f", averageImageBrightness);
    
    CGPoint somePoint = CGPointMake(20, 20);
    [uiImage FX_enumerateAllPixelsRGBA:^(RGBA rgba, FXPoint point, BOOL *stop) {
        double manhattanDistance = ABS(somePoint.x - point.x) + ABS(somePoint.y - point.y);
        // do something with distance for point
    }];
    
UIImage* redDecreasedImage = [uiImage FX_imageByMutatePixelsRGBA:^(RGBA rgba, FXPoint point, BOOL *update, BOOL *stop)
                              {
                                  if ((point.x % 10 < 5) ^ (point.y%10 < 5))
                                  {
                                      rgba.component.r -= 100;
                                  }
                                  return rgba;
                              }];
    NSLog(@"%@", redDecreasedImage);
}


@end
