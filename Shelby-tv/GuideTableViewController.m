//
//  GuideTableViewController.m
//  Shelby-tv
//
//  Created by Arthur Ariel Sabintsev on 4/19/12.
//  Copyright (c) 2012 Shelby.tv. All rights reserved.
//

#import "GuideTableViewController.h"
#import "TableViewManagers.h"
#import "ShelbyMenuView.h"

@interface GuideTableViewController ()

@property (assign, nonatomic) GuideType guideType;
@property (strong, nonatomic) GuideTableViewManager *guideTableViewManager;
@property (strong, nonatomic) ShelbyMenuView *menuView;
@property (strong, nonatomic) StreamTableViewManager *streamtableViewManager;
@property (strong, nonatomic) PeopleRollsTableViewManager *peopleRollsTableViewManager;
@property (strong, nonatomic) MyRollsTableViewManager *myRollsTableViewManager;
@property (strong, nonatomic) BrowseRollsTableViewManager *browseRollsTableViewManager;
@property (strong, nonatomic) SettingsTableViewManager *settingsTableViewManager;

/// Controller Customization Methods
- (void)loadWithType:(GuideType)type forTableViewManager:(GuideTableViewManager*)manager withPullToRefreshEnabled:(BOOL)refreshEnabled;

/// View Customization Methods
- (void)customizeOnViewLoad;
- (void)customizeOnViewAppear;

/// Animation Methods
- (void)fadeInAnimation;
- (void)fadeOutAnimation;

@end

@implementation GuideTableViewController
@synthesize guideType = _guideType;
@synthesize guideTableViewManager = _guideTableViewManager;
@synthesize menuView = _menuView;

#pragma mark - Initialization Methods
- (id)initWithGuideType:(GuideType)type
{
    if ( self = [super init] ) {
        
        self.guideType = type;
    
    }
    
    return self;
}

#pragma mark - View Lifecycle Methods
- (void)viewDidLoad
{
    
    [super viewDidLoad];
    [self customizeOnViewLoad];

}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];  
    [self customizeOnViewAppear];
}


- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

#pragma mark - View Customization Methods
- (void)customizeOnViewLoad
{
    self.browseRollsTableViewManager = [[BrowseRollsTableViewManager alloc] init];
    self.myRollsTableViewManager = [[MyRollsTableViewManager alloc] init];
    self.peopleRollsTableViewManager = [[PeopleRollsTableViewManager alloc] init];
    self.settingsTableViewManager = [[SettingsTableViewManager alloc] init];
    self.streamtableViewManager = [[StreamTableViewManager alloc] init];
}

- (void)customizeOnViewAppear
{
    
    // Add menuView over navigationBar
    NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"ShelbyMenuView" owner:self options:nil];
    self.menuView = (ShelbyMenuView*)[nib objectAtIndex:0];
    [self.navigationController.navigationBar addSubview:self.menuView];  
    
    if ( [SocialFacade sharedInstance].shelbyAuthorized ) { // If user is authorized with Shelby, populate tableViewManager data from API and Core Data

        [self fadeInAnimation];
        
        switch (self.guideType) {
                
            case GuideType_BrowseRolls: {
                
                [self browseRollsButton];
                [self.guideTableViewManager loadDataOnInitializationForTableView:self.tableView];
                
                
            } break;
                
            case GuideType_MyRolls: {
                
                [self myRollsButton];
                [self.guideTableViewManager loadDataOnInitializationForTableView:self.tableView];
                
                
            } break;
                
            case GuideType_PeopleRolls: {
                
                [self peopleRollsButton];
                [self.guideTableViewManager loadDataOnInitializationForTableView:self.tableView];
                
                
            } break;
                
            case GuideType_Settings: {
                
                [self settingsButton];
                [self.guideTableViewManager loadDataOnInitializationForTableView:self.tableView];
                
                
            } break;
                
            case GuideType_Stream: {
                
                [self streamButton];
                [self.guideTableViewManager loadDataOnInitializationForTableView:self.tableView];

                
            } break;
                
            default:
                break;
        }
    
    }
    
}


#pragma mark - Interface Methods
- (IBAction)browseRollsButton
{
    [self loadWithType:GuideType_BrowseRolls forTableViewManager:self.browseRollsTableViewManager withPullToRefreshEnabled:NO];
}

- (IBAction)myRollsButton
{
    [self loadWithType:GuideType_MyRolls forTableViewManager:self.myRollsTableViewManager withPullToRefreshEnabled:NO];
}

- (IBAction)peopleRollsButton
{
    [self loadWithType:GuideType_PeopleRolls forTableViewManager:self.peopleRollsTableViewManager withPullToRefreshEnabled:NO];
}

- (IBAction)settingsButton
{
    [self loadWithType:GuideType_Settings forTableViewManager:self.settingsTableViewManager withPullToRefreshEnabled:NO];
}

- (IBAction)streamButton
{
    [self loadWithType:GuideType_Stream forTableViewManager:self.streamtableViewManager withPullToRefreshEnabled:NO];
}

#pragma mark - Controller Customization Methods
- (void)loadWithType:(GuideType)type forTableViewManager:(GuideTableViewManager *)manager withPullToRefreshEnabled:(BOOL)refreshEnabled
{
    // Customize tableView
    self.view.backgroundColor = ColorConstants_BackgroundColor;
    self.tableView.backgroundColor = ColorConstants_BackgroundColor;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    // Set Type of GuideTableViewController Instance
    self.guideType = type;
    
    // Set TableViewManager (e.g., TableViewDataSource and TableViewDelegate) of StoryViewController instance
    self.guideTableViewManager = manager;
    self.tableView.delegate = (id)self.guideTableViewManager;
    self.tableView.dataSource = (id)self.guideTableViewManager;
    
    // Set Reference to ASPullToRefreshTableViewController
    if ( refreshEnabled ) {
        
        self.guideTableViewManager.refreshController = self;
        self.guideTableViewManager.tableView = self.tableView;
        self.refreshDelegate = (id)self.guideTableViewManager;
        
    }
    
    // Refresh tableView with information from new delegate and dataSource
    [self.tableView reloadData];
}

#pragma mark - Animation Methods
- (void)fadeInAnimation
{

    [self.navigationController.navigationBar setAlpha:0.25f];
    [self.tabBarController.tabBar setAlpha:0.25f];
    [self.tableView setAlpha:0.25f];
    [UIView animateWithDuration:1.0f animations:^{
        [self.navigationController.navigationBar setAlpha:1.0f];
        [self.tabBarController.tabBar setAlpha:1.0f];
        [self.tableView setAlpha:1.0f];
    }];
}

- (void)fadeOutAnimation
{
    
}

#pragma mark - Interface Orientation Method
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end