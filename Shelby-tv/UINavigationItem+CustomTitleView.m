//
//  UINavigationItem+CustomTitleView.m
//  Shelby.tv
//
//  Created by Arthur Ariel Sabintsev on 5/3/12.
//  Copyright (c) 2012 Shelby.tv. All rights reserved.
//

#import "UINavigationItem+CustomTitleView.h"

@implementation UINavigationItem (CustomTitleView)

+ (UILabel*)titleViewWithTitle:(NSString*)title
{
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(100.0f, 0.0f, 180.0f, 44.0f)];    
    label.backgroundColor = [UIColor clearColor];
    label.textColor = [UIColor whiteColor];
    label.font = [UIFont fontWithName:@"Ubuntu-Bold" size:19];
    label.textAlignment = UITextAlignmentCenter;
    label.text = title;
    
    return label;
}

@end