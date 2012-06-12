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
    
    GuideType_Stream= 0,
    GuideType_PeopleRolls,
    GuideType_MyRolls,
    GuideType_BrowseRolls,
    GuideType_Settings
    
} GuideType;


// Structure that distinguishes types of Shelby API Requests
typedef enum _APIRequestType
{
    
    APIRequestTypeNone = 0,
    APIRequestTypePostToken,
    APIRequestTypeGetStream,
    APIRequestTypeGetRolls,
    APIRequestTypePostUpvote
    
} APIRequestType;