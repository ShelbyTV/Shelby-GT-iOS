//
//  Frame.h
//  Shelby-tv
//
//  Created by Arthur Ariel Sabintsev on 5/10/12.
//  Copyright (c) 2012 Shelby.tv. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Conversation, DashboardEntry, Video;

@interface Frame : NSManagedObject

@property (nonatomic, retain) NSString * id;
@property (nonatomic, retain) NSString * videoID;
@property (nonatomic, retain) NSString * conversationID;
@property (nonatomic, retain) Video *video;
@property (nonatomic, retain) Conversation *conversation;
@property (nonatomic, retain) DashboardEntry *dashboardEntry;

@end
