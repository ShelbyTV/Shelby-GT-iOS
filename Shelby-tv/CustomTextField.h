//
//  CustomTextField.h
//  Contain
//
//  Created by Arthur Ariel Sabintsev on 3/6/12.
//  Copyright (c) 2012 Shelby.tv. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CustomTextField : UITextField

// Override placeholder drawing method to support custom color and fonts 
- (void)drawPlaceholderInRect:(CGRect)rect;

@end
