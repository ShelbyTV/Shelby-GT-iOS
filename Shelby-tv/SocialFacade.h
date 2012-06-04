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


/// RequestType - Used to sort between various Social Requests ///
typedef enum _SocialRequestType 
{
    
    SocialRequestFinished = 0,                 // Requests Finished
    SocialRequestGetFacebookNameAndID = 1,     // GET authenticated in user's Facebook Name and ID
    SocialRequestGetTwitterNameAndID = 2       // GET authenticated in user's Twitter Name and ID
    
}  SocialRequestType;

/// SocialFacadeDelegate - Delegate Method for Login Screens ///
@protocol SocialFacadeDelegate <NSObject>
- (void)authorizationStatus;
@end

@interface SocialFacade : NSObject <FBSessionDelegate, FBRequestDelegate>

/// General Properties ///
@property (strong, nonatomic) Facebook *facebook;
@property (assign, nonatomic) SocialRequestType socialRequestType;
@property (strong, nonatomic) UIViewController *loginViewController;

/// Properties utilizing NSUserDefaults ///
// General
@property (assign, nonatomic) BOOL previouslyLaunched;

// Shelby
@property (assign, nonatomic) BOOL shelbyAuthorized;
@property (copy, nonatomic) NSString *shelbyToken;
@property (copy, nonatomic) NSString *shelbyCreatorID;

// Facebook
@property (copy, nonatomic) NSString *facebookName;
@property (copy, nonatomic) NSString *facebookID;

// Twitter
@property (copy, nonatomic) NSString *twitterName;
@property (copy, nonatomic) NSString *twitterID;

/// Singleton Class Method ///
+(SocialFacade *)sharedInstance;

/// Authorization Methods ///
// Facebook
- (void)facebookLogin;
- (void)facebookLogout;

// Twitter
- (void)twitterLogin;
- (void)twitterLogout;

@end