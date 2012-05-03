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
- (IBAction)segmentedControllerValueDidChange:(id)sender;

@end

@implementation RollsTableViewController
@synthesize navigationController = _navigationController;
@synthesize segmentedController = _segmentedController;
@synthesize tableView = _tableView;
@synthesize rollsType = _rollsType;
@synthesize guideTableViewManager = _guideTableViewManager;
@synthesize guideTableViewController = _guideTableViewController;

- (id)initWithRollsType:(RollsType)type
{
    if ( self = [super init] ) {
        
        self.rollsType = type;
    
    }
    
    return self;
}

#pragma mark - View Lifecycle Methods
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Build UISegmentedControl
    [self buildSegmentedControl];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    // Present Proper Rolls View to user
    [self presentProperRollsType];
}

#pragma mark - Private Methods
- (void)presentProperRollsType
{
    
    // Perform ViewController Customization based on value of rollsType
    switch (self.rollsType) {
            
        case RollsTypeYour:{
            
            // Set title on navigationController's navigationBar
            [self.navigationItem setTitleView:[UINavigationItem titleViewWithTitle:kYourRolls]];
            
            // Set proper selected state for segmentedController
            [self.segmentedController setSelectedSegmentIndex:0];
            
            // Initialize appropriate GuideTableViewManager 
            self.guideTableViewManager = [[YourRollsTableViewManager alloc] init];
            

        } break;
            
        case RollsTypePeople:
            
            // Set title on navigationController's navigationBar
            [self.navigationItem setTitleView:[UINavigationItem titleViewWithTitle:kPeoplesRolls]];
            
            // Set proper selected state for segmentedController
            [self.segmentedController setSelectedSegmentIndex:1];
            
            
            // Initialize appropriate GuideTableViewManager 
            self.guideTableViewManager = [[PeopleRollsTableViewManager alloc] init];
            
            break;
            
        case RollsTypePopular:
            
            // Set title on navigationController's navigationBar
            [self.navigationItem setTitleView:[UINavigationItem titleViewWithTitle:kPopularRolls]];
            
            // Set proper selected state for segmentedController
            [self.segmentedController setSelectedSegmentIndex:2];
            
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
    [segmentedControllerView setBackgroundColor:[UIColor lightGrayColor]];
    
    // Initialize segmentedController with items and center object within segmentedControllerView's frame
    NSArray *segmentedControllerItemsArray = [NSArray arrayWithObjects:kYourRolls, kPeoplesRolls, kPopularRolls, nil];
    self.segmentedController = [[UISegmentedControl alloc] initWithItems:segmentedControllerItemsArray];
    [self.segmentedController setSegmentedControlStyle:UISegmentedControlStyleBar];
    [self.segmentedController addTarget:self action:@selector(segmentedControllerValueDidChange:) forControlEvents:UIControlEventValueChanged];
    
    [self.segmentedController setFrame:CGRectMake(segmentedControllerView.frame.size.width/2.0f - self.segmentedController.frame.size.width/2.0f, 
                                                  segmentedControllerView.frame.size.height/3.0f - self.segmentedController.frame.size.height/2.0f, 
                                                  self.segmentedController.frame.size.width, 
                                                  self.segmentedController.frame.size.height)];    
    
    // Add segmentedControllerView to segmentedControllerView hierarchy
    [segmentedControllerView addSubview:self.segmentedController];

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

- (void)segmentedControllerValueDidChange:(id)sender
{

    if ( self.segmentedController == sender ) {
        
        // Set rollsType to segmentedController's selectedIndex
        // BE SURE THAT THE SEGMENTED INDEX ITEMS ARE IN THE SAME ORDER AS THE 'RollsType' struct
        self.rollsType = self.segmentedController.selectedSegmentIndex;
        
        // Present Proper Rolls Type on Value Change
        [self presentProperRollsType];
        
    }
}

#pragma mark - Interface Orientation Method
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end