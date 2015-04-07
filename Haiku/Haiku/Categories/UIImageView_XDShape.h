//
//  UIImageView_XDShape.h
//  XDTest
//
//  Created by Morgan Collino on 4/15/14.
//  Copyright (c) 2014 Morgan Collino. All rights reserved.
//

#import <UIKit/UIKit.h>

/*
 *  XDShape :
 *      - Transform UIImage from an UIImageView to a rounded image or a squared image
 */

@interface UIImageView (XDShape)

- (void) toRoundImageView;      // @Round image
- (BOOL) isASquareImageView;    // @Check if the ImageView has a squared image
- (void) toSquareImageView;     // @Square Image
- (void) toRoundImageViewWithBorderSize: (float) size color: (UIColor *) color; // @Round Image + border
- (void) toSquareImageViewWithBorderSize: (float) size color: (UIColor *) color; // @Square Image + border

@end
