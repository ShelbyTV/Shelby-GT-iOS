//
//  APIConstants.h
//  Shelby-tv
//
//  Created by Arthur Ariel Sabintsev on 4/20/12.
//  Copyright (c) 2012 Shelby.tv. All rights reserved.
//

// Macros for API Routes
#define kAPIRequestPostTokenFacebook    @"http://api.gt.shelby.tv/v1/token?provider_name=facebook&uid=%@&token=%@"
#define kAPIRequestPostTokenTwitter     @"http://api.gt.shelby.tv/v1/token?provider_name=twitter&uid=%@&token=%@&secret=%@"
#define kAPIRequestGetStream            @"http://api.gt.shelby.tv/v1/dashboard?auth_token=%@"
#define kAPIRequestPostUpvote           @"http://api.gt.shelby.tv/v1/frame/%@/upvote?auth_token=sF7waBf8jBMqsxeskPp2"

// Macros for Parsed Data
#define kAPIResult                      @"result"
#define kAPIStatus                      @"status"
#define kAPIStatusSuccessful            200

// Macros for Notificaitons
#define kAPIRequestNotification         @"APIRequestType"