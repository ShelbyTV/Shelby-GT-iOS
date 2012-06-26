//
//  GuideTableViewManager.h
//  Shelby-tv
//
//  Created by Arthur Ariel Sabintsev on 4/19/12.
//  Copyright (c) 2012 . All rights reserved.
//

#import "ASPullToRefreshTableViewController.h"

// Controllers
#import "ShelbyAPIClient.h"
#import "CoreDataUtility.h"
#import "SocialFacade.h"
#import "AsynchronousFreeloader.h"

// Categories
#import "NSString+TypedefConversion.h"

// Constants
#import "StaticDeclarations.h"

@protocol GuideTableViewManagerDelegate <NSObject>

- (void)loadDataOnInitializationForTableView:(UITableView*)tableView;
- (void)loadDataFromCoreData;
- (void)performAPIRequest;
- (void)dataReturnedFromAPI:(NSNotification*)notification;

@end

@interface GuideTableViewManager : NSObject <GuideTableViewManagerDelegate, UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) ASPullToRefreshTableViewController *refreshController;
@property (strong, nonatomic) UINavigationController *navigationController;
@property (strong, nonatomic) NSArray *parsedResultsArray;
@property (strong, nonatomic) NSArray *coreDataResultsArray;
@property (strong, nonatomic) UITableView *tableView;


@end