//
//  StoryViewController.m
//  Shelby-tv
//
//  Created by Arthur Ariel Sabintsev on 4/19/12.
//  Copyright (c) 2012 Shelby.tv. All rights reserved.
//

#import "StoryViewController.h"
#import "StoryTableViewManager.h"

@interface StoryViewController ()

@property (assign, nonatomic) StoryType storyType;

@end

@implementation StoryViewController
@synthesize storyType;

#pragma mark - Initialization Method
- (id)initWithType:(StoryType)type andTableViewManager:(StoryTableViewManager *)manager
{
    if ( self = [super init] ) {
        
        self.storyType = type;
        self.tableView.delegate = (id)manager;
        self.tableView.dataSource = (id)manager;
        
    }
    
    return self;
}

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