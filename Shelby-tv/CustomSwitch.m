//
//  CustomSwitch.m
//
//  Created by Hardy Macia on 10/28/09.
//  Copyright 2009 Catamount Software. All rights reserved.
//
//  Code can be freely redistruted and modified as long as the above copyright remains.
//

#import "CustomSwitch.h"

@interface CustomSwitch ()
{
    BOOL m_touchedSelf;
}

@end

@implementation CustomSwitch

@synthesize on;
@synthesize tintColor;
@synthesize clippingView;
@synthesize leftLabel;
@synthesize rightLabel;

- (id)initWithFrame:(CGRect)rect
{
	if ( self = [super initWithFrame:CGRectMake(rect.origin.x,rect.origin.y,95,27)] ) {
	
        [self awakeFromNib];
	
    }
	
    return self;
}

- (void)awakeFromNib
{
	[super awakeFromNib];
	
	self.backgroundColor = [UIColor clearColor];

	[self setThumbImage:[UIImage imageNamed:@"switchUnLock"] forState:UIControlStateNormal];
	[self setMinimumTrackImage:[UIImage imageNamed:@"switchBackground"] forState:UIControlStateNormal];
	[self setMaximumTrackImage:[UIImage imageNamed:@"switchBackground"] forState:UIControlStateNormal];
	
	self.minimumValue = 0;
	self.maximumValue = 1;
	self.continuous = NO;
	
	self.on = NO;
	self.value = 0.0f;
	
	self.clippingView = [[UIView alloc] initWithFrame:CGRectMake(4.0f, 0.0f, 107.0f, 27.0f)];
	self.clippingView.clipsToBounds = YES;
	self.clippingView.userInteractionEnabled = NO;
	self.clippingView.backgroundColor = [UIColor clearColor];
	[self addSubview:self.clippingView];

	
	self.leftLabel = [[UILabel alloc] init];
	self.leftLabel.frame = CGRectMake(0.0f, 0.0f, 121.0f, 24.0f);
	self.leftLabel.text = @"Private";
	self.leftLabel.textAlignment = UITextAlignmentCenter;
	self.leftLabel.font = [UIFont fontWithName:@"Ubuntu-Bold" size:14.0f];
	self.leftLabel.textColor = [UIColor whiteColor];
	self.leftLabel.backgroundColor = [UIColor clearColor];
	[self.clippingView addSubview:self.leftLabel];

	
	self.rightLabel = [[UILabel alloc] init];
	self.rightLabel.frame = CGRectMake(121.0f, 0.0f, 121.0f, 24.0f);
	self.rightLabel.text = @"Public";
	self.rightLabel.textAlignment = UITextAlignmentCenter;
	self.rightLabel.font = [UIFont fontWithName:@"Ubuntu-Bold" size:14.0f];
	self.rightLabel.textColor = [UIColor whiteColor];
	self.rightLabel.backgroundColor = [UIColor clearColor];
	[self.clippingView addSubview:self.rightLabel];
	
	
}

- (void)layoutSubviews
{
	[super layoutSubviews];
	
	[self.clippingView removeFromSuperview];
	[self addSubview:self.clippingView];
	
	CGFloat thumbWidth = self.currentThumbImage.size.width;
	CGFloat switchWidth = self.bounds.size.width;
	CGFloat labelWidth = switchWidth - thumbWidth;
	CGFloat inset = self.clippingView.frame.origin.x;
	
	//	NSInteger xPos = self.value * (self.bounds.size.width - thumbWidth) - (self.leftLabel.frame.size.width - thumbWidth/2); 
	NSInteger xPos = self.value * labelWidth - labelWidth - inset;
	self.leftLabel.frame = CGRectMake(xPos, 0.0f, labelWidth, 24.0f);
	
	//	xPos = self.value * (self.bounds.size.width - thumbWidth) + (self.rightLabel.frame.size.width - thumbWidth/2); 
	xPos = switchWidth + (self.value * labelWidth - labelWidth) - inset; 
	self.rightLabel.frame = CGRectMake(xPos, 0.0f, labelWidth, 24.0f);

}

- (void)scaleSwitch:(CGSize)newSize 
{
	self.transform = CGAffineTransformMakeScale(newSize.width,newSize.height);
}

- (void)setOn:(BOOL)turnOn animated:(BOOL)animated;
{
    
	on = turnOn;
	
	if (animated)
	{
		[UIView	 beginAnimations:@"CustomSwitch" context:nil];
		[UIView setAnimationDuration:0.2];
	}
	
	if (on) {
		self.value = 1.0;
        [self setThumbImage:[UIImage imageNamed:@"switchLock"] forState:UIControlStateNormal];
        
	} else {
        
		self.value = 0.0;
        [self setThumbImage:[UIImage imageNamed:@"switchUnlock"] forState:UIControlStateNormal];
	
    }
	
	if (animated)
	{
		[UIView	commitAnimations];	
	}
}

- (void)setOn:(BOOL)turnOn
{
	[self setOn:turnOn animated:NO];
}


- (void)endTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event
{
	[super endTrackingWithTouch:touch withEvent:event];
	m_touchedSelf = YES;
	
	[self setOn:on animated:YES];
}

- (void)touchesBegan:(NSSet*)touches withEvent:(UIEvent*)event
{
	[super touchesBegan:touches withEvent:event];
	m_touchedSelf = NO;
	on = !on;
}

- (void)touchesEnded:(NSSet*)touches withEvent:(UIEvent*)event
{
	[super touchesEnded:touches withEvent:event];
	
	if (!m_touchedSelf)
	{
		[self setOn:on animated:YES];
		[self sendActionsForControlEvents:UIControlEventValueChanged];
	}
}

@end