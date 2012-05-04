//
//  VideoCardCell.m
//  Shelby-tv
//
//  Created by Arthur Ariel Sabintsev on 5/4/12.
//  Copyright (c) 2012 Shelby.tv. All rights reserved.
//

#import "VideoCardCell.h"
#import <QuartzCore/QuartzCore.h>

@interface VideoCardCell ()

- (void)createGradientForView:(UIView*)view;

@end

@implementation VideoCardCell
@synthesize thumbnailImageView = _thumbnailImageView;
@synthesize captionView = _captionView;
@synthesize linksView = _linksView;
@synthesize commentView = _commentView;

- (void)dealloc
{
    self.thumbnailImageView = nil;
    self.captionView = nil;
    self.linksView = nil;
    self.commentView = nil;
}

- (void)awakeFromNib
{
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    [self createGradientForView:self.captionView];
    [self createGradientForView:self.linksView];
    [self createGradientForView:self.commentView];
}

- (void)createGradientForView:(UIView *)view
{
    CAGradientLayer *gradient = [CAGradientLayer layer];
    gradient.frame = view.bounds;
    gradient.colors = [NSArray arrayWithObjects:(id)[[UIColor colorWithRed:51.0f/255.5f green:51.0f/255.5f blue:51.0f/255.5f alpha:1.0f] CGColor], (id)[[UIColor colorWithRed:48.0f/255.5f green:48.0f/255.5f blue:48.0f/255.5f alpha:1.0f] CGColor], nil];
    [view.layer addSublayer:gradient];
}

@end