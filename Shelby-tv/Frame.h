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

@property (nonatomic, strong) NSString * id;
@property (nonatomic, strong) NSString * videoID;
@property (nonatomic, strong) NSString * conversationID;
@property (nonatomic, strong) Video *video;
@property (nonatomic, strong) Conversation *conversation;
@property (nonatomic, strong) DashboardEntry *dashboardEntry;

@end