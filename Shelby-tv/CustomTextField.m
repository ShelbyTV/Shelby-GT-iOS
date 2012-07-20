//
//  CustomTextField.h
//  Contain
//
//  Created by Arthur Ariel Sabintsev on 3/6/12.
//  Copyright (c) 2012 Shelby.tv. All rights reserved.
//

#import "CustomTextField.h"

@implementation CustomTextField

- (void)drawPlaceholderInRect:(CGRect)rect 
{
    // Set Color
    [[UIColor lightGrayColor] setFill];
    
    // Set Font
    UIFont *font = [UIFont fontWithName:@"Ubuntu" size:14.0f];
    
    // Create new placeholder
    [self.placeholder drawInRect:rect withFont:font];
}

@end
