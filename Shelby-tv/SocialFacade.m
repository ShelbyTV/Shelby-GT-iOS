//
//  SocialFacade.m
//  SocialFacade
//
//  Created by Arthur Ariel Sabintsev on 4/18/12.
//  Copyright (c) 2012 ArtSabintsev. All rights reserved.
//

#import "SocialFacade.h"
#import "OAuthConsumer.h"
#import "AuthenticateTwitterViewController.h"

#pragma mark - Private Macros
/// Authorization Macros ///
#define         SocialFacadeFacebookAppID                   @"115071338568035"
#define         SocialFacadeTwitterConsumerKey              @"5DNrVZpdIwhQthCJJXCfnQ"
#define         SocialFacadeTwitterConsumerSecret           @"Tlb35nblFFTZRidpu36Uo3z9mfcvSVv1MuZZ19SHaU"

/// Facebook Macros ///
#define         SocialFacadeFacebookAuthorized              @"SocialFacadeFacebookAuthorized"
#define         SocialFacadeFacebookName                    @"SocialFacadeFacebookName"
#define         SocialFacadeFacebookID                      @"SocialFacadeFacebookID"

/// Twitter Macros ///
#define         SocialFacadeTwitterAuthorized               @"SocialFacadeFacebookAuthorized"
#define         SocialFacadeTwitterName                     @"SocialFacadeTwitterName"
#define         SocialFacadeTwitterID                       @"SocialFacadeTwitterID"

/// Miscellaenous Macros ///
static SocialFacade *sharedInstance = nil;
#define         SocialFacadePreviouslyLaunched              @"SocialFacadePreviouslyLaunched"

#pragma mark - Private Declarations
@interface SocialFacade () <AuthenticateTwitterDelegate>

@property (strong, nonatomic) OAToken *requestToken;

/// Facebook Methods ///
- (void)facebookLogin;
- (void)facebookLogout;
- (void)checkFacebookAuthorizationStatusOnLaunch;
- (void)getFacebookNameAndID;
- (void)resetFacebookUserDefaults;

/// Twitter Methods ///
- (void)twitterLogin;
- (void)twitterLogout;
- (void)createNewTwitterAccount:(ACAccountType*)type;

/// OAuth - Request Token Methods ///
- (void)getRequestToken;
- (void)requestTokenTicket:(OAServiceTicket *)ticket didFinishWithData:(NSData *)data; 
- (void)requestTokenTicket:(OAServiceTicket *)ticket didFailWithError:(NSData *)data;
- (void)authenticateTwitterAccount:(NSData*)data;

// OAuth - Access Token Methods ///
- (void)getAccessTokenWithPin:(NSString*)pin;
- (void)accessTokenTicket:(OAServiceTicket*)ticket didFinishWithData:(NSData*)data; 
- (void)accessTokenTicket:(OAServiceTicket*)ticket didFailWithError:(NSData*)data; 
- (void)saveTwitterAccountWithAccessToken:(OAToken*)accessToken;

/// Oauth - Reverse Auth Methods ///
- (void)getReverseAuthRequestToken;
- (void)reverseAuthTicket:(OAServiceTicket *)ticket didFinishWithData:(NSData *)data;
- (void)reverseAuthTicket:(OAServiceTicket *)ticket didFailWithError:(NSData *)data; 

@end

@implementation SocialFacade
@synthesize facebook = _facebook;
@synthesize socialRequestType = _socialRequestType;
@synthesize loginViewController = _loginViewController;
@synthesize requestToken = _requestToken;


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
    if ( ![self.facebook isSessionValid] ) {
        
        NSArray *permissions = [[NSArray alloc] initWithObjects:@"publish_stream", @"user_about_me", nil];
        
        [self.facebook authorize:permissions];
    }
}

- (void)facebookLogout
{
    [self.facebook logout];
}

- (void)checkFacebookAuthorizationStatusOnLaunch 
{
    
    self.facebook = [[Facebook alloc] initWithAppId:SocialFacadeFacebookAppID andDelegate:self];
    
    // If user has Facebook authorized via Single Sign-on, set NSUserDefault Facebook Authorization Variable to YES/TRUE
    if ( [[NSUserDefaults standardUserDefaults] valueForKey:@"FBAccessTokenKey"] && [[NSUserDefaults standardUserDefaults] valueForKey:@"FBExpirationDateKey"]) {
        
        /* 
        
         This fixes the accessToken and expirationDate properties being set to nil 
         when the app shutsdown/restarts. Blame Facebook's SDK.
         */
        
        self.facebook.accessToken = [[NSUserDefaults standardUserDefaults] valueForKey:@"FBAccessTokenKey"];
        self.facebook.expirationDate = [[NSUserDefaults standardUserDefaults] valueForKey:@"FBExpirationDateKey"];
        
        NSLog(@"\nPersisted Token: %@\nExpiration Date: %@", [[NSUserDefaults standardUserDefaults] valueForKey:@"FBAccessTokenKey"], [[NSUserDefaults standardUserDefaults] valueForKey:@"FBExpirationDateKey"]);
        
        [self setFacebookAuthorized:YES];
        
    } else {
        
        [self setFacebookAuthorized:NO];
        
    }
    
}

