//
//  CoreDataConstants.h
//  Shelby-tv
//
//  Created by Arthur Ariel Sabintsev on 5/14/12.
//  Copyright (c) 2012 Shelby.tv. All rights reserved.
//

#import "Conversation.h"
#import "DashboardEntry.h"
#import "Frame.h"
#import "Messages.h"
#import "Roll.h"
#import "User.h"
#import "Video.h"

// Entity Constants
#define kCoreDataEntityConversation             @"Conversation"
#define kCoreDataEntityDashboardEntry           @"DashboardEntry"
#define kCoreDataEntityFrame                    @"Frame"
#define kCoreDataEntityMessages                 @"Messages"
#define kCoreDataEntityRoll                     @"Roll"
#define kCoreDataEntityUser                     @"User"
#define kCoreDataEntityVideo                    @"Video"

// Relationship Constants
#define kCoreDataRelationshipConversation       @"conversation"
#define kCoreDataRelationshipDashboardEntry     @"dashboardEntry"
#define kCoreDataRelationshipFrame              @"frame"
#define kCoreDataRelationshipMessages           @"messages"
#define kCoreDataRelationshipRoll               @"roll"
#define kCoreDataRelationshipUser               @"user"
#define kCoreDataRelationshipVideo              @"video"

// Conversation Attribute Constants
#define kCoreDataConversationID                 @"conversationID"
#define kCoreDataConversationMessageCount       @"messageCount"

// DashboardEntry Attribute Constants
#define kCoreDataDashboardEntryID               @"dashboardID"
#define kCoreDataDashboardEntryTimestamp        @"timestamp"

// Frame Attribute Constants
#define kCoreDataFrameConversationID            @"conversationID"
#define kCoreDataFrameID                        @"frameID"
#define kCoreDataFrameRollID                    @"rollID"
#define kCoreDataFrameTimestamp                 @"timestamp"
#define kCoreDataFrameUpvotersCount             @"upvotersCount"
#define kCoreDataFrameUserID                    @"userID"
#define kCoreDataFrameVideoID                   @"videoID"

// Messages Attribute Constants
#define kCoreDataMessagesConversationID         @"conversationID"
#define kCoreDataMessagesCreatedAt              @"createdAt"
#define kCoreDataMessagesID                     @"messagesID"
#define kCoreDataMessagesNickname               @"nickname"
#define kCoreDataMessagesOriginNetwork          @"originNetwork"
#define kCoreDataMessagesText                   @"text"
#define kCoreDataMessagesTimestamp              @"timestamp"
#define kCoreDataMessagesUserImageURL           @"userImageURL"

// Roll Attribute Constants
#define kCoreDataRollID                         @"rollID"
#define kCoreDataRollTitle                      @"title"

// User Attribute Constants
#define kCoreDataUserID                         @"userID"
#define kCoreDataUserImage                      @"userImage"
#define kCoreDataUserNickname                   @"nickname"

// Video Attribute Constants
#define kCoreDataVideoID                        @"videoID"
#define kCoreDataVideoCaption                   @"caption"
#define kCoreDataVideoProviderName              @"providerName"
#define kCoreDataVideoSourceURL                 @"sourceURL"
#define kCoreDataVideoTitle                     @"title"
#define kCoreDataVideoThumbnailURL              @"thumbnailURL"