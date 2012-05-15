//
//  DashboardEntry.h
//  Shelby-tv
//
//  Created by Arthur Ariel Sabintsev on 5/15/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Conversation, Frame, Video;

@interface DashboardEntry : NSManagedObject

@property (nonatomic, retain) NSString * idString;
@property (nonatomic, retain) Conversation *conversation;
@property (nonatomic, retain) Frame *frame;
@property (nonatomic, retain) Video *video;

@end
