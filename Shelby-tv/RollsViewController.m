//
//  RollsViewController.m
//  Shelby-tv
//
//  Created by Arthur Ariel Sabintsev on 4/30/12.
//  Copyright (c) 2012 Shelby.tv. All rights reserved.
//

#import "RollsViewController.h"

@interface RollsViewController ()

@property (strong, nonatomic) GuideTableViewManager *guideTableViewManager;
@property (strong, nonatomic) UITabBarController *appDelegateTabBarController;
@property (strong, nonatomic) UINavigationController *appDelegateNavigationController;

- (void)customizeOnViewLoad;

@end

@implementation RollsViewController
@synthesize tableView = _tableView;
@synthesize rollsType = _rollsType;
@synthesize guideTableViewManager = _guideTableViewManager;
@synthesize appDelegateTabBarController = _appDelegateTabBarController;
@synthesize appDelegateNavigationController = _appDelegateNavigationController;

#pragma mark - View Lifecycle Methods
- (void)viewDidUnload
{
    [super viewDidUnload];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Customize for instance of GuideTableViewManager
    [self customizeOnViewLoad];
}

#pragma mark - Private Methods
- (void)customizeOnViewLoad
{
    
    switch (self.rollsType) {
            
        case RollsTypeYour: {
            
            // Set Title on navigationController's navigationBar
            self.navigationController.navigationBar.topItem.title = @"Your Rolls";
            
            // Set TableViewManager (e.g., TableViewDataSource and TableViewDelegate) of StoryViewController instance
            self.guideTableViewManager = [[YourRollsTableViewManager alloc] init];
            self.tableView.delegate = (id)self.guideTableViewManager;
            self.tableView.dataSource = (id)self.guideTableViewManager;
            
            // Set Reference to ASPullToRefreshTableViewController
            self.guideTableViewManager.refreshController = self;
            self.refreshDelegate = (id)self.guideTableViewManager;
            
        } break;
            
        case RollsTypePeople:
            
            // Set Title on navigationController's navigationBar
            self.navigationController.navigationBar.topItem.title = @"People's Rolls";
            
            // Set TableViewManager (e.g., TableViewDataSource and TableViewDelegate) of StoryViewController instance
            self.guideTableViewManager = [[PeopleRollsTableViewManager alloc] init];
            self.tableView.delegate = (id)self.guideTableViewManager;
            self.tableView.dataSource = (id)self.guideTableViewManager;
            
            // Set Reference to ASPullToRefreshTableViewController
            self.guideTableViewManager.refreshController = self;
            self.refreshDelegate = (id)self.guideTableViewManager;
            
            break;
            
        case RollsTypePopular:
            
            // Set Title on navigationController's navigationBar
            self.navigationController.navigationBar.topItem.title = @"Popular Rolls";
            
            // Set TableViewManager (e.g., TableViewDataSource and TableViewDelegate) of StoryViewController instance
            self.guideTableViewManager = [[PopularRollsTableViewManager alloc] init];
            self.tableView.delegate = (id)self.guideTableViewManager;
            self.tableView.dataSource = (id)self.guideTableViewManager;
            
            // Set Reference to ASPullToRefreshTableViewController
            self.guideTableViewManager.refreshController = self;
            self.refreshDelegate = (id)self.guideTableViewManager;
            
            break;
            
        default:
            break;
    }
    
}

#pragma mark - Interface Orientation Method
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end