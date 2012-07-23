//
//  NewRollCell.m
//  Shelby.tv
//
//  Created by Arthur Ariel Sabintsev on 7/18/12.
//  Copyright (c) 2012 Shelby.tv. All rights reserved.
//

#import "NewRollCell.h"

@implementation NewRollCell
@synthesize button = _button;
@synthesize label = _label;

- (void)dealloc
{
    self.button = nil;
    self.label = nil;
}

- (void)awakeFromNib
{
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.backgroundColor = ColorConstants_BackgroundColor;
    
    [self.label setFont:[UIFont fontWithName:@"Ubuntu" size:self.label.font.pointSize]];
    [self.label setTextColor:ColorConstants_GrayTextColor];
}

@end