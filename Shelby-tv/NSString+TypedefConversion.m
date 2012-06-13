//
//  NSString+TypedefConversion.m
//  Shelby-tv
//
//  Created by Arthur Ariel Sabintsev on 5/2/12.
//  Copyright (c) 2012 Shelby.tv. All rights reserved.
//

#import "NSString+TypedefConversion.h"

@implementation NSString (TypedefConversion)

+ (NSString*)apiRequestTypeToString:(APIRequestType)type
{
    return [NSString stringWithFormat:@"%@%d", APIRequest_Notification, type];
}

@end