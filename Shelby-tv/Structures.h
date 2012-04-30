//
//  Structures.h
//  Shelby-tv
//
//  Created by Arthur Ariel Sabintsev on 4/30/12.
//  Copyright (c) 2012 Shelby.tv. All rights reserved.
//

// Structure that distinguishes instances of StoryTableViewController;
typedef enum _GuideType
{
    GuideTypeStream= 0,
    GuideTypeSaves,
    GuideTypeSearch
    
} GuideType;

// Structure that distinguishes types of Rolls
typedef enum _RollsType
{
    RollsTypeYour = 0,
    RollsTypePeople,
    RollsTypePopular,
    
} RollsType;