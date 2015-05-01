//
//  ActionTableViewCell.m
//  Haiku
//
//  Created by Morgan Collino on 5/1/15.
//  Copyright (c) 2015 Morgan Collino. All rights reserved.
//

#import "ActionTableViewCell.h"

@interface ActionTableViewCell ()

@property (nonatomic, weak) IBOutlet UIImageView *icon;
@property (nonatomic, weak) IBOutlet UILabel *titleAction;

@end

@implementation ActionTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setImageWithName:(NSString *)name titleAction:(NSString *)title {
	
	[self.icon setImage:[UIImage imageNamed:name]];
	[self.titleAction setText:title];
}

@end
