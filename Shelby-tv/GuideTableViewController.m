//
//  GuideTableViewController.m
//  Shelby-tv
//
//  Created by Arthur Ariel Sabintsev on 4/19/12.
//  Copyright (c) 2012 Shelby.tv. All rights reserved.
//

#import "GuideTableViewController.h"
#import "SocialFacade.h"

@interface GuideTableViewController ()

@property (assign, nonatomic) GuideType guideType;
@property (strong, nonatomic) GuideTableViewManager *guideTableViewManager;

- (void)customizeOnViewAppear;

@end

@implementation GuideTableViewController
@synthesize guideType = _guideType;
@synthesize guideTableViewManager = _guideTableViewManager;

#pragma mark - Initialization Method
- (id)initWithType:(GuideType)type forTableViewManager:(GuideTableViewManager *)manager withPullToRefreshEnabled:(BOOL)refreshEnabled
{
    
    if ( self = [super initWithStyle:UITableViewStylePlain] ) {
        
        // Customize tableView
        self.view.backgroundColor = kColorConstantBackgroundColor;
        self.tableView.backgroundColor = kColorConstantBackgroundColor;
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

    [self customizeOnViewAppear];
}


- (void)customizeOnViewAppear
{
    
    // Customize GuideTableViewController for specific guideTableViewManager
    switch (self.guideType) {
            
        case GuideTypeStream: {
        
            // If user is authorized with Shelby, populate tableViewManager data from API and Core Data
            if ( [SocialFacade sharedInstance].shelbyAuthorized ){
              
                if ( [SocialFacade sharedInstance].firstTimeLogin ) {
               
                    // Make sure the logout animation never appears again
                    [[SocialFacade sharedInstance] setFirstTimeLogin:NO];
                    
                    // Animate View
                    [self.navigationController.navigationBar setAlpha:0.25f];
                    [self.tabBarController.tabBar setAlpha:0.25f];
                    [self.tableView setAlpha:0.25f];
                    [UIView animateWithDuration:1.0f animations:^{
                        [self.navigationController.navigationBar setAlpha:1.0f];
                        [self.tabBarController.tabBar setAlpha:1.0f];
                        [self.tableView setAlpha:1.0f];
                    }];
                
                }
                
                [self.guideTableViewManager loadDataOnInitializationForTableView:self.tableView];
                
            }
            
        } break;
            
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