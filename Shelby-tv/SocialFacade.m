//
//  SocialFacade.m
//  SocialFacade
//
//  Created by Arthur Ariel Sabintsev on 4/18/12.
//  Copyright (c) 2012 ArtSabintsev. All rights reserved.
//

#import "SocialFacade.h"

#pragma mark - Private Macros
/// Miscellaenous Macros ///
static SocialFacade *sharedInstance = nil;
#define         SocialFacadePreviouslyLaunched          @"SocialFacadePreviouslyLaunched"

/// Facebook Macros ///
#define         SocialFacadeFacebookAuthorized          @"SocialFacadeFacebookAuthorized"
#define         SocialFacadeFacebookName                @"SocialFacadeFacebookName"
#define         SocialFacadeFacebookID                  @"SocialFacadeFacebookID"

/// Twitter Macros ///
#define         SocialFacadeTwitterAuthorized           @"SocialFacadeFacebookAuthorized"
#define         SocialFacadeTwitterName                 @"SocialFacadeTwitterName"
#define         SocialFacadeTwitterID                   @"SocialFacadeTwitterID"

#pragma mark - Private Declarations
@interface SocialFacade ()

/// Facebook Methods ///
- (void)facebookLogin;
- (void)facebookLogout;
- (void)checkFacebookAuthorizationStatusOnLaunch;
- (void)getFacebookNameAndID;
- (void)resetFacebookUserDefaults;

/// Twitter Methods ///
- (void)twitterLogin;
- (void)twitterLogout;

@end

@implementation SocialFacade
@synthesize facebook = _facebook;
@synthesize socialRequestType = _socialRequestType;

#pragma mark - Singleton Methods
+ (SocialFacade*)sharedInstance
{
    if (!sharedInstance) {
        sharedInstance = [[super allocWithZone:NULL] init];
    }
    
    return sharedInstance;
}

- (id)init {
    
    self = [super init];
    
    if ( self ) {
        
        // Set Default NSUserDefaults
        if ( ![self previouslyLaunched] ) {
            
            // Set to YES, so this condition is never again satisfied
            self.previouslyLaunched = YES;
            
            // Set Facebook NSUserDefaults to 'nil' on first launch
            self.facebookAuthorized = NO;
            self.facebookName = nil;
            self.facebookID = nil;
            
        }
        
        // Check Facebook Authorization Status on launch
        [self checkFacebookAuthorizationStatusOnLaunch];
        
    }
    
    return self;
}

+ (id)allocWithZone:(NSZone *)zone
{
    return [self sharedInstance];
}

- (id)copyWithZone:(NSZone *)zone
{
    return self;
}

#pragma mark - Facebook Authorization Methods
- (void)facebookLogin
{
    // If Facebook Session does not exist, create a new session with specific permissions
    if ( ![self.facebook isSessionValid] ) {
        
        NSArray *permissions = [[NSArray alloc] initWithObjects:@"publish_stream", @"user_about_me", nil];
        
        [self.facebook authorize:permissions];
    }
}

- (void)facebookLogout
{
    // Logout of Facebook
    [self.facebook logout];
}

- (void)checkFacebookAuthorizationStatusOnLaunch 
{
    
    // Initialize Facebook State Variable
    self.facebook = [[Facebook alloc] initWithAppId:SocialFacadeFacebookAPIKey andDelegate:self];
    
    // If user has Facebook authorized via Single Sign-on, set NSUserDefault Facebook Authorization Variable to YES/TRUE
    if ( [[NSUserDefaults standardUserDefaults] valueForKey:@"FBAccessTokenKey"] && [[NSUserDefaults standardUserDefaults] valueForKey:@"FBExpirationDateKey"]) {
        
        // This fixes the accessToken and expirationDate properties being set to nil when the app shutsdown/restarts (blame Facebook's SDK - February 8, 2012 release)
        self.facebook.accessToken = [[NSUserDefaults standardUserDefaults] valueForKey:@"FBAccessTokenKey"];
        self.facebook.expirationDate = [[NSUserDefaults standardUserDefaults] valueForKey:@"FBExpirationDateKey"];
        
        NSLog(@"\nPersisted Token: %@\nExpiration Date: %@", [[NSUserDefaults standardUserDefaults] valueForKey:@"FBAccessTokenKey"], [[NSUserDefaults standardUserDefaults] valueForKey:@"FBExpirationDateKey"]);
        
        // Set Facebook Authorization NSUserDefault to  YES
        [self setFacebookAuthorized:YES];
        
    } else {
        
        // Set Facebook Authorization NSUserDefault to  NO
        [self setFacebookAuthorized:NO];
        
    }
    
}

