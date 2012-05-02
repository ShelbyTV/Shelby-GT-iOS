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

@interface StreamTableViewManager ()

@property (assign, nonatomic) BOOL observerCreated;

- (void)createAPIObservers;

@end

@implementation StreamTableViewManager 
@synthesize observerCreated = _observerCreated;

#pragma mark - Memory Deallocation Method
- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - Private Methods
- (void)createAPIObservers
{
    NSString *notificationName = [NSString apiRequestTypeToString:APIRequestTypeStreams];
    [[NSNotificationCenter defaultCenter] addObserver:self 
                                             selector:@selector(dataReturnedFromAPI:) 
                                                 name:notificationName 
                                               object:nil];
    self.observerCreated = YES;
}

#pragma mark - GuideTableViewManagerDelegate Method
- (void)performAPIRequest
{

    // Add API Observers if they don't exist
    if ( NO == self.observerCreated ) {
        [self createAPIObservers];
    }
    
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:[NSURL URLWithString:kAPIRequestStream]];
    [[ShelbyAPIClient sharedInstance] performRequest:request ofType:APIRequestTypeStreams];

}

- (void)dataReturnedFromAPI:(NSNotification*)notification
{

    // Hide PullToRefreshHeader
    [self.refreshController didFinishRefreshing];
    
    // Store array from NSNotification, locally
    if ( [notification.object isKindOfClass:[NSDictionary class]] ) {
        
        self.parsedDictionary = notification.object;
    
    } else {
    
        NSLog(@"ERROR");
    }

}

#pragma mark - ASPullToRefreshDelegate Method
- (void)dataToRefresh
{
    // Perform API Request
    [self performAPIRequest];
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
    
//    switch ( indexPath.row ) {
//        case 0:
//            cell.textLabel.text = @"New Roll";
//            break;
//        case 1:
//            cell.textLabel.text = @"Share";
//            break;
//        case 2:
//            cell.textLabel.text = @"Comment";
//            break;
//        default:
//            break;
//    }
    
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