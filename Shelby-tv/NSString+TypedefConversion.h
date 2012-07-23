//
//  NSString+TypedefConversion.h
//  Shelby.tv
//
//  Created by Arthur Ariel Sabintsev on 5/2/12.
//  Copyright (c) 2012 Shelby.tv. All rights reserved.
//

@interface NSString (TypedefConversion)

+ (NSString*)requestTypeToString:(APIRequestType)type;

@end