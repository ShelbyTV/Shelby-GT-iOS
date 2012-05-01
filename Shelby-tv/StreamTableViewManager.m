//
//  StreamTableViewManager.m
//  Shelby-tv
//
//  Created by Arthur Ariel Sabintsev on 4/19/12.
//  Copyright (c) 2012 Shelby.tv. All rights reserved.
//

#import "StreamTableViewManager.h"

// For Testing Purposes
#import "NewRollViewController.h"
#import "ShareViewController.h"
#import "CommentViewController.h"

@implementation StreamTableViewManager

#pragma mark - ASPullToRefreshDelegate Methods
- (void)dataToRefresh
{
    [self.refreshController didFinishRefreshing];
}

#pragma mark - UITableViewDatasource Methods
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    // For Testing Purposes
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    
    switch ( indexPath.row ) {
        case 0:
            cell.textLabel.text = @"New Roll";
            break;
        case 1:
            cell.textLabel.text = @"Share";
            break;
        case 2:
            cell.textLabel.text = @"Comment";
            break;
        default:
            break;
    }
    
    return cell;
}

#pragma mark - UITableViewDelegate Methods
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // For Testing Purposes
    switch ( indexPath.row ) {
            
        case 0:{
        
            NewRollViewController *viewController = [[NewRollViewController alloc] initWithNibName:@"NewRollViewController" bundle:nil];
            [self.navigationController pushViewController:viewController animated:YES];
            
        } break;
            
        case 1:{
            
            ShareViewController *viewController = [[ShareViewController alloc] initWithNibName:@"ShareViewController" bundle:nil];
            [self.navigationController pushViewController:viewController animated:YES];
            
        } break;
            
        case 2:{
            
            CommentViewController *viewController = [[CommentViewController alloc] initWithNibName:@"CommentViewController" bundle:nil];
            [self.navigationController pushViewController:viewController animated:YES];
            
        } break;
            
        default:
            break;
    }
}

@end