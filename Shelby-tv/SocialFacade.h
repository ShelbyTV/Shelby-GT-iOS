//
//  SocialFacade.h
//  SocialFacade
//
//  Created by Arthur Ariel Sabintsev on 4/18/12.
//  Copyright (c) 2012 ArtSabintsev. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FBConnect.h"

/// NSNotificationCenter Macros ///
#define         SocialFacadeAuthorizationStatus     @"SocialFacadeAuthorizationStatus"

/// SocialFacadeDelegate - Delegate Method for Login Screens ///
@protocol SocialFacadeDelegate <NSObject>
- (void)authorizationStatus;
@end

@interface SocialFacade : NSObject <FBSessionDelegate, FBRequestDelegate>

/// General Properties ///
@property (strong, nonatomic) Facebook *facebook;
@property (strong, nonatomic) UIViewController *loginViewController;

/// Properties utilizing NSUserDefaults ///
// General
@property (assign, nonatomic) BOOL previouslyLaunched;
@property (assign, nonatomic) BOOL firstTimeLogin;

// Shelby
@property (assign, nonatomic) BOOL shelbyAuthorized;
@property (copy, nonatomic) NSString *shelbyToken;
@property (copy, nonatomic) NSString *shelbyCreatorID;
@property (copy, nonatomic) NSString *shelbyNickname;
@property (copy, nonatomic) NSString *shelbyUserImage;


/// Singleton Class Method ///
+(SocialFacade *)sharedInstance;

/// Authorization Methods ///
// Shelby
- (void)shelbyLogout;

// Facebook
- (void)facebookLogin;

// Twitter
- (void)twitterLogin;


@end