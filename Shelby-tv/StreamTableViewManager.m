//
//  StreamTableViewManager.m
//  Shelby-tv
//
//  Created by Arthur Ariel Sabintsev on 4/19/12.
//  Copyright (c) 2012 Shelby.tv. All rights reserved.
//

#import "StreamTableViewManager.h"
#import "VideoCardCell.h"
#import "Asyncable.h"

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
    NSString *notificationName = [NSString apiRequestTypeToString:APIRequestTypeStream];
    [[NSNotificationCenter defaultCenter] addObserver:self 
                                             selector:@selector(dataReturnedFromAPI:) 
                                                 name:notificationName 
                                               object:nil];
    self.observerCreated = YES;
}

#pragma mark - GuideTableViewManagerDelegate Method
- (void)performAPIRequestForTableView:(UITableView *)tableView
{

    // Add API Observers (should ONLY occur on first call to this method)
    if ( NO == self.observerCreated ) [self createAPIObservers];
    
    // Reference Parent ViewController's UITableView (should ONLY occur on first call to this method)
    if ( ![self tableView] ) self.tableView = tableView;
    
    // Peeform API Request
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:[NSURL URLWithString:kAPIRequestStream]];

    ShelbyAPIClient *client = [[ShelbyAPIClient alloc] init];
    [client performRequest:request ofType:APIRequestTypeStream];
    
}

- (void)dataReturnedFromAPI:(NSNotification*)notification
{

    // Hide ASPullToRefreshController's HeaderView
    [self.refreshController didFinishRefreshing];
    
    // Store array from NSNotification, locally
    if ( [notification.object isKindOfClass:[NSDictionary class]] ) {
        
        self.parsedDictionary = notification.object;
        self.parsedResultsArray = [self.parsedDictionary objectForKey:kAPIRequestResult];
//        NSLog(@"%@",[self.parsedResultsArray objectAtIndex:0]);
        
    } else {
    
        NSLog(@"ERROR");
    }
    
    // Reload tableView
    [self.tableView reloadData];

}

#pragma mark - ASPullToRefreshDelegate Method
- (void)dataToRefresh
{
    // Perform API Request for tableView, which WILL/SHOULD/MUST exist before this method is called
    if ( [self tableView] ) [self performAPIRequestForTableView:self.tableView];
}

#pragma mark - UITableViewDatasource Methods
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 304;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return ( self.parsedResultsArray ) ? [self.parsedResultsArray count] : 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    // For Testing Purposes
    static NSString *CellIdentifier = @"Cell";
    VideoCardCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if ( nil == cell ) {
        
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"VideoCardCell" owner:self options:nil];
        cell = (VideoCardCell*)[nib objectAtIndex:0];
          
    }

    if ( [self.parsedResultsArray objectAtIndex:indexPath.row] ) {
        
        NSString *imageString = [[[[self.parsedResultsArray objectAtIndex:indexPath.row] valueForKey:@"frame"] valueForKey:@"video"] valueForKey:@"thumbnail_url"];
        [cell.thumbnailImageView loadImageAsynchronouslyFromURL:imageString withLoadingImage:nil];

        
    }
    
    return cell;
}

#pragma mark - UITableViewDelegate Methods
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

}

@end