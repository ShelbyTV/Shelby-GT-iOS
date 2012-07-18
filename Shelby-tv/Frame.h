//
//  Frame.h
//  Shelby.tv
//
//  Created by Arthur Ariel Sabintsev on 6/6/12.
//  Copyright (c) 2012 Shelby.tv. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Conversation, Creator, DashboardEntry, Roll, UpvoteUsers, Video;

@interface Frame : NSManagedObject

@property (nonatomic, retain) NSString * conversationID;
@property (nonatomic, retain) NSString * frameID;
@property (nonatomic, retain) NSString * rollID;
@property (nonatomic, retain) NSDate * timestamp;
@property (nonatomic, retain) NSNumber * upvotersCount;
@property (nonatomic, retain) NSString * creatorID;
@property (nonatomic, retain) NSString * videoID;
@property (nonatomic, retain) Conversation *conversation;
@property (nonatomic, retain) DashboardEntry *dashboardEntry;
@property (nonatomic, retain) Roll *roll;
@property (nonatomic, retain) NSSet *upvoteUsers;
@property (nonatomic, retain) Creator *creator;
@property (nonatomic, retain) Video *video;
@end

@interface Frame (CoreDataGeneratedAccessors)

- (void)addUpvoteUsersObject:(UpvoteUsers *)value;
- (void)removeUpvoteUsersObject:(UpvoteUsers *)value;
- (void)addUpvoteUsers:(NSSet *)values;
- (void)removeUpvoteUsers:(NSSet *)values;

@end
