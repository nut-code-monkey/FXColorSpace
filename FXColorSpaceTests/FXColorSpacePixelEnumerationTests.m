//
//  FXColorSpaceTests.m
//  FXColorSpaceTests
//
//  Created by Max on 12/17/14.
//  Copyright (c) 2014 Max Lunin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>

#import "UIImage+FXPixelEmumeration.h"
#import "UIImage+FXImageCreation.h"

@interface FXColorSpaceTests : XCTestCase

@end

@implementation FXColorSpaceTests

- (void)testEnumerateFrame
{
    UIImage* image = [UIImage FX_imageWitSize:FXMakeSize(4, 4) generator:^RGBA(FXPoint point)
                      {
                          if ( (point.x == 1 || point.x == 2) && (point.y == 1 || point.y == 2) )
                          {
                              return FX_RGBA_Make(255, 255, 255, 0);
                          }
                          else
                          {
                              return FX_RGBA_Make(0, 0, 0, 0);
                          }
                      }];

    __block NSUInteger count = 0;
    BOOL enumerated = [image FX_enumeratePixelsInFrame:FXMakeRect(1, 1, 2, 2)
                      rgbaEnumerator:^(RGBA rgba, FXPoint point, BOOL *stop)
                       {
                           uint8_t r = rgba.component.r;
                           uint8_t shouldBe = 255;
                           XCTAssertEqual(r, shouldBe);
                           
                           BOOL inRange = (point.x == 1 || point.x == 2) && (point.y == 1 || point.y == 2);
                           
                           XCTAssert(inRange);
                           
                           count++;
                       }];
    
    XCTAssertEqual(count, 4);
    XCTAssert(enumerated);
}


@end
