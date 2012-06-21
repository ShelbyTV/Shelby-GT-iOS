//
//  SettingsTableViewController.m
//  Shelby-tv
//
//  Created by Arthur Ariel Sabintsev on 6/19/12.
//  Copyright (c) 2012 Shelby.tv. All rights reserved.
//

#import "SettingsTableViewController.h"
#import "TableViewManagers.h"
#import "ShelbyMenuController.h"
#import "ShelbyMenuView.h"
#import "AppDelegate.h"

@interface SettingsTableViewController ()

@property (strong, nonatomic) ShelbyMenuView *menuView;

- (void)logout;

// Animation Methods
- (void)fadeInAnimation;
- (void)fadeOutAnimation;

@end

@implementation SettingsTableViewController
@synthesize shelbyMenuController = _shelbyMenuController;
@synthesize menuView = _menuView;

#pragma mark - Deallocation Method
- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:SocialFacadeAuthorizationStatus object:nil];
}

#pragma mark - Initialization Method
- (id)initWithStyle:(UITableViewStyle)style
{
    if ( self = [super initWithStyle:style] ) {
        
        self.tableView.backgroundColor = [UIColor whiteColor];
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        self.tableView.separatorColor = [UIColor blackColor];

    }
    
    return self;
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
    [self fadeInAnimation];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self fadeOutAnimation];
}

#pragma mark - Private Methods
- (void)createView
{
    
    // Add menuView over navigationBar
    self.menuView = self.shelbyMenuController.menuView;
    [self.navigationController.navigationBar addSubview:self.menuView];
    
}

#pragma mark - Private Methods
- (void)logout
{
    AppDelegate *appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    [appDelegate presentLoginViewController];
}

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

#pragma mark - UITableViewDataSource Methods
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    // For Testing Purposes
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if ( (nil == cell) || (0 == indexPath.row) ) { // The 0 == indexPath.row is to fix an issue when reloading stream via the ShelbyMenuView
        
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        
    }
    
    
    // Populate UITableView row with content if content exists (CHANGE THIS CONDITION TO BE CORE-DATA DEPENDENT)
    if ( 0 == indexPath.row ) {
        
        cell.textLabel.text = @"Logout";
        
    }
    
    return cell;
}

#pragma marl - UITableViewDelegate Methods
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(logout) name:SocialFacadeAuthorizationStatus object:nil];
    [CoreDataUtility dumpAllData];
    [[SocialFacade sharedInstance] shelbyLogout];
}

#pragma mark - ShelbyMenuControllerDelegate Methods
- (void)browseRollsButton
{
    [self.shelbyMenuController browseRollsButton];
}

- (void)myRollsButton
{
    [self.shelbyMenuController myRollsButton];
}

- (void)peopleRollsButton
{
    [self.shelbyMenuController peopleRollsButton];
}

- (void)settingsButton
{
    [self.shelbyMenuController settingsButton];
}

- (void)streamButton
{
    [self.shelbyMenuController streamButton];
}

#pragma mark - Interface Orientation Method
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
