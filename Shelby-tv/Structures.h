//
//  Structures.h
//  Shelby.tv
//
//  Created by Arthur Ariel Sabintsev on 4/30/12.
//  Copyright (c) 2012 Shelby.tv. All rights reserved.
//

// Structure that distinguishes instances of GuideTableViewController;
typedef enum _GuideType
{
    
    GuideType_None = 0,
    GuideType_ExploreRolls,
    GuideType_FriendsRolls,
    GuideType_MyRolls,
    GuideType_Settings,
    GuideType_Stream,
    GuideType_RollFrames
    
} GuideType;


// Structure that distinguishes types of Shelby API Requests
typedef enum _APIRequestType
{
    
    APIRequestType_None = 0,
    APIRequestType_PostToken,
    APIRequestType_GetStream,
    APIRequestType_GetRollsFollowing,
    APIRequestType_GetExploreRolls,
    APIRequestType_GetRollFrames,
    APIRequestType_PostUpvote,
    APIRequestType_PostDownvote,
    APIRequestType_PostShareFrame,
    APIRequestType_PostRollFrame,
    APIRequestType_PostCreateRoll,
    APIRequestType_PostMessage
    
} APIRequestType;