#pragma mark - Facebook Request Methods
- (void)getFacebookNameAndID
{

    self.socialRequestType = SocialRequestGetFacebookNameAndID;
    
    // Perform GraphAPI Request to obtain Facebook user's Name and ID
    [self.facebook requestWithGraphPath:@"me" andDelegate:self];
}

#pragma mark - Facebook Reset/Cleaning Methods
- (void)resetFacebookUserDefaults
{
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
    
    [self resetFacebookUserDefaults];
    
    self.facebookAuthorized = NO;
    
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
    // Perform actions from FBRequest results
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
        
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Failure" 
                                                            message:@"You failed to login. Please try again." 
                                                           delegate:self 
                                                  cancelButtonTitle:@"Dismiss" 
                                                  otherButtonTitles:nil, nil];
        
        [alertView show];
        
    } 
    
    // Reset SocialRequestType to prevent accidental/improper requests in the future
    self.socialRequestType = SocialRequestFinished;
    
}

#pragma mark - Twitter Authorization Methods
- (void)twitterLogin
{
    [self getRequestToken];
    
}

- (void)twitterLogout
{
    
}

- (void)createNewTwitterAccount:(ACAccountType *)type
{
    
}

#pragma mark - OAuthConsumer RequestToken Methods
- (void)getRequestToken 
{
    
    // Remove reqeustToken value if value exists and/or user decides to re-authenticate
    self.requestToken = nil;
    
    NSURL *url = [NSURL URLWithString:@"https://api.twitter.com/oauth/request_token"];
    OAConsumer *consumer= [[OAConsumer alloc] initWithKey:SocialFacadeTwitterConsumerKey secret:SocialFacadeTwitterConsumerSecret];
    OAMutableURLRequest *request = [[OAMutableURLRequest alloc] initWithURL:url
                                                                   consumer:consumer
                                                                      token:nil
                                                                      realm:nil 
                                                          signatureProvider:nil];
    
    [request setHTTPMethod:@"POST"];
    
    OARequestParameter *oauthParam = [[OARequestParameter alloc] initWithName:@"oauth_callback" value:@"oob"];
    NSArray *params = [NSArray arrayWithObject:oauthParam];
    [request setParameters:params];
    
    OADataFetcher *requestTokenFetcher = [[OADataFetcher alloc] init];
    [requestTokenFetcher fetchDataWithRequest:request
                                     delegate:self
                            didFinishSelector:@selector(requestTokenTicket:didFinishWithData:)
                              didFailSelector:@selector(requestTokenTicket:didFailWithError:)];
    
}

- (void)requestTokenTicket:(OAServiceTicket *)ticket didFinishWithData:(NSData *)data 
{

    if (ticket.didSucceed) {
        
        NSString* httpBody = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        self.requestToken = [[OAToken alloc] initWithHTTPResponseBody:httpBody];
        [self authenticateTwitterAccount];
    }
    
}

- (void)requestTokenTicket:(OAServiceTicket *)ticket didFailWithError:(NSData *)data 
{
    // Inform user that there was a problem with acquiring the request token.
}

- (void)authenticateTwitterAccount
{
    
    
    NSURL* authorizeUrl = [NSURL URLWithString:@"https://api.twitter.com/oauth/authenticate"];
    OAMutableURLRequest* authorizeRequest = [[OAMutableURLRequest alloc] initWithURL:authorizeUrl
                                                                            consumer:nil 
                                                                               token:nil
                                                                               realm:nil
                                                                   signatureProvider:nil];
    // Create request for accessToken
    NSString *requestTokenKey = self.requestToken.key;
    OARequestParameter *tokenParam = [[OARequestParameter alloc] initWithName:@"oauth_token" value:requestTokenKey];
    OARequestParameter *loginParam = [[OARequestParameter alloc] initWithName:@"force_login" value:@"false"];
    [authorizeRequest setParameters:[NSArray arrayWithObjects:tokenParam, loginParam, nil]];
    
    
    // Load ViewController (that has webView)
    AuthenticateTwitterViewController *authenticateTwitterViewController = [[AuthenticateTwitterViewController alloc] initWithDelegate:self];
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:authenticateTwitterViewController];
    [self.loginViewController presentModalViewController:navigationController animated:YES];
    [authenticateTwitterViewController.webView loadRequest:authorizeRequest];
    
}

