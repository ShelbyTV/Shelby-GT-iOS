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
    
    CGFloat colorLocations[] = { 0.0f, 1.0f };

    CGFloat topColorComponents[] = {51.0f/255.0f, 51.0f/255.0f, 51.0f/255.0f, 1.0f};
    CGFloat bottomColorComponents[] = {48.0f/255.0f, 48.0f/255.0f, 48.0f/255.0f, 1.0f};
    CGColorRef topColor = CGColorCreate(colorSpace, topColorComponents);
    CGColorRef bottomColor = CGColorCreate(colorSpace, bottomColorComponents);

    CFMutableArrayRef colorArray = CFArrayCreateMutable(NULL, 2, &kCFTypeArrayCallBacks);
    CFArrayAppendValue(colorArray, topColor);
    CFArrayAppendValue(colorArray, bottomColor);
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