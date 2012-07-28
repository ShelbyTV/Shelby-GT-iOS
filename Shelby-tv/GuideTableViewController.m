//
//  GuideTableViewController.m
//  Shelby.tv
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

- (GuideTableViewManager*)createTableViewManager;
- (void)changeMenuButtonState;
- (void)addCustomBackButton;

@end

@implementation GuideTableViewController
@synthesize type = _guideType;
@synthesize tableViewManager = _tableViewManager;
@synthesize rollID = _rollID;
@synthesize appDelegate = _appDelegate;
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
        
        // Reference AppDelegate
        self.appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
        
    }
    
    return  self;
}

- (id)initWithType:(GuideType)type navigationController:(UINavigationController*)navigationController andRollID:(NSString*)rollID;
{
    
    if ( self = [super init] ) {
        
        // Set type of GuideTableViewController Instance
        self.type = type;
        
        // Set rollID for API call to display videos/frames for correct roll
        self.rollID = rollID;
        
        // Initialize appropriate tableViewManager
        self.tableViewManager = [self createTableViewManager];
        
        // Pass instance of this controller to manager
        self.tableViewManager.guideController = self;
        
        // Pass instance of navigationController to manager
        self.tableViewManager.guideController.navigationController = navigationController;
        
        // Customize tableView
        self.view.backgroundColor = ColorConstants_BackgroundColor;
        self.tableView.backgroundColor = ColorConstants_BackgroundColor;
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        self.tableView.delegate = (id)self.tableViewManager;
        self.tableView.dataSource = (id)self.tableViewManager;
        self.refreshDelegate = (id)self.tableViewManager;
        self.tableViewManager.refreshController = self;
        
        // Reference AppDelegate
        self.appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
        
        // Load data
        [self.tableViewManager loadDataOnInitializationForTableView:self.tableView andRollID:self.rollID];
        
    }
    
    return  self;
}

#pragma mark - View Lifecycle Methods
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];  
    [self changeMenuButtonState];
    [self addCustomBackButton];
}

#pragma mark -  Customization Methods
- (GuideTableViewManager*)createTableViewManager
{
    
    GuideTableViewManager *manager;
    
    switch ( self.type ) {
            
        case GuideType_ExploreRolls:{
           manager = [[ExploreRollsTableViewManager alloc] init];
        } break;
            
        case GuideType_MyRolls:{
            manager = [[MyRollsTableViewManager alloc] init];
        } break;
            
        case GuideType_FriendsRolls:{
            manager = [[FriendsRollsTableViewManager alloc] init];
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

- (void)changeMenuButtonState
{
    
    // Set section-specific UI properties
    switch ( self.type ) {
            
        case GuideType_ExploreRolls:{
       
            [self.appDelegate.menuController.exploreRollsButton setHighlighted:YES];
            
        } break;
            
        case GuideType_MyRolls:{
            
            [self.appDelegate.menuController.myRollsButton setHighlighted:YES];
            
        } break;
            
        case GuideType_FriendsRolls:{
            
            [self.appDelegate.menuController.friendsRollsButton setHighlighted:YES];
            
        } break;
            
        case GuideType_Settings:{
            
            [self.appDelegate.menuController.settingsButton setHighlighted:YES];
            
        } break;
            
        case GuideType_Stream:{
            
            [self.appDelegate.menuController.streamButton setHighlighted:YES];
            
        } break;
            
        default:
            break;
    }
    
    // Call API and Core Data in section's tableViewManager
    if ( [SocialFacade sharedInstance].shelbyAuthorized ) [self.tableViewManager loadDataOnInitializationForTableView:self.tableView];

}

- (void)addCustomBackButton
{
    if ( self.type == GuideType_RollFrames ) {
    
        UIButton *backBarButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 51, 30)];
        [backBarButton setImage:[UIImage imageNamed:@"backButton"] forState:UIControlStateNormal];
        [backBarButton addTarget:self.navigationController action:@selector(popViewControllerAnimated:) forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem *backBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backBarButton];
        [self.navigationItem setHidesBackButton:YES];
        [self.navigationItem setLeftBarButtonItem:backBarButtonItem];
        
    }
}

#pragma mark - ShelbyMenuDelegate Methods
- (void)exploreRollsButtonAction
{
    [self.appDelegate.menuController exploreRollsButtonAction];
}

- (void)friendsRollsButtonAction
{
    [self.appDelegate.menuController friendsRollsButtonAction];
}

- (void)myRollsButtonAction
{
    [self.appDelegate.menuController myRollsButtonAction];
}

- (void)settingsButtonAction
{
    [self.appDelegate.menuController settingsButtonAction];
}

- (void)streamButtonAction
{
    [self.appDelegate.menuController streamButtonAction];
}

#pragma mark - Interface Orientation Method
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end