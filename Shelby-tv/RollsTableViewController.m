//
//  RollsViewController.m
//  Shelby-tv
//
//  Created by Arthur Ariel Sabintsev on 4/30/12.
//  Copyright (c) 2012 Shelby.tv. All rights reserved.
//

#import "RollsTableViewController.h"
#import "GuideTableViewController.h"

@interface RollsTableViewController ()

@property (strong, nonatomic) UITableView *tableView;
@property (assign, nonatomic) RollsType rollsType;
@property (strong, nonatomic) GuideTableViewManager *guideTableViewManager;
@property (strong, nonatomic) GuideTableViewController *guideTableViewController;

- (void)presentProperRolls;

@end

@implementation RollsTableViewController
@synthesize tableView = _tableView;
@synthesize rollsType = _rollsType;
@synthesize guideTableViewManager = _guideTableViewManager;
@synthesize guideTableViewController = _guideTableViewController;

- (id)initWithRollsType:(RollsType)type
{
    if ( self = [super init] ) {
        
        self.rollsType = type;
        [self presentProperRolls];
    
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

#pragma mark - Private Methods
- (void)presentProperRolls
{
    switch (self.rollsType) {
            
        case RollsTypeYour:{
            
            // Set title on navigationController's navigationBar
            self.title = @"Your Rolls";
            
            // Initialize appropriate GuideTableViewManager 
            self.guideTableViewManager = [[YourRollsTableViewManager alloc] init];

        } break;
            
        case RollsTypePeople:
            
            // Set title on navigationController's navigationBar
            self.title = @"People's Rolls";
            
            // Initialize appropriate GuideTableViewManager 
            self.guideTableViewManager = [[PeopleRollsTableViewManager alloc] init];
            
            break;
            
        case RollsTypePopular:
            
            // Set title on navigationController's navigationBar
            self.navigationController.navigationBar.topItem.title = @"Popular Rolls";
            
            // Initialize appropriate GuideTableViewManager 
            self.guideTableViewManager = [[PopularRollsTableViewManager alloc] init];
            
            break;
            
        default:
            break;
    }
    
    // Initialize GuideTableViewController with GuideTableViewManager
    self.guideTableViewController = [[GuideTableViewController alloc] initWithGuideType:GuideTypeRolls andTableViewManager:self.guideTableViewManager];
    
    // Obtain reference to GuideTableViewController's tableView
    self.tableView = self.guideTableViewController.tableView;
    
    self.tableView.frame = CGRectMake(0.0f, 44.0f, 320.0f, 436.0f);
    
    // Add GuideTableViewController's tablView to RollsTableViewController's view
    [self.view addSubview:self.tableView];
    
}

#pragma mark - Interface Orientation Method
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end