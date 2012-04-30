//
//  RollsViewController.m
//  Shelby-tv
//
//  Created by Arthur Ariel Sabintsev on 4/30/12.
//  Copyright (c) 2012 Shelby.tv. All rights reserved.
//

#import "RollsViewController.h"
#import "GuideViewController.h"

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
    
    // Customize instance of GuideTableViewManager
    [self customizeOnViewLoad];
}

#pragma mark - Private Methods
- (void)customizeOnViewLoad
{
    switch (self.rollsType) {
            
        case RollsTypeYour:{
            
            // Set title on navigationController's navigationBar
            self.title = @"Your Rolls";
            
            // Set TableViewManager (e.g., TableViewDataSource and TableViewDelegate) of GuideViewController instance
            self.guideTableViewManager = [[YourRollsTableViewManager alloc] init];
            GuideViewController *guideViewController = [[GuideViewController alloc] initWithGuideType:GuideTypeRolls andTableViewManager:self.guideTableViewManager];
            self.tableView = guideViewController.tableView;
        
        } break;
            
        case RollsTypePeople:
            
            // Set title on navigationController's navigationBar
            self.title = @"People's Rolls";
            
            break;
            
        case RollsTypePopular:
            
            // Set title on navigationController's navigationBar
            self.navigationController.navigationBar.topItem.title = @"Popular Rolls";
            
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