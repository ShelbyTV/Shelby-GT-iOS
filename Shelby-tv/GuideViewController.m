//
//  StoryViewController.m
//  Shelby-tv
//
//  Created by Arthur Ariel Sabintsev on 4/19/12.
//  Copyright (c) 2012 Shelby.tv. All rights reserved.
//

#import "GuideViewController.h"
#import "GuideTableViewManager.h"

@interface GuideViewController ()

@property (assign, nonatomic) GuideType guideType;
@property (strong, nonatomic) GuideTableViewManager *storyTableViewManager;
@property (strong, nonatomic) UITabBarController *appDelegateTabBarController;
@property (strong, nonatomic) UINavigationController *appDelegateNavigationController;

- (void)createObservers;
- (void)grabReferenceToArchitecuralElements:(NSNotification*)notification;
- (void)customizeForStoryTableViewManager;

@end

@implementation GuideViewController
@synthesize guideType = _guideType;
@synthesize storyTableViewManager = _storyTableViewManager;
@synthesize appDelegateTabBarController = _appDelegateTabBarController;
@synthesize appDelegateNavigationController = _appDelegateNavigationController;

#pragma mark - Memory Deallocation Method
- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - Initialization Method
- (id)initWithGuideType:(GuideType)type andTableViewManager:(GuideTableViewManager *)manager
{
    
    if ( self = [super init] ) {
        
        // Set Type of StoryViewController Instance
        self.guideType = type;
        
        // Set TableViewManager (e.g., TableViewDataSource and TableViewDelegate) of StoryViewController instance
        self.storyTableViewManager = manager;
        self.tableView.delegate = (id)self.storyTableViewManager;
        self.tableView.dataSource = (id)self.storyTableViewManager;
        
        // Set Reference to ASPullToRefreshTableViewController
        self.storyTableViewManager.refreshController = self;
        self.refreshDelegate = (id)self.storyTableViewManager;

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
    
    // Customize for instance of StoryTableViewManager
    [self customizeForStoryTableViewManager];
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
}

- (void)customizeForStoryTableViewManager
{
    
}

#pragma mark - Interface Orientation Method
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end