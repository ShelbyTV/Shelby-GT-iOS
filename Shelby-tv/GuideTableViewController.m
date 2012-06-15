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
@property (strong, nonatomic) ShelbyMenuView *menuView;
@property (strong, nonatomic) StreamTableViewManager *streamtableViewManager;
@property (strong, nonatomic) PeopleRollsTableViewManager *peopleRollsTableViewManager;
@property (strong, nonatomic) MyRollsTableViewManager *myRollsTableViewManager;
@property (strong, nonatomic) BrowseRollsTableViewManager *browseRollsTableViewManager;
@property (strong, nonatomic) SettingsTableViewManager *settingsTableViewManager;

/// Customization Methods
- (void)initalizeTableViewManagers;
- (void)initalizeMenuView;
- (void)loadWithType:(GuideType)type forTableViewManager:(GuideTableViewManager*)manager withPullToRefreshEnabled:(BOOL)refreshEnabled;
- (void)tableViewDelegatesWillChange;

/// Animation Methods
- (void)fadeInAnimation;
- (void)fadeOutAnimation;

@end

@implementation GuideTableViewController
@synthesize guideType = _guideType;
@synthesize menuView = _menuView;

#pragma mark - View Lifecycle Methods
- (void)viewDidLoad
{                           
    [super viewDidLoad];
    [self initalizeTableViewManagers];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];  
    [self initalizeMenuView];
    
    // Load Stream
    [self loadWithType:GuideType_Stream forTableViewManager:self.streamtableViewManager withPullToRefreshEnabled:YES];
    
}

#pragma mark -  Customization Methods
- (void)initalizeTableViewManagers
{
    self.browseRollsTableViewManager = [[BrowseRollsTableViewManager alloc] init];
    self.myRollsTableViewManager = [[MyRollsTableViewManager alloc] init];
    self.peopleRollsTableViewManager = [[PeopleRollsTableViewManager alloc] init];
    self.settingsTableViewManager = [[SettingsTableViewManager alloc] init];
    self.streamtableViewManager = [[StreamTableViewManager alloc] init];
}

- (void)initalizeMenuView
{
    
    // Add menuView over navigationBar
    NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"ShelbyMenuView" owner:self options:nil];
    self.menuView = (ShelbyMenuView*)[nib objectAtIndex:0];
    [self.navigationController.navigationBar addSubview:self.menuView];

}


#pragma mark - Action Methods
- (void)loadWithType:(GuideType)type forTableViewManager:(GuideTableViewManager *)manager withPullToRefreshEnabled:(BOOL)refreshEnabled
{
    
    // Set Type of GuideTableViewController Instance
    self.guideType = type;
    
    // Customize tableView
    self.view.backgroundColor = ColorConstants_BackgroundColor;
    self.tableView.backgroundColor = ColorConstants_BackgroundColor;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.delegate = (id)manager;
    self.tableView.dataSource = (id)manager;
    
    // Set Reference to ASPullToRefreshTableViewController
    if ( refreshEnabled ) {
        
        manager.refreshController = self;
        self.refreshDelegate = (id)manager;
        
    } else {
        
        self.refreshDelegate = nil;
        
    }
    
    [self fadeInAnimation];
    
    if ( [SocialFacade sharedInstance].shelbyAuthorized ) [manager loadDataOnInitializationForTableView:self.tableView];
    
}

- (void)tableViewDelegatesWillChange
{
    
    [self fadeOutAnimation];
    switch (self.guideType) {
        case GuideType_BrowseRolls:
            [self.browseRollsTableViewManager.refreshController didFinishRefreshing];
            break;
        case GuideType_MyRolls:
            [self.myRollsTableViewManager.refreshController didFinishRefreshing];
            break;
        case GuideType_PeopleRolls:
            [self.peopleRollsTableViewManager.refreshController didFinishRefreshing];
            break;
        case GuideType_Settings:
            break;
        case GuideType_Stream:
            [self.streamtableViewManager.refreshController didFinishRefreshing];
            break;
        default:
            break;
    }
    
}

- (IBAction)browseRollsButton
{
    [self tableViewDelegatesWillChange];
    [self loadWithType:GuideType_BrowseRolls forTableViewManager:self.browseRollsTableViewManager withPullToRefreshEnabled:YES];
}

- (IBAction)myRollsButton
{
    [self tableViewDelegatesWillChange];
    [self loadWithType:GuideType_MyRolls forTableViewManager:self.myRollsTableViewManager withPullToRefreshEnabled:YES];
}

- (IBAction)peopleRollsButton
{
    [self tableViewDelegatesWillChange];
    [self loadWithType:GuideType_PeopleRolls forTableViewManager:self.peopleRollsTableViewManager withPullToRefreshEnabled:YES];
}

- (IBAction)settingsButton
{
    [self tableViewDelegatesWillChange];
    [self loadWithType:GuideType_Settings forTableViewManager:self.settingsTableViewManager withPullToRefreshEnabled:NO];
}

- (IBAction)streamButton
{
    [self tableViewDelegatesWillChange];
    [self loadWithType:GuideType_Stream forTableViewManager:self.streamtableViewManager withPullToRefreshEnabled:YES];
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

    [UIView animateWithDuration:1.0f animations:^{
        [self.navigationController.navigationBar setAlpha:0.25f];
        [self.tabBarController.tabBar setAlpha:0.25f];
        [self.tableView setAlpha:0.25f];
    }];
}

#pragma mark - Interface Orientation Method
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end