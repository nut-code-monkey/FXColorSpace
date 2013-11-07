FXColorSpace
============
High level image pixels enumeration:
------------------------------------
Create UIImage on the fly:
```
UIImage* patternImage = [UIImage FX_imageWitSize:CGSizeMake(100, 100)
                                       generator:^RGBA(size_t x, size_t y){
                             if( (x%20 < 10) ^ (y%20 < 10) )
                                 return FX_RGBA_Make(200, 200, 200, 255);
                             else
                                 return FX_RGBA_Make(255, 255, 255, 255);
                         }];
```
Output image: ![Pattern created image](https://raw.github.com/nut-code-monkey/FXColorSpace/master/pattern_created_image.png)

You can easy enumerate all pixels in the UIImage:
```
double brightnessSum = 0;
for (UIColor* color in uiImage){
    brightnessSum += color.FX_hsba.component.brightness;
}
double averageImageBrightness = brightnessSum / (uiImage.size.width*uiImage.size.height);
```
Or if you need X, Y coordinates of each pixel :
```
CGPoint somePoint = CGPointMake(20, 20);
[uiImage FX_enumerateAllPixelsRGBA:^(RGBA rgba, FXPoint point, BOOL *stop) {
    double manhattanDistance = ABS(somePoint.x - point.x) + ABS(somePoint.y - point.y);
    // do something with distance for point
}];
```
If you need change pixels values:
---------------------------------
```
UIImage* redDecreasedImage = [uiImage FX_imageByMutatePixelsRGBA:^(RGBA rgba, FXPoint point, BOOL *update, BOOL *stop){
                                  if ((point.x % 10 < 5) ^ (point.y%10 < 5)){
                                      rgba.component.r -= 100;
                                  }
                                  return rgba;
                              }];
```
Output image: ![red decreased image](https://raw.github.com/nut-code-monkey/FXColorSpace/master/red_decreased_image.png)
Install
-------
```
pod 'FXColorSpace'
```