#pragma mark - OAuthConsumer AccessToken Methods
- (void)getAccessTokenWithPin:(NSString *)pin
{
    NSURL *url = [NSURL URLWithString:@"https://api.twitter.com/oauth/access_token"];
    OAMutableURLRequest * accessTokenRequest = [[OAMutableURLRequest alloc] initWithURL:url
                                                                               consumer:nil
                                                                                  token:self.requestToken
                                                                                  realm:nil
                                                                      signatureProvider:nil];
    
    OARequestParameter * tokenParam = [[OARequestParameter alloc] initWithName:@"oauth_token" value:self.requestToken.key];
    OARequestParameter * verifierParam = [[OARequestParameter alloc] initWithName:@"oauth_verifier" value:pin];
    NSArray * params = [NSArray arrayWithObjects:tokenParam, verifierParam, nil];
    [accessTokenRequest setParameters:params];
    
    OADataFetcher * accessTokenFetcher = [[OADataFetcher alloc] init];
    
    [accessTokenFetcher fetchDataWithRequest:accessTokenRequest
                                    delegate:self
                           didFinishSelector:@selector(accessTokenTicket:didFinishWithData:)
                             didFailSelector:@selector(accessTokenTicket:didFailWithError:)];
}


- (void)accessTokenTicket:(OAServiceTicket*)ticket didFinishWithData:(NSData*)data 
{

    NSString* httpBody = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    OAToken *accessToken = [[OAToken alloc] initWithHTTPResponseBody:httpBody];
    [self saveTwitterAccountWithAccessToken:accessToken];
    
}

- (void)accessTokenTicket:(OAServiceTicket*)ticket didFailWithError:(NSData*)data 
{
    // Inform user that there was a problem with acquiring the access token.
}

- (void)saveTwitterAccountWithAccessToken:(OAToken *)accessToken
{
    
    NSString *token = accessToken.key;
    NSString *secret = accessToken.secret;
    
    // Store Twitter Account on device as ACAccount
    ACAccountStore *accountStore = [[ACAccountStore alloc] init];
    ACAccountType *accountType = [accountStore accountTypeWithAccountTypeIdentifier:ACAccountTypeIdentifierTwitter];
    ACAccountCredential *credential = [[ACAccountCredential alloc] initWithOAuthToken:token tokenSecret:secret];
    ACAccount *newAccount = [[ACAccount alloc] initWithAccountType:accountType];
    newAccount.credential = credential;
    [accountStore saveAccount:newAccount withCompletionHandler:^(BOOL success, NSError *error) {

        // This completionHandler block is NOT performed on the Main Thread
        if (success) {

            // Reverse Auth must be performed on Main Thread.
            dispatch_async(dispatch_get_main_queue(), ^{
                [self getReverseAuthRequestToken];
            });
    
        }
    }];

}

#pragma mark - Reverse Auth Methods
- (void)getReverseAuthRequestToken
{

    NSURL *url = [NSURL URLWithString:@"https://api.twitter.com/oauth/request_token"];
    OAConsumer *consumer= [[OAConsumer alloc] initWithKey:SocialFacadeTwitterConsumerKey secret:SocialFacadeTwitterConsumerSecret];
    OAMutableURLRequest *reverseAuthRequest = [[OAMutableURLRequest alloc] initWithURL:url
                                                                              consumer:consumer
                                                                                 token:nil
                                                                                 realm:nil 
                                                                     signatureProvider:nil];
    
    [reverseAuthRequest setHTTPMethod:@"POST"];
    
    OARequestParameter *xauthParam = [[OARequestParameter alloc] initWithName:@"x_auth_mode" value:@"reverse_auth"];
    NSArray *params = [NSArray arrayWithObject:xauthParam];
    [reverseAuthRequest setParameters:params];
    

    // Must be performed on main-thread, since code is c
    OADataFetcher *reverseAuthFetcher = [[OADataFetcher alloc] init];
        [reverseAuthFetcher fetchDataWithRequest:reverseAuthRequest
                                        delegate:self
                               didFinishSelector:@selector(reverseAuthTicket:didFinishWithData:)
                                 didFailSelector:@selector(reverseAuthTicket:didFailWithError:)]; 
    
}

- (void)reverseAuthTicket:(OAServiceTicket *)ticket didFinishWithData:(NSData *)data 
{
    
    if (ticket.didSucceed) {

        NSString* httpBody = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        NSLog(@"%@", httpBody);
        
    }
    
}

- (void)reverseAuthTicket:(OAServiceTicket *)ticket didFailWithError:(NSData *)data 
{
    
    // Inform user that there was a problem with acquiring the request token.
    
}

#pragma mark - AuthenticateTwitterDelegate Methods
- (void)authenticationRequestDidReturnPin:(NSString *)pin
{
    [self getAccessTokenWithPin:pin];
    
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