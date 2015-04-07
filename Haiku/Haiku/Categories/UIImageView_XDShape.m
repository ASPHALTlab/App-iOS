//
//  UIImageView_XDShape.m
//  XDTest
//
//  Created by Morgan Collino on 4/15/14.
//  Copyright (c) 2014 Morgan Collino. All rights reserved.
//

#import "UIImageView_XDShape.h"

@implementation UIImageView(XDShape)

- (void) toRoundImageView
{
    if (![self isASquareImageView])
        [self toSquareImageView];
    float newSize = self.frame.size.height;
    self.layer.cornerRadius = newSize / 2;
    self.layer.masksToBounds = YES;
}

- (void) toRoundImageViewWithBorderSize:(float)size color:(UIColor *)color
{
    [self toRoundImageView];
    [self addBorder: size withColor: color];
}

- (void) toSquareImageView
{
    float lowestValue = 0;
    CGSize size = [self.image size];
    self.contentMode = UIViewContentModeScaleAspectFill;
    
    // resize Image;
    lowestValue = size.height > size.width ? size.width : size.height;
    CGRect cropRegion = CGRectMake(0, 0, lowestValue, lowestValue);
    CGImageRef croppedImage = CGImageCreateWithImageInRect([self.image CGImage], cropRegion);
    self.image = [UIImage imageWithCGImage:croppedImage];
    CGImageRelease(croppedImage);
}

- (void) toSquareImageViewWithBorderSize:(float)size color:(UIColor *)color
{
    [self toSquareImageView];
    [self addBorder: size withColor: color];
}

// Just check if the image is a square, if not, the image would be strech, and ugly, no offense.
- (BOOL) isASquareImageView
{
    if (self.image.size.height == self.image.size.width)
        return YES;
    return NO;
}

- (void) addBorder: (float) size withColor: (UIColor *) color
{
    CALayer *lyr = self.layer;
    lyr.borderWidth = size;
    lyr.borderColor = [color CGColor];
}

@end
