//
//  ShelbyAPIClient.h
//  Shelby.tv
//
//  Created by Arthur Ariel Sabintsev on 5/2/12.
//  Copyright (c) 2012 Shelby.tv. All rights reserved.
//

#import <Foundation/Foundation.h>
@interface ShelbyAPIClient : NSObject <NSURLConnectionDataDelegate>

// Request Methods
- (void)performRequest:(NSMutableURLRequest*)request ofType:(APIRequestType)type;
- (void)performAsynchronousRequest:(NSMutableURLRequest*)request ofType:(APIRequestType)type;

@end