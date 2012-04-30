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

@property (strong, nonatomic) UISegmentedControl *segmentedController;
@property (strong, nonatomic) UITableView *tableView;
@property (assign, nonatomic) RollsType rollsType;
@property (strong, nonatomic) GuideTableViewManager *guideTableViewManager;
@property (strong, nonatomic) GuideTableViewController *guideTableViewController;

- (void)buildSegmentedControl;
- (void)buildTableView;
- (void)presentProperRollsType;

@end

@implementation RollsTableViewController
@synthesize segmentedController = _segmentedController;
@synthesize tableView = _tableView;
@synthesize rollsType = _rollsType;
@synthesize guideTableViewManager = _guideTableViewManager;
@synthesize guideTableViewController = _guideTableViewController;

- (id)initWithRollsType:(RollsType)type
{
    if ( self = [super init] ) {
        
        self.rollsType = type;
        [self presentProperRollsType];
    
    }
    
    return self;
}

#pragma mark - View Lifecycle Methods
- (void)viewDidLoad
{
    [super viewDidLoad];
}

#pragma mark - Private Methods
- (void)presentProperRollsType
{
    
    // Build UISegmentedControl
    [self buildSegmentedControl];
    
    // Perform ViewController Customization based on value of rollsType
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
    
    // Reference and customize UITableView
    [self buildTableView];
    
}

- (void)buildSegmentedControl
{
    
    // Initialize UIView to encase segmentedController
    UIView *segmentedControllerView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 320.0f, 64.0f)];
    
    // Initialize segmentedController with items and center object within segmentedControllerView's frame
    NSArray *segmentedControllerItemsArray = [NSArray arrayWithObjects:@"Your Rolls", @"People's Rolls", @"Popular Rolls", nil];
    self.segmentedController = [[UISegmentedControl alloc] initWithItems:segmentedControllerItemsArray];
    [self.segmentedController setSegmentedControlStyle:UISegmentedControlStyleBar];
    
    NSLog(@"\n%@: %@\n%@:%@", segmentedControllerView, NSStringFromCGRect(segmentedControllerView.frame), self.segmentedController, NSStringFromCGRect(self.segmentedController.frame));

    
    [self.segmentedController setFrame:CGRectMake(segmentedControllerView.frame.size.width/2.0f - self.segmentedController.frame.size.width/2.0f, 
                                                  segmentedControllerView.frame.size.height/3.0f - self.segmentedController.frame.size.height/2.0f, 
                                                  self.segmentedController.frame.size.width, 
                                                  self.segmentedController.frame.size.height)];    
    [segmentedControllerView addSubview:self.segmentedController];

    NSLog(@"\n%@: %@\n%@:%@", segmentedControllerView, NSStringFromCGRect(segmentedControllerView.frame), self.segmentedController, NSStringFromCGRect(self.segmentedController.frame));
    
    // Add segmentedControllerView to ViewController's view hierarchy
    [self.view addSubview:segmentedControllerView];
}

- (void)buildTableView
{
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