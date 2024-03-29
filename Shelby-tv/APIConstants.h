//
//  APIConstants.h
//  Shelby.tv
//
//  Created by Arthur Ariel Sabintsev on 4/20/12.
//  Copyright (c) 2012 Shelby.tv. All rights reserved.
//

// Macros for API Routes
#define APIRequest_PostTokenFacebook            @"http://api.gt.shelby.tv/v1/token?provider_name=facebook&uid=%@&token=%@"
#define APIRequest_PostTokenTwitter             @"http://api.gt.shelby.tv/v1/token?provider_name=twitter&uid=%@&token=%@&secret=%@"
#define APIRequest_GetStream                    @"http://api.gt.shelby.tv/v1/dashboard?auth_token=%@"
#define APIRequest_GetStreamAgain               @"http://api.gt.shelby.tv/v1/dashboard?auth_token=%@&skip=%d"
#define APIRequest_GetFrame                     @"http://api.gt.shelby.tv/v1/frame/%@?auth_token=%@"
#define APIRequest_GetRollsFollowing            @"http://api.gt.shelby.tv/v1/user/%@/rolls/following?auth_token=%@"
#define APIRequest_GetRollsFollowingAgain       @"http://api.gt.shelby.tv/v1/user/%@/rolls/following?auth_token=%@&skip=%d"
#define APIRequest_GetExploreRolls              @"http://api.gt.shelby.tv/v1/roll/browse?auth_token=%@"
#define APIRequest_GetRollFrames                @"http://api.gt.shelby.tv/v1/roll/%@/frames?auth_token=%@"
#define APIRequest_PostUpvote                   @"http://api.gt.shelby.tv/v1/frame/%@/upvote?auth_token=%@"
#define APIRequest_PostDownvote                 @"http://api.gt.shelby.tv/v1/frame/%@/upvote?undo=1&auth_token=%@"
#define APIRequest_PostShareFrame               @"http://api.gt.shelby.tv/v1/frame/%@/share?auth_token=%@"
#define APIRequest_PostRollFrame                @"http://api.gt.shelby.tv/v1/roll/%@/frames?frame_id=%@&auth_token=%@"
#define APIRequest_PostShareRoll                @"http://api.gt.shelby.tv/v1/roll/%@/share?auth_token=%@"
#define APIRequest_PostCreateRoll               @"http://api.gt.shelby.tv/v1/roll?title=%@&public=%d&collaborative=%d&auth_token=%@"
#define APIRequest_PostMessage                  @"http://api.gt.shelby.tv/v1/conversation/%@/messages?text=%@&auth_token=%@"

// Macros for Parsed Data
#define APIRequest_Result                       @"result"
#define APIRequest_Status                       @"status"
#define APIRequest_StatusSuccessful             200

// Macros for Notificaitons
#define APIRequest_Notification                 @"APIRequestNotification"