//
//  NewRollViewController.m
//  Shelby-tv
//
//  Created by Arthur Ariel Sabintsev on 5/1/12.
//  Copyright (c) 2012 Shelby.tv. All rights reserved.
//

#import "NewRollViewController.h"

@interface NewRollViewController ()

@end

@implementation NewRollViewController

#pragma mark - View Lifecycle Methods
- (void)viewDidUnload
{
    
    [super viewDidUnload];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationItem.title = @"New Roll";
    
}

#pragma mark - Interface Orientation Method
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end