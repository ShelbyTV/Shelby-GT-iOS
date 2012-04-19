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
@property (strong, nonatomic) StoryTableViewManager *storyTableViewManager;

@end

@implementation StoryViewController
@synthesize storyType = _storyType;
@synthesize storyTableViewManager = _storyTableViewManager;

#pragma mark - Initialization Method
- (id)initWithType:(StoryType)type andTableViewManager:(StoryTableViewManager *)manager
{
    
    if ( self = [super init] ) {
        
        self.storyType = type;
        self.storyTableViewManager = manager;
        self.tableView.delegate = (id)self.storyTableViewManager;
        self.tableView.dataSource = (id)self.storyTableViewManager;
        
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

#pragma mark - Interface Orientation Method
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end