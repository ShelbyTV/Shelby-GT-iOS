//
//  GuideTableViewManager.h
//  Shelby-tv
//
//  Created by Arthur Ariel Sabintsev on 4/19/12.
//  Copyright (c) 2012 . All rights reserved.
//

#import "ASPullToRefreshTableViewController.h"
#import "StaticDeclarations.h"
#import "ShelbyAPIClient.h"
#import "NSString+TypedefConversion.h"

@protocol GuideTableViewManagerDelegate <NSObject>

- (void)performAPIRequestForTableView:(UITableView*)tableView;;
- (void)dataReturnedFromAPI:(NSNotification*)notification;

@end

@interface GuideTableViewManager : NSObject <GuideTableViewManagerDelegate, UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) ASPullToRefreshTableViewController *refreshController;
@property (strong, nonatomic) UINavigationController *navigationController;
@property (strong, nonatomic) NSDictionary *parsedDictionary;
@property (strong, nonatomic) NSArray *parsedResultsArray;
@property (strong, nonatomic) UITableView *tableView;

@end