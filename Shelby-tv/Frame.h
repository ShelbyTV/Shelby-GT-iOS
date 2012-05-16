//
//  Frame.h
//  Shelby-tv
//
//  Created by Arthur Ariel Sabintsev on 5/16/12.
//  Copyright (c) 2012 Shelby.tv. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Conversation, DashboardEntry, User, Video;

@interface Frame : NSManagedObject

@property (nonatomic, retain) NSString * conversationID;
@property (nonatomic, retain) NSString * frameID;
@property (nonatomic, retain) NSString * videoID;
@property (nonatomic, retain) NSString * userID;
@property (nonatomic, retain) NSString * timestamp;
@property (nonatomic, retain) Conversation *conversation;
@property (nonatomic, retain) DashboardEntry *dashboardEntry;
@property (nonatomic, retain) Video *video;
@property (nonatomic, retain) User *user;

@end
