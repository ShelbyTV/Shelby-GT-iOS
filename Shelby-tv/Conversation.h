//
//  Conversation.h
//  Shelby-tv
//
//  Created by Arthur Ariel Sabintsev on 5/15/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class DashboardEntry, Frame;

@interface Conversation : NSManagedObject

@property (nonatomic, retain) NSString * idString;
@property (nonatomic, retain) DashboardEntry *dashboardEntry;
@property (nonatomic, retain) Frame *frame;

@end
