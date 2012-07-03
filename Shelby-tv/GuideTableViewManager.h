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

@class GuideTableViewController;

@protocol GuideTableViewManagerDelegate <NSObject>

- (void)loadDataFromCoreData;
- (void)performAPIRequest;
- (void)dataReturnedFromAPI:(NSNotification*)notification;

@optional
- (void)loadDataOnInitializationForTableView:(UITableView*)tableView;
- (void)loadDataOnInitializationForTableView:(UITableView*)tableView andRollID:(NSString*)rollID;

@end

@interface GuideTableViewManager : NSObject <GuideTableViewManagerDelegate, UITableViewDataSource, UITableViewDelegate>

// All TableViewManagers
@property (strong, nonatomic) ASPullToRefreshTableViewController *refreshController;
@property (strong, nonatomic) GuideTableViewController *guideController;
@property (strong, nonatomic) NSArray *parsedResultsArray;
@property (strong, nonatomic) NSArray *coreDataResultsArray;
@property (strong, nonatomic) UITableView *tableView;
@property (assign, nonatomic) NSUInteger iterationCount;
@property (assign, nonatomic) NSUInteger visibleCellCount;

// RollFramesTableViewManager
@property (strong, nonatomic) NSString *rollID;

@end