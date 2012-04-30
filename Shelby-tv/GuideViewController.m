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
@property (strong, nonatomic) GuideTableViewManager *guideTableViewManager;
@property (strong, nonatomic) UITabBarController *appDelegateTabBarController;
@property (strong, nonatomic) UINavigationController *appDelegateNavigationController;

- (void)customizeForguideTableViewManager;

@end

@implementation GuideViewController
@synthesize guideType = _guideType;
@synthesize guideTableViewManager = _guideTableViewManager;
@synthesize appDelegateTabBarController = _appDelegateTabBarController;
@synthesize appDelegateNavigationController = _appDelegateNavigationController;

#pragma mark - Initialization Method
- (id)initWithGuideType:(GuideType)type andTableViewManager:(GuideTableViewManager *)manager
{
    
    if ( self = [super init] ) {
        
        // Set Type of StoryViewController Instance
        self.guideType = type;
        
        // Set TableViewManager (e.g., TableViewDataSource and TableViewDelegate) of StoryViewController instance
        self.guideTableViewManager = manager;
        self.tableView.delegate = (id)self.guideTableViewManager;
        self.tableView.dataSource = (id)self.guideTableViewManager;
        
        // Set Reference to ASPullToRefreshTableViewController
        self.guideTableViewManager.refreshController = self;
        self.refreshDelegate = (id)self.guideTableViewManager;
        
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
    
    // Customize for instance of guideTableViewManager
    [self customizeForguideTableViewManager];
}

#pragma mark - Private Methods
- (void)createObservers
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(grabReferenceToArchitecuralElements:) name:kArchitecturalElementsReferenceDictionary object:nil];
}

- (void)customizeForguideTableViewManager
{
    
}

#pragma mark - Interface Orientation Method
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end