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

// Request Method
- (id)initWithRequest:(NSURLRequest*)request ofType:(APIRequestType)type;

@end