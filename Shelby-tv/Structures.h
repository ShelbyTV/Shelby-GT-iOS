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
    
    GuideType_Stream = 0,
    GuideType_PeopleRolls,
    GuideType_MyRolls,
    GuideType_BrowseRolls,
    GuideType_Settings
    
} GuideType;


// Structure that distinguishes types of Shelby API Requests
typedef enum _APIRequestType
{
    
    APIRequestType_None = 0,
    APIRequestType_PostToken,
    APIRequestType_GetShelbyUser,
    APIRequestType_GetStream,
    APIRequestType_GetFrame,
    APIRequestType_GetRolls,
    APIRequestType_PostUpvote,
    APIRequestType_PostDownvote
    
} APIRequestType;