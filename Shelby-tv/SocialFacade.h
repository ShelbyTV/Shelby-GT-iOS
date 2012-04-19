//
//  SocialFacade.h
//  SocialFacade
//
//  Created by Arthur on 4/18/12.
//  Copyright (c) 2012 ArtSabintsev. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Accounts/Accounts.h>
#import <Twitter/Twitter.h>
#import "FBConnect.h"

/// Authorization Macros ///
#define         SocialFacadeFacebookAPIKey                  @"349934901721555"
#define         SocialFacadeTwitterAPIKey                   @"YKVKw0xSviXfMQ6o2MaoA"

/// NSNotificationCenter Macros ///
#define         SocialFacadeFacebookAuthorizationStatus     @"SocialFacadeFacebookAuthorizationStatus"

/// RequestType - Used to sort between various Social Requests ///
typedef enum _SocialRequestType 
{
    
    SocialRequestFinished = 0,                 // Requests Finished
    SocialRequestGetFacebookNameAndID = 1,     // GET authenticated in user's Facebook Name and ID
    SocialRequestGetTwitterNameAndID = 2       // GET authenticated in user's Twitter Name and ID
    
}  SocialRequestType;

/// SocialFacadeDelegate - Delegate Method for Login Screens ///
@protocol SocialFacadeDelegate <NSObject>
- (void)facebookAuthorizationStatus;
@end

@interface SocialFacade : NSObject 
<

FBSessionDelegate, 
FBRequestDelegate

>

/// General Properties ///
@property (strong, nonatomic) Facebook *facebook;
@property (assign, nonatomic) SocialRequestType socialRequestType;

/// Properties utilizing NSUserDefaults ///
@property (assign, nonatomic) BOOL previouslyLaunched;
@property (assign, nonatomic) BOOL facebookAuthorized;
@property (copy, nonatomic) NSString *facebookName;
@property (copy, nonatomic) NSString *facebookID;

/// Singleton Class Method ///
+(SocialFacade *)sharedInstance;

/// Authorization Methods ///
- (void)facebookLogin;
- (void)facebookLogout;

@end