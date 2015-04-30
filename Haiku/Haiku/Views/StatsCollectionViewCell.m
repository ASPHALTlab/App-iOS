//
//  StatsCollectionViewCell.m
//  Haiku
//
//  Created by Morgan Collino on 4/30/15.
//  Copyright (c) 2015 Morgan Collino. All rights reserved.
//

#import "StatsCollectionViewCell.h"

@interface StatsCollectionViewCell ()

@property (nonatomic, weak) IBOutlet UILabel *value;
@property (nonatomic, weak) IBOutlet UILabel *title;

@end

@implementation StatsCollectionViewCell

- (void)setTitle:(NSString *)title withValue:(NSString *)value {
	self.title.text = title;
	self.value.text = value;
}

@end
