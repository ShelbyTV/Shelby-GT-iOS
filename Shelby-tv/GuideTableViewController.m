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

- (void)customizeOnViewAppear;

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
        
        // Perform initial API Request
        [self.guideTableViewManager performAPIRequestForTableView:self.tableView];
        
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
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self customizeOnViewAppear];
}


- (void)customizeOnViewAppear
{
    
    // Customize NavigationBar Title (must happen in viewWillAppear)
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(100.0f, 0.0f, 180.0f, 44.0f)];    
    label.backgroundColor = [UIColor clearColor];
    label.textColor = [UIColor whiteColor];
    label.font = [UIFont fontWithName:@"Ubuntu-Bold" size:19];
    label.textAlignment = UITextAlignmentCenter;
    label.text = self.title;
    [self.navigationItem setTitleView:label];
    
    // Customize GuideTableViewController for specific guideTableViewManager
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