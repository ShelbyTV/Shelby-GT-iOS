//
//  ShareViewController.m
//  Shelby-tv
//
//  Created by Arthur Ariel Sabintsev on 5/1/12.
//  Copyright (c) 2012 Shelby.tv. All rights reserved.
//

#import "ShareViewController.h"

@interface ShareViewController ()

@end

@implementation ShareViewController

#pragma mark - View Lifecycle Methods
- (void)viewDidUnload
{
    
    [super viewDidUnload];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationItem.title = @"Share";
}

#pragma mark - Interface Orientation Method
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end