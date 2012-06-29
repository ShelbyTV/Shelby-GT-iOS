//
//  GuideTableViewController.m
//  Shelby-tv
//
//  Created by Arthur Ariel Sabintsev on 4/19/12.
//  Copyright (c) 2012 Shelby.tv. All rights reserved.
//

#import "GuideTableViewController.h"
#import "ShelbyMenuViewController.h"
#import "TableViewManagers.h"

@interface GuideTableViewController ()

@property (assign, nonatomic) GuideType type;
@property (strong, nonatomic) GuideTableViewManager *tableViewManager;
@property (assign, nonatomic) BOOL firstLoad;
@property (strong, nonatomic) NSString *rollID;

/// Creation Methods
- (GuideTableViewManager*)createTableViewManager;
- (void)createView;

@end

@implementation GuideTableViewController
@synthesize menuController = menuController;
@synthesize type = _guideType;
@synthesize tableViewManager = _tableViewManager;
@synthesize rollID = _rollID;
@synthesize navigationController = _navigationController;

#pragma mark - Initialization Method
- (id)initWithType:(GuideType)type
{
    
    if ( self = [super init] ) {
        
        // Set Type of GuideTableViewController Instance
        self.type = type;
        
        // Initialize appropriate tableViewManager
        self.tableViewManager = [self createTableViewManager];
        
        // Pass instance of this controller to manager
        self.tableViewManager.guideController = self;
        
        // Customize tableView
        self.view.backgroundColor = ColorConstants_BackgroundColor;
        self.tableView.backgroundColor = ColorConstants_BackgroundColor;
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        self.tableView.delegate = (id)self.tableViewManager;
        self.tableView.dataSource = (id)self.tableViewManager;
        self.refreshDelegate = (id)self.tableViewManager;
        self.tableViewManager.refreshController = self;

    }
    
    return  self;
}

- (id)initWithType:(GuideType)type andRollID:(NSString *)rollID
{
    
    if ( self = [super init] ) {
        
        // Set type of GuideTableViewController Instance
        self.type = type;
        
        // Set rollID for API call to display videos/frames for correct roll
        self.rollID = rollID;
        
        // Initialize appropriate tableViewManager
        self.tableViewManager = [self createTableViewManager];
        
        // Customize tableView
        self.view.backgroundColor = ColorConstants_BackgroundColor;
        self.tableView.backgroundColor = ColorConstants_BackgroundColor;
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        self.tableView.delegate = (id)self.tableViewManager;
        self.tableView.dataSource = (id)self.tableViewManager;
        self.refreshDelegate = (id)self.tableViewManager;
        self.tableViewManager.refreshController = self;
        
        // Load data
        [self.tableViewManager loadDataFromCoreData];
    }
    
    return  self;
}

#pragma mark - View Lifecycle Methods
- (void)viewDidLoad
{                           
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];  
    [self createView];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

#pragma mark -  Customization Methods
- (GuideTableViewManager*)createTableViewManager
{
    
    GuideTableViewManager *manager;
    
    switch ( self.type ) {
            
        case GuideType_BrowseRolls:{
           manager = [[BrowseRollsTableViewManager alloc] init];
        } break;
            
        case GuideType_MyRolls:{
            manager = [[MyRollsTableViewManager alloc] init];
        } break;
            
        case GuideType_PeopleRolls:{
            manager = [[PeopleRollsTableViewManager alloc] init];
        } break;
            
        case GuideType_Settings:{
            // Do nothing
        } break;
            
        case GuideType_Stream:{
            manager = [[StreamTableViewManager alloc] init];
        } break;
            
        case GuideType_RollFrames:{
            manager = [[RollFramesTableViewManager alloc] init];
            manager.rollID = self.rollID;
        } break;
            
        default:
            break;
    }
    
    return manager;
    
}

- (void)createView
{
    
    // Set section-specific UI properties
    switch ( self.type ) {
            
        case GuideType_BrowseRolls:{
       
            [self.menuController.browseRollsButton setHighlighted:YES];
            
        } break;
            
        case GuideType_MyRolls:{
            
            [self.menuController.myRollsButton setHighlighted:YES];
            
        } break;
            
        case GuideType_PeopleRolls:{
            
            [self.menuController.peopleRollsButton setHighlighted:YES];
            
        } break;
            
        case GuideType_Settings:{
            
            [self.menuController.settingsButton setHighlighted:YES];
            
        } break;
            
        case GuideType_Stream:{
            
            [self.menuController.streamButton setHighlighted:YES];
            
        } break;
            
        default:
            break;
    }
    
    // Call API and Core Data in section's tableViewManager
    if ( [SocialFacade sharedInstance].shelbyAuthorized ) [self.tableViewManager loadDataOnInitializationForTableView:self.tableView];

}

#pragma mark - ShelbyMenuDelegate Methods
- (void)browseRollsButtonAction
{
    [self.menuController browseRollsButtonAction];
}

- (void)myRollsButtonAction
{
    [self.menuController myRollsButtonAction];
}

- (void)peopleRollsButtonAction
{
    [self.menuController peopleRollsButtonAction];
}

- (void)settingsButtonAction
{
    [self.menuController settingsButtonAction];
}

- (void)streamButtonAction
{
    [self.menuController streamButtonAction];
}


#pragma mark - Interface Orientation Method
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end