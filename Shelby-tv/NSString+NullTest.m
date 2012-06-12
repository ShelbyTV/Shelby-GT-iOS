//
//  NSString+TestForNull.m
//  Shelby-tv
//
//  Created by Arthur Ariel Sabintsev on 5/16/12.
//  Copyright (c) 2012 Shelby.tv. All rights reserved.
//

#import "NSString+NullTest.h"

@implementation NSString (NullTest)

+ (NSString*)testForNull:(NSString*)string
{
    return [string isEqual:[NSNull null]] ? nil : string;
}

@end