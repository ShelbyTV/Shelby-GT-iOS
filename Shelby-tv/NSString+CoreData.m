//
//  NSString+TestForNullForCoreDataAttribute.m
//  Shelby-tv
//
//  Created by Arthur Ariel Sabintsev on 5/16/12.
//  Copyright (c) 2012 Shelby.tv. All rights reserved.
//

#import "NSString+CoreData.h"

@implementation NSString (CoreData)

+ (NSString*)testForNullForCoreDataAttribute:(NSString*)string
{
    return [string isEqual:[NSNull null]] ? nil : string;
}

@end