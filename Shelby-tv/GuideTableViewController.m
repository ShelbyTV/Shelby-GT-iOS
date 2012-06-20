//
//  GuideTableViewController.m
//  Shelby-tv
//
//  Created by Arthur Ariel Sabintsev on 4/19/12.
//  Copyright (c) 2012 Shelby.tv. All rights reserved.
//

#import "GuideTableViewController.h"
#import "ShelbyMenuController.h"
#import "TableViewManagers.h"
#import "ShelbyMenuView.h"

@interface GuideTableViewController ()

@property (assign, nonatomic) GuideType type;
@property (strong, nonatomic) ShelbyMenuView *menuView;
@property (strong, nonatomic) GuideTableViewManager *tableViewManager;
@property (assign, nonatomic) BOOL firstLoad;

/// Creation Methods
- (GuideTableViewManager*)createTableViewManager;
- (void)createView;

/// Animation Methods
- (void)fadeInAnimation;
- (void)fadeOutAnimation;

@end

@implementation GuideTableViewController
@synthesize shelbyController = _shelbyController;
@synthesize type = _guideType;
@synthesize menuView = _menuView;
@synthesize tableViewManager = _tableViewManager;

#pragma mark - Initialization Method
- (id)initWithType:(GuideType)type
{
    
    if ( self = [super init] ) {
        
        // Set Type of GuideTableViewController Instance
        self.type = type;
        
        self.tableViewManager = [self createTableViewManager];
        
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
            
        default:
            break;
    }
    
    return manager;
    
}

- (void)createView
{
    
    // Add menuView over navigationBar
    NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"ShelbyMenuView" owner:self options:nil];
    self.menuView = (ShelbyMenuView*)[nib objectAtIndex:0];
    [self.navigationController.navigationBar addSubview:self.menuView];
    
    // Set section-specific UI properties
    switch ( self.type ) {
            
        case GuideType_BrowseRolls:{
       
            [self.menuView.browseRollsButton setHighlighted:YES];
            
        } break;
            
        case GuideType_MyRolls:{
            
            [self.menuView.myRollsButton setHighlighted:YES];
            
        } break;
            
        case GuideType_PeopleRolls:{
            
            [self.menuView.peopleRollsButton setHighlighted:YES];
            
        } break;
            
        case GuideType_Settings:{
            
            [self.menuView.settingsButton setHighlighted:YES];
            
        } break;
            
        case GuideType_Stream:{
            
            [self.menuView.streamButton setHighlighted:YES];
            
        } break;
            
        default:
            break;
    }
    
    [self fadeInAnimation];
    
    // Call API and Core Data in section's tableViewManager
    if ( [SocialFacade sharedInstance].shelbyAuthorized ) [self.tableViewManager loadDataOnInitializationForTableView:self.tableView];

}

#pragma mark - Animation Methods
- (void)fadeInAnimation
{
    
    [self.tableView setAlpha:0.25f];
    [UIView animateWithDuration:1.0f animations:^{
        [self.tableView setAlpha:1.0f];
        
    }];
    
}

- (void)fadeOutAnimation
{
    [UIView animateWithDuration:1.0f animations:^{
        [self.tableView setAlpha:0.25f];
        
    }];
}

#pragma mark - ShelbyControllerDelegate Methods
- (IBAction)browseRollsButton:(id)sender
{
    [self.shelbyController browseRollsButton:nil];
}

- (IBAction)myRollsButton:(id)sender
{
    [self.shelbyController myRollsButton:nil];
}

- (IBAction)peopleRollsButton:(id)sender
{
    [self.shelbyController peopleRollsButton:nil];
}

- (IBAction)settingsButton:(id)sender
{
    [self.shelbyController settingsButton:nil];
}

- (IBAction)streamButton:(id)sender
{
    [self.shelbyController streamButton:nil];
}


#pragma mark - Interface Orientation Method
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end