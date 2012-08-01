//
//  CoreDataConstants.h
//  Shelby.tv
//
//  Created by Arthur Ariel Sabintsev on 5/14/12.
//  Copyright (c) 2012 Shelby.tv. All rights reserved.
//

#import "Conversation.h"
#import "Creator.h"
#import "DashboardEntry.h"
#import "Frame.h"
#import "Messages.h"
#import "Roll.h"
#import "ShelbyUser.h"
#import "UpvoteUsers.h"
#import "Video.h"

// Entity Constants
#define CoreDataEntityConversation              @"Conversation"
#define CoreDataEntityDashboardEntry            @"DashboardEntry"
#define CoreDataEntityFrame                     @"Frame"
#define CoreDataEntityMessages                  @"Messages"
#define CoreDataEntityRoll                      @"Roll"
#define CoreDataEntityShelbyUser                @"ShelbyUser"
#define CoreDataEntityUpvoteUsers               @"UpvoteUsers"
#define CoreDataEntityCreator                   @"Creator"
#define CoreDataEntityVideo                     @"Video"

// Relationship Constants
#define CoreDataRelationshipConversation        @"conversation"
#define CoreDataRelationshipDashboardEntry      @"dashboardEntry"
#define CoreDataRelationshipFrame               @"frame"
#define CoreDataRelationshipMessages            @"messages"
#define CoreDataRelationshipRoll                @"roll"
#define CoreDataRelationshipUser                @"user"
#define CoreDataRelationshipVideo               @"video"

// Conversation Attribute Constants
#define CoreDataConversationID                  @"conversationID"
#define CoreDataConversationMessageCount        @"messageCount"

// Creator Attribute Constants
#define CoreDataUserID                          @"creatorID"
#define CoreDataUserImage                       @"userImage"
#define CoreDataUserNickname                    @"nickname"

// DashboardEntry Attribute Constants
#define CoreDataDashboardEntryID                @"dashboardID"
#define CoreDataDashboardEntryTimestamp         @"timestamp"

// Frame Attribute Constants
#define CoreDataFrameConversationID             @"conversationID"
#define CoreDataFrameCreatedAt                  @"createdAt"
#define CoreDataFrameCreatorID                  @"creatorID"
#define CoreDataFrameID                         @"frameID"
#define CoreDataFrameRollID                     @"rollID"
#define CoreDataFrameTimestamp                  @"timestamp"
#define CoreDataFrameUpvotersCount              @"upvotersCount"
#define CoreDataFrameVideoID                    @"videoID"

// Messages Attribute Constants
#define CoreDataMessagesConversationID          @"conversationID"
#define CoreDataMessagesCreatedAt               @"createdAt"
#define CoreDataMessagesID                      @"messagesID"
#define CoreDataMessagesNickname                @"nickname"
#define CoreDataMessagesOriginNetwork           @"originNetwork"
#define CoreDataMessagesText                    @"text"
#define CoreDataMessagesTimestamp               @"timestamp"
#define CoreDataMessagesUserImage               @"userImage"

// Roll Attribute Constants
#define CoreDataRollID                          @"rollID"
#define CoreDataRollCreatorID                   @"creatorID"
#define CoreDataRollCreatorNickname             @"creatorNickname"
#define CoreDataRollFrameCount                  @"frameCount"
#define CoreDataRollFollowingCount              @"followingCount"
#define CoreDataRollThumbnailURL                @"thumbnailURL"
#define CoreDataRollTitle                       @"title"

// ShelbyUser Attribute Constants
#define CoreDataShelbyUserID                    @"shelbyID"
#define CoreDataShelbyUserAuthToken             @"authToken"
#define CoreDataShelbyAuthenticatedFacebook     @"authenticatedWithFacebook"
#define CoreDataShelbyAuthenticatedTwitter      @"authenticatedWithTwitter"
#define CoreDataShelbyAuthenticatedTumblr       @"authenticatedWithTumblr"
#define CoreDataShelbyUserHeartRollID           @"heartRollID"
#define CoreDataShelbyUserImage                 @"userImage"
#define CoreDataShelbyUserNickname              @"nickname"
#define CoreDataShelbyUserPersonalRollID        @"personalRollID"
#define CoreDataShelbyUserPublicRollID          @"publicRollID"
#define CoreDataShelbyUserWatchLaterRollID      @"watchLaterRollID"

// UpvoteUsers Attribute Constants
#define CoreDataUpvoteUserID                    @"upvoterID"
#define CoreDataUpvoteUsersNickname             @"nickname"
#define CoreDataUpvoteUsersRollID               @"rollID"
#define CoreDataUpvoteUsersImage                @"userImage"

// Video Attribute Constants
#define CoreDataVideoID                         @"videoID"
#define CoreDataVideoCaption                    @"caption"
#define CoreDataVideoProviderName               @"providerName"
#define CoreDataVideoProviderID                 @"providerID"
#define CoreDataVideoSourceURL                  @"sourceURL"
#define CoreDataVideoTitle                      @"title"
#define CoreDataVideoThumbnailURL               @"thumbnailURL"