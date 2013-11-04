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
    
    UIImage* image = [UIImage FX_imageWitSize:CGSizeMake(100, 100)
                                    generator:^RGBA(size_t x, size_t y)
                      {
                          if( ((x % 20)<10) ^ ((y % 20) < 10) )
                              return FX_RGBA_Make(200, 200, 200, UCHAR_MAX);
                          else
                              return FX_RGBA_Make(UCHAR_MAX, UCHAR_MAX, UCHAR_MAX, UCHAR_MAX);
                      }];
    self.imageView.image = image;
    
    for (UIColor* color in image)
    {
    }
}


@end
