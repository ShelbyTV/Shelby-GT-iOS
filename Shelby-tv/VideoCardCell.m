//
//  VideoCardCell.m
//  Shelby-tv
//
//  Created by Arthur Ariel Sabintsev on 5/4/12.
//  Copyright (c) 2012 Shelby.tv. All rights reserved.
//

#import "VideoCardCell.h"
#import <CoreGraphics/CoreGraphics.h>

@interface VideoCardCell ()

@end

@implementation VideoCardCell
@synthesize thumbnailImageView = _thumbnailImageView;

#pragma mark - Memory Deallocation Methods
- (void)dealloc
{
    self.thumbnailImageView = nil;

}

- (void)awakeFromNib
{
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

@end