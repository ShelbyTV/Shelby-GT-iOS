//
//  GuideTableViewController.m
//  Shelby-tv
//
//  Created by Arthur Ariel Sabintsev on 4/19/12.
//  Copyright (c) 2012 Shelby.tv. All rights reserved.
//

#import "GuideTableViewController.h"
#import "GuideTableViewManager.h"

@interface GuideTableViewController ()

@property (assign, nonatomic) GuideType guideType;
@property (strong, nonatomic) GuideTableViewManager *guideTableViewManager;

- (void)customizeOnViewLoad;

@end

@implementation GuideTableViewController
@synthesize guideType = _guideType;
@synthesize guideTableViewManager = _guideTableViewManager;

#pragma mark - Initialization Method
- (id)initWithGuideType:(GuideType)type andTableViewManager:(GuideTableViewManager *)manager
{
    
    if ( self = [super init] ) {
        
        // Set Type of GuideTableViewController Instance
        self.guideType = type;
        
        // Set TableViewManager (e.g., TableViewDataSource and TableViewDelegate) of StoryViewController instance
        self.guideTableViewManager = manager;
        self.tableView.delegate = (id)self.guideTableViewManager;
        self.tableView.dataSource = (id)self.guideTableViewManager;
        
        // Set Reference to ASPullToRefreshTableViewController
        self.guideTableViewManager.refreshController = self;
        self.refreshDelegate = (id)self.guideTableViewManager;
        
        [self.tableView setBackgroundColor:[UIColor darkGrayColor]];
        
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
    [self customizeOnViewLoad];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)customizeOnViewLoad
{
    switch (self.guideType) {
            
        case GuideTypeStream: {
            
            
        } break;
            
        case GuideTypeSaves: {
            
            
        } break;
            
        case GuideTypeSearch: {
            

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