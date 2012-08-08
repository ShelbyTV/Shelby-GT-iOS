//
//  UDPClient.h
//  Shelby-tv
//
//  Created by Arthur Ariel Sabintsev on 8/8/12.
//  Copyright (c) 2012 Shelby.tv. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UDPClient : NSObject

+ (void)incrementGraphiteForStatistic:(NSString*)statistic;

@end
