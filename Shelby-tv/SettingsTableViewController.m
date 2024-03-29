//
//  SettingsTableViewController.m
//  Shelby.tv
//
//  Created by Arthur Ariel Sabintsev on 6/19/12.
//  Copyright (c) 2012 Shelby.tv. All rights reserved.
//

#import "SettingsTableViewController.h"
#import "TableViewManagers.h"
#import "ShelbyMenuViewController.h"
#import "AppDelegate.h"

@interface SettingsTableViewController ()

@property (strong, nonatomic) AppDelegate *appDelegate;

- (void)logout;

@end

@implementation SettingsTableViewController
@synthesize navigationController = _navigationController;

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
    self.appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];;
}

#pragma mark - Private Methods
- (void)logout
{
    AppDelegate *appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    [appDelegate presentLoginViewController];
    
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
    
    if ( nil == cell ) {
        
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        
    }
    
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
