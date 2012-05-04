//
//  YouTableViewController.m
//  Shelby-tv
//
//  Created by Arthur Ariel Sabintsev on 4/30/12.
//  Copyright (c) 2012 Shelby.tv. All rights reserved.
//

#import "YouTableViewController.h"
#import "UINavigationItem+CustomTitleView.h"

// Test
#import <QuartzCore/QuartzCore.h>

@interface YouTableViewController ()

@end

@implementation YouTableViewController
@synthesize navigationController = _navigationController;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        
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
    
    // Customize NavigationBar Title (must happen in viewWillAppear)
    [self.navigationItem setTitleView:[UINavigationItem titleViewWithTitle:self.title]];
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

#pragma mark - UITableViewDelegate Methods
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];

    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        CAGradientLayer *gradient = [CAGradientLayer layer];
        gradient.frame = cell.bounds;
        gradient.colors = [NSArray arrayWithObjects:(id)[[UIColor colorWithRed:51.0f/255.5f green:51.0f/255.5f blue:51.0f/255.5f alpha:1.0f] CGColor], (id)[[UIColor colorWithRed:48.0f/255.5f green:48.0f/255.5f blue:48.0f/255.5f alpha:1.0f] CGColor], nil];
        [cell.layer addSublayer:gradient];
    }        
    
    return cell;
}

#pragma mark - Interface Orientation Methods
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end