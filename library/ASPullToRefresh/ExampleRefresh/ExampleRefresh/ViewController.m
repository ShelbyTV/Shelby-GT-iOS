//
//  ViewController.m
//  ExampleRefresh
//
//  Created by Arthur Ariel Sabintsev on 2/14/12.
//  Copyright (c) 2012 ArtSabintsev. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@property (strong, nonatomic) NSMutableArray *array;

@end

@implementation ViewController
@synthesize array = _array;

#pragma mark - Memory Deallocaiton Methods


- (void)viewDidLoad 
{
    [super viewDidLoad];
    
    self.title = @"Demo";
    self.array = [[NSMutableArray alloc] initWithObjects:@"What time is it?", nil];
    [self.tableView reloadData];
}

#pragma mark - UITableViewDatasource Methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView 
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section 
{
    return [self.array count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath 
{
    
    static NSString *CellIdentifier = @"CellIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    cell.textLabel.text = [self.array objectAtIndex:indexPath.row];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

- (void)dataToRefresh
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setTimeStyle:NSDateFormatterMediumStyle];
    NSString *now = [dateFormatter stringFromDate:[NSDate date]];
    [self.array insertObject:[NSString stringWithFormat:@"%@", now] atIndex:0];
    [self.tableView reloadData];
 
    [[NSNotificationCenter defaultCenter] postNotificationName:kDidFinishRefreshing object:nil];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
}

@end