// UIImage+Resize.h
// Created by Trevor Harmon on 8/5/09.
// Free for personal or commercial use, with or without modification.
// No warranty is expressed or implied.

// Extends the UIImage class to support resizing/cropping
@interface UIImage (FXResize)

- (UIImage *)FX_croppedImage:(CGRect)bounds;
- (UIImage *)FX_thumbnailImage:(NSInteger)thumbnailSize
                 transparentBorder:(NSUInteger)borderSize
                      cornerRadius:(NSUInteger)cornerRadius
              interpolationQuality:(CGInterpolationQuality)quality;
- (UIImage *)FX_resizedImage:(CGSize)newSize
            interpolationQuality:(CGInterpolationQuality)quality;
- (UIImage *)FX_resizedImageWithContentMode:(UIViewContentMode)contentMode
                                         bounds:(CGSize)bounds
                           interpolationQuality:(CGInterpolationQuality)quality;
@end
