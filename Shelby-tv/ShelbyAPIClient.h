//
//  ShelbyAPIClient.h
//  Shelby-tv
//
//  Created by Arthur Ariel Sabintsev on 5/2/12.
//  Copyright (c) 2012 Shelby.tv. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "StaticDeclarations.h"

@interface ShelbyAPIClient : NSObject <NSURLConnectionDataDelegate>

// Request Methods
- (void)performGetRequest:(NSURLRequest*)request ofType:(APIRequestType)type;
- (void)performPostRequest:(NSURLRequest*)request ofType:(APIRequestType)type;

@end