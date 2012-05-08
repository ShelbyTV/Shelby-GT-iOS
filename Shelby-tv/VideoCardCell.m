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

- (void)createGradientForContext:(CGContextRef)context andView:(UIView*)view;

@end

@implementation VideoCardCell
@synthesize thumbnailImageView = _thumbnailImageView;
@synthesize captionView = _captionView;
@synthesize linksView = _linksView;
@synthesize commentView = _commentView;

#pragma mark - Memory Deallocation Methods
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
}


- (void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    [self createGradientForContext:context andView:self.captionView];
    [self createGradientForContext:context andView:self.linksView];
    [self createGradientForContext:context andView:self.commentView]; 
    
}

- (void)createGradientForContext:(CGContextRef)context andView:(UIView *)view
{
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    
    CGColorRef topColor = [[UIColor colorWithRed:51.0f/255.0f green:51.0f/255.0f blue:51.0f/255.0f alpha:1.0f] CGColor];
    CGColorRef bottomColor = [[UIColor colorWithRed:48.0f/255.0f green:48.0f/255.0f blue:48.0f/255.0f alpha:1.0f] CGColor];
    NSArray *array = [NSArray arrayWithObjects:(__bridge id)topColor, (__bridge id)bottomColor, nil];
    CFArrayRef colorArray = (__bridge CFArrayRef) array;
    
    CGFloat colorLocations[] = { 0.0f, 1.0f };
    
    CGGradientRef gradient = CGGradientCreateWithColors(colorSpace, colorArray, colorLocations);
    
    CGRect frame = view.frame;
    CGPoint startPoint = CGPointMake(CGRectGetMidX(frame), CGRectGetMinY(frame));
    CGPoint endPoint = CGPointMake(CGRectGetMidX(frame), CGRectGetMaxY(frame));
    
    CGContextSaveGState(context);
    CGContextAddRect(context, frame);
    CGContextClip(context);
    CGContextDrawLinearGradient(context, gradient, startPoint, endPoint, 0);
    CGContextRestoreGState(context);
    
    CFRelease(colorArray);
    CGGradientRelease(gradient);
    CGColorSpaceRelease(colorSpace);
    
}

@end