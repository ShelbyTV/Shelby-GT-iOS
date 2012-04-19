//
//  StoryViewController.m
//  Shelby-tv
//
//  Created by Arthur on 4/19/12.
//  Copyright (c) 2012 Shelby.tv. All rights reserved.
//

#import "StoryViewController.h"

@interface StoryViewController ()

@end

@implementation StoryViewController
@synthesize storyType;

#pragma mark - View Lifecycle Methods
- (void)viewDidUnload
{
    [super viewDidUnload];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    switch (self.storyType) {
            
        case StoryTypeTimeline:
            break;
    
        case StoryTypeFavorites:
            break;
        
        case StoryTypeWatchLater:
            break;
        
        case StoryTypeSearch:
            break;
        
        default:
            break;
   
    }
    
}

#pragma mark - PullToRefresh Method
- (void)dataToRefresh
{
    [[NSNotificationCenter defaultCenter] postNotificationName:kDidFinishRefreshing object:nil];   
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end