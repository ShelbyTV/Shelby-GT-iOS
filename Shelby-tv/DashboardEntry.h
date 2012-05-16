//
//  DashboardEntry.h
//  Shelby-tv
//
//  Created by Arthur Ariel Sabintsev on 5/16/12.
//  Copyright (c) 2012 Shelby.tv. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Frame;

@interface DashboardEntry : NSManagedObject

@property (nonatomic, retain) NSString * dashboardID;
@property (nonatomic, retain) Frame *frame;

@end