#pragma mark - Facebook Request Methods
- (void)getFacebookNameAndID
{
    // Get logged in user's Name and ID
    self.socialRequestType = SocialRequestGetFacebookNameAndID;
    
    // Perform GraphAPI Request (Step 2 of getting logged in user's Name and ID)
    [self.facebook requestWithGraphPath:@"me" andDelegate:self];
}

#pragma mark - Facebook Reset/Cleaning Methods
- (void)resetFacebookUserDefaults
{
    // Set Facebook Properties to nil
    self.facebookName = nil;
    self.facebookID = nil;
}

#pragma mark - FBSessionDelegate Methods
/// Method called upon succesful login ///
- (void)fbDidLogin 
{
    // Save Facebook Token and Token's Expiration Date
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:[self.facebook accessToken] forKey:@"FBAccessTokenKey"];
    [defaults setObject:[self.facebook expirationDate] forKey:@"FBExpirationDateKey"];
    [defaults synchronize];
    
    NSLog(@"\nOriginal Token: %@\nExpiration Date: %@", [[NSUserDefaults standardUserDefaults] valueForKey:@"FBAccessTokenKey"], [[NSUserDefaults standardUserDefaults] valueForKey:@"FBExpirationDateKey"]);
    
    // Extend Token for 60 Days
    [self.facebook extendAccessToken];
    
    // Set Facebook Authorization NSUserDefault to YES
    [self setFacebookAuthorized:YES];
    
    // Get authenticated user's Name and ID
    [self getFacebookNameAndID];
    
}

/// Method called upon successful logout ///
- (void)fbDidLogout 
{
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if ([defaults objectForKey:@"FBAccessTokenKey"]) {
        [defaults removeObjectForKey:@"FBAccessTokenKey"];
        [defaults removeObjectForKey:@"FBExpirationDateKey"];
        [defaults synchronize];
    }
    
    // Set custom Facebook-related NSUserDefaults to nil
    [self resetFacebookUserDefaults];
    
    // Set Facebook Authorization NSUserDefault to NO
    self.facebookAuthorized = NO;
    
    // Transmit Authorization Status to Observer
    [[NSNotificationCenter defaultCenter] postNotificationName:SocialFacadeFacebookAuthorizationStatus object:nil];
    
}

- (void)fbDidNotLogin:(BOOL)cancelled
{
    // Do Nothing
}

-(void)fbDidExtendToken:(NSString *)accessToken expiresAt:(NSDate *)expiresAt 
{
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:accessToken forKey:@"FBAccessTokenKey"];
    [defaults setObject:expiresAt forKey:@"FBExpirationDateKey"];
    [defaults synchronize];
    
    NSLog(@"\nExtended Token: %@\nExpiration Date: %@", [[NSUserDefaults standardUserDefaults] valueForKey:@"FBAccessTokenKey"], [[NSUserDefaults standardUserDefaults] valueForKey:@"FBExpirationDateKey"]);
    
}

- (void)fbSessionInvalidated
{
    [self resetFacebookUserDefaults];
}

#pragma mark - FBRequestDelegate Methods
- (void)request:(FBRequest *)request didLoad:(id)result 
{
    // Perform Actions from FBRequest results
    
    if ( self.socialRequestType == SocialRequestGetFacebookNameAndID ) {
        
        NSDictionary *dictionary = (NSDictionary*)result;
        NSString *facebookName = [dictionary objectForKey:@"name"];
        NSString *facebookID = [dictionary objectForKey:@"id"];
        [self setFacebookName:facebookName];
        [self setFacebookID:facebookID];
        [[NSNotificationCenter defaultCenter] postNotificationName:SocialFacadeFacebookAuthorizationStatus object:nil];
        
    } 
    
    // Reset SocialRequestType to prevent accidental/improper requests in the future
    self.socialRequestType = SocialRequestFinished;
}

