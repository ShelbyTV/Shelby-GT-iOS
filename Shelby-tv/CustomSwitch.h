//
//  CustomSwitch.h
//
//  Created by Hardy Macia on 10/28/09.
//  Copyright 2009 Catamount Software. All rights reserved.
//
//  Code can be freely redistruted and modified as long as the above copyright remains.
//

#import <Foundation/Foundation.h>


@interface CustomSwitch : UISlider {
	
    BOOL on;
	UIColor *tintColor;
	UIView *clippingView;
	UILabel *rightLabel;
	UILabel *leftLabel;
	
}

@property (nonatomic, getter=isOn) BOOL on;
@property (strong, nonatomic) UIColor *tintColor;
@property (strong, nonatomic) UIView *clippingView;
@property (strong, nonatomic) UILabel *rightLabel;
@property (strong, nonatomic) UILabel *leftLabel;

- (void)setOn:(BOOL)on animated:(BOOL)animated;
- (void)scaleSwitch:(CGSize)newSize;

@end
