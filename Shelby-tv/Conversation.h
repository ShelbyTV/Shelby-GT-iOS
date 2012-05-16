//
//  Conversation.h
//  Shelby-tv
//
//  Created by Arthur Ariel Sabintsev on 5/16/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class DashboardEntry, Frame;

@interface Conversation : NSManagedObject

@property (nonatomic, retain) NSString * conversationID;
@property (nonatomic, retain) DashboardEntry *dashboardEntry;
@property (nonatomic, retain) Frame *frame;

@end