- (void)request:(FBRequest *)request didFailWithError:(NSError *)error
{
    
    if ( self.socialRequestType == SocialRequestGetFacebookNameAndID ) {
        
        // Create 'Failure Alert' Object
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Failure" 
                                                            message:@"You failed to login. Please try again." 
                                                           delegate:self 
                                                  cancelButtonTitle:@"Dismiss" 
                                                  otherButtonTitles:nil, nil];
        
        // Present alertView object
        [alertView show];
        
    } 
    
    // Reset SocialRequestType to prevent accidental/improper requests in the future
    self.socialRequestType = SocialRequestFinished;
    
}

#pragma mark - Twitter Authorization Methods
- (void)twitterLogin
{
	// Create an accountStore object
	ACAccountStore *accountStore = [[ACAccountStore alloc] init];
	
	// Create an accountType object that ensures Twitter accounts are retrieved
    ACAccountType *accountType = [accountStore accountTypeWithAccountTypeIdentifier:ACAccountTypeIdentifierTwitter];
    
    [accountStore requestAccessToAccountsWithType:accountType withCompletionHandler:^(BOOL granted, NSError *error) {
    
        if ( granted ) {
            
        } else {
            
        }
    
    }];
    
}

- (void)twitterLogout
{
    
}


#pragma mark - Accessor Methods
/// First Launch Flag /// 
- (void)setPreviouslyLaunched:(BOOL)previouslyLaunched
{
    [[NSUserDefaults standardUserDefaults] setBool:previouslyLaunched forKey:SocialFacadePreviouslyLaunched];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (BOOL)previouslyLaunched
{
    return [[NSUserDefaults standardUserDefaults] boolForKey:SocialFacadePreviouslyLaunched];
}

/// Facebook Authorization Flag /// 
- (void)setFacebookAuthorized:(BOOL)facebookAuthorized
{
    
    [[NSUserDefaults standardUserDefaults] setBool:facebookAuthorized forKey:SocialFacadeFacebookAuthorized];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (BOOL)facebookAuthorized 
{
    return [[NSUserDefaults standardUserDefaults] boolForKey:SocialFacadeFacebookAuthorized];
}

/// Facebook Name /// 
- (void)setFacebookName:(NSString *)facebookName
{
    [[NSUserDefaults standardUserDefaults] setObject:facebookName forKey:SocialFacadeFacebookName];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (NSString*)facebookName
{
    return [[NSUserDefaults standardUserDefaults] objectForKey:SocialFacadeFacebookName];
}

/// Facebook ID /// 
- (void)setFacebookID:(NSString *)facebookID
{
    [[NSUserDefaults standardUserDefaults] setObject:facebookID forKey:SocialFacadeFacebookID];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (NSString*)facebookID
{
    return [[NSUserDefaults standardUserDefaults] objectForKey:SocialFacadeFacebookID];
}

/// Twitter Authorization Flag /// 
- (void)setTwitterAuthorized:(BOOL)twitterAuthorized
{
    
    [[NSUserDefaults standardUserDefaults] setBool:twitterAuthorized forKey:SocialFacadeTwitterAuthorized];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (BOOL)twitterAuthorized 
{
    return [[NSUserDefaults standardUserDefaults] boolForKey:SocialFacadeTwitterAuthorized];
}

/// Twitter Name /// 
- (void)setTwitterName:(NSString *)twitterName
{
    [[NSUserDefaults standardUserDefaults] setObject:twitterName forKey:SocialFacadeTwitterName];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (NSString*)twitterName
{
    return [[NSUserDefaults standardUserDefaults] objectForKey:SocialFacadeTwitterName];
}

/// Twitter ID /// 
- (void)setTwitterID:(NSString *)twitterID
{
    [[NSUserDefaults standardUserDefaults] setObject:twitterID forKey:SocialFacadeTwitterID];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (NSString*)twitterID
{
    return [[NSUserDefaults standardUserDefaults] objectForKey:SocialFacadeTwitterID];
}

@end