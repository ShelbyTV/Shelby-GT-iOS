//
//  Structures.h
//  Shelby-tv
//
//  Created by Arthur Ariel Sabintsev on 4/30/12.
//  Copyright (c) 2012 Shelby.tv. All rights reserved.
//

// Structure that distinguishes instances of GuideTableViewController;
typedef enum _GuideType
{
    
    GuideType_None = 0,
    GuideType_BrowseRolls,
    GuideType_MyRolls,
    GuideType_PeopleRolls,
    GuideType_Settings,
    GuideType_Stream
    
} GuideType;


// Structure that distinguishes types of Shelby API Requests
typedef enum _APIRequestType
{
    
    APIRequestType_None = 0,
    APIRequestType_PostToken,
    APIRequestType_GetStream,
    APIRequestType_GetRollsFollowing,
    APIRequestType_GetBrowseRolls,
    APIRequestType_PostUpvote,
    APIRequestType_PostDownvote
    
} APIRequestType;