//
//  RollsViewController.m
//  Shelby-tv
//
//  Created by Arthur Ariel Sabintsev on 4/30/12.
//  Copyright (c) 2012 Shelby.tv. All rights reserved.
//

#import "RollsViewController.h"

@interface RollsViewController ()

@property (strong, nonatomic) GuideTableViewManager *guideTableViewManager;
@property (strong, nonatomic) UITabBarController *appDelegateTabBarController;
@property (strong, nonatomic) UINavigationController *appDelegateNavigationController;

- (void)createObservers;
- (void)grabReferenceToArchitecuralElements:(NSNotification*)notification;
- (void)customizeOnViewLoad;

@end

@implementation RollsViewController
@synthesize tableView = _tableView;
@synthesize rollsType = _rollsType;
@synthesize guideTableViewManager = _guideTableViewManager;
@synthesize appDelegateTabBarController = _appDelegateTabBarController;
@synthesize appDelegateNavigationController = _appDelegateNavigationController;

#pragma mark - Memory Deallocation Method
- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - Initialization Method
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{

    if ( self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil] ) {
        
        // Create Observers (for reference to AppDelegate's UITabBarController and UINavigationController)
        [self createObservers];
        
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
    
    // Customize for instance of GuideTableViewManager
    [self customizeOnViewLoad];
}

#pragma mark - Private Methods
- (void)createObservers
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(grabReferenceToArchitecuralElements:) name:kArchitecturalElementsReferenceDictionary object:nil];
}

- (void)grabReferenceToArchitecuralElements:(NSNotification *)notification
{
    self.appDelegateTabBarController = notification.object;
    self.appDelegateNavigationController = self.appDelegateTabBarController.navigationController;
    NSLog(@"%@", self.appDelegateNavigationController);
}

- (void)customizeOnViewLoad
{
    
    switch (self.rollsType) {
            
        case RollsTypeYour: {
            
            // Set TableViewManager (e.g., TableViewDataSource and TableViewDelegate) of StoryViewController instance
            self.guideTableViewManager = [[YourRollsTableViewManager alloc] init];
            self.tableView.delegate = (id)self.guideTableViewManager;
            self.tableView.dataSource = (id)self.guideTableViewManager;
            
            // Set Reference to ASPullToRefreshTableViewController
            self.guideTableViewManager.refreshController = self;
            self.refreshDelegate = (id)self.guideTableViewManager;
            
            self.appDelegateNavigationController.navigationItem.title = @"Your Rolls";
            
        } break;
            
        case RollsTypePeople:
            break;
            
        case RollsTypePopular:
            break;
            
        default:
            break;
    }
    
}

#pragma mark - Interface Orientation Method
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end