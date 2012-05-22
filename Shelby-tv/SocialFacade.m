//
//  SocialFacade.m
//  SocialFacade
//
//  Created by Arthur Ariel Sabintsev on 4/18/12.
//  Copyright (c) 2012 ArtSabintsev. All rights reserved.
//

#import "SocialFacade.h"
#import <Accounts/Accounts.h>
#import <Twitter/Twitter.h>
#import "StaticDeclarations.h"
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
@interface SocialFacade () 
<
AuthenticateTwitterDelegate, 
UIActionSheetDelegate, 
UIPickerViewDataSource, 
UIPickerViewDelegate
>

@property (strong, nonatomic) ACAccountStore *twitterAccountStore;  // accountStore must be peristent
@property (strong, nonatomic) ACAccount *twitterAccount;            // Persistently stores user-specified twitterAccount
@property (strong, nonatomic) OAToken *requestToken;
@property (strong, nonatomic) UIPickerView *twitterPickerView;
@property (strong, nonatomic) NSMutableArray *twitterPickerViewChoices;

/// Facebook Methods ///
- (void)facebookLogin;
- (void)facebookLogout;
- (void)checkFacebookAuthorizationStatusOnLaunch;
- (void)getFacebookNameAndID;
- (void)resetFacebookUserDefaults;

/// Twitter Authorization Methods ///
- (void)twitterLogin;
- (void)twitterLogout;
- (void)checkForExistingTwitterAccounts;
- (void)userHasOneStoredTwitterAccount;
- (void)userHasMultipleStoredTwitterAccounts;

/// Twitter/OAuth - Request Token Methods ///
- (void)getRequestToken;
- (void)requestTokenTicket:(OAServiceTicket*)ticket didFinishWithData:(NSData *)data; 
- (void)requestTokenTicket:(OAServiceTicket*)ticket didFailWithError:(NSData *)data;
- (void)authenticateTwitterAccount;

/// Twitter/OAuth - Access Token Methods ///
- (void)getAccessTokenWithPin:(NSString*)pin;
- (void)accessTokenTicket:(OAServiceTicket*)ticket didFinishWithData:(NSData*)data;
- (void)accessTokenTicket:(OAServiceTicket*)ticket didFailWithError:(NSData *)data;
- (void)saveTwitterAccountWithAccessToken:(OAToken*)accessToken;

/// Twitter/OAuth - Reverse Auth Request Token Methods ///
- (void)getReverseAuthRequestToken;
- (void)reverseAuthRequestTokenTicket:(OAServiceTicket*)ticket didFinishWithData:(NSData *)data;
- (void)reverseAuthRequestTokenTicket:(OAServiceTicket*)ticket didFailWithError:(NSData *)data;

/// Twitter/OAuth - Reverse Auth Access Token Methods ///
- (void)getReverseAuthAccessToken:(NSString*)reverseAuthRequestResults;
- (void)sendReverseAuthAccessResultsToServer:(NSString*)reverseAuthAccessResults;

@end

@implementation SocialFacade
@synthesize facebook = _facebook;
@synthesize socialRequestType = _socialRequestType;
@synthesize loginViewController = _loginViewController;
@synthesize twitterAccountStore = _twitterAccountStore;
@synthesize twitterAccount = _twitterAccount;
@synthesize requestToken = _requestToken;
@synthesize twitterPickerView = _twitterPickerView;
@synthesize twitterPickerViewChoices = _twitterPickerViewChoices;

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
        
        if (DEBUGMODE)  NSLog(@"\nPersisted Token: %@\nExpiration Date: %@", [[NSUserDefaults standardUserDefaults] valueForKey:@"FBAccessTokenKey"], [[NSUserDefaults standardUserDefaults] valueForKey:@"FBExpirationDateKey"]);
        
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
    
    if (DEBUGMODE)  NSLog(@"\nOriginal Token: %@\nExpiration Date: %@", [[NSUserDefaults standardUserDefaults] valueForKey:@"FBAccessTokenKey"], [[NSUserDefaults standardUserDefaults] valueForKey:@"FBExpirationDateKey"]);
    
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
    
    if (DEBUGMODE) NSLog(@"\nExtended Token: %@\nExpiration Date: %@", [[NSUserDefaults standardUserDefaults] valueForKey:@"FBAccessTokenKey"], [[NSUserDefaults standardUserDefaults] valueForKey:@"FBExpirationDateKey"]);
    
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
    [self checkForExistingTwitterAccounts];
}

- (void)twitterLogout
{
    
}

- (void)checkForExistingTwitterAccounts
{
    
    // Clear stored twitterAccount
    if ( [self.twitterAccount.username length] )  self.twitterAccount = nil;
    
    // Get all stored twitterAccounts
    self.twitterAccountStore = [[ACAccountStore alloc] init];
    ACAccountType *twitterType = [self.twitterAccountStore accountTypeWithAccountTypeIdentifier:ACAccountTypeIdentifierTwitter];
    [self.twitterAccountStore requestAccessToAccountsWithType:twitterType withCompletionHandler:^(BOOL granted, NSError *error) {
    
        if ( granted ) {
            
            NSArray *accounts = [NSArray arrayWithArray:[self.twitterAccountStore accountsWithAccountType:twitterType]];

            dispatch_async(dispatch_get_main_queue(), ^{
            
                switch ( [accounts count] ) {
                        
                    case 0: // No stored Twitter accounts
                        if (DEBUGMODE) NSLog(@"User has zero stored accounts");
                        [self getRequestToken];
                        break;
                        
                    case 1: // One stored Twitter account
                        if (DEBUGMODE) NSLog(@"User has one stored account");
                        self.twitterAccount = [accounts objectAtIndex:0];
                        [self userHasOneStoredTwitterAccount];
                        break;
                        
                    default: // Multiple stored Twitter accounts
                       if (DEBUGMODE) NSLog(@"User has multiple stored accounts");
                        [self userHasMultipleStoredTwitterAccounts];
                        break;
                        
                }            
        
            });
    
        }
    
    }];
    
}

- (void)userHasOneStoredTwitterAccount
{

    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:[NSString stringWithFormat:@"Sign in with @%@?", self.twitterAccount.username] 
                                                             delegate:self 
                                                    cancelButtonTitle:nil
                                               destructiveButtonTitle:@"Yes" 
                                                    otherButtonTitles:@"No", kTwitterNewAccount, nil];
    
    [actionSheet showInView:self.loginViewController.view];
    
}

- (void)userHasMultipleStoredTwitterAccounts
{
    self.twitterPickerView = [[UIPickerView alloc] initWithFrame:self.loginViewController.view.frame];
    self.twitterPickerView.delegate = self;
    self.twitterPickerView.dataSource = self;

    [self.loginViewController.view addSubview:self.twitterPickerView];
    
}

#pragma mark - Twitter/OAuth- RequestToken Methods
- (void)getRequestToken 
{
    
    // Remove reqeustToken value if value exists and/or user decides to re-authenticate
    self.requestToken = nil;
    
    NSURL *requestTokenURL = [NSURL URLWithString:@"https://api.twitter.com/oauth/request_token"];
    OAConsumer *consumer= [[OAConsumer alloc] initWithKey:SocialFacadeTwitterConsumerKey secret:SocialFacadeTwitterConsumerSecret];
    OAMutableURLRequest *request = [[OAMutableURLRequest alloc] initWithURL:requestTokenURL
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
    NSString* httpBodyData = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    self.requestToken = [[OAToken alloc] initWithHTTPResponseBody:httpBodyData];
    [self authenticateTwitterAccount];
}

- (void)requestTokenTicket:(OAServiceTicket *)ticket didFailWithError:(NSData *)data
{
    // Failed
    if (DEBUGMODE) NSLog(@"Request Token - Fetch Failure");
}

- (void)authenticateTwitterAccount
{
    
    NSURL *authorizeUrl = [NSURL URLWithString:@"https://api.twitter.com/oauth/authenticate"];
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

#pragma mark - Twitter/OAuth - AccessToken Methods
- (void)getAccessTokenWithPin:(NSString *)pin
{
    NSURL *accessTokenURL = [NSURL URLWithString:@"https://api.twitter.com/oauth/access_token"];
    OAMutableURLRequest * accessTokenRequest = [[OAMutableURLRequest alloc] initWithURL:accessTokenURL
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
                             didFailSelector:nil];
}

- (void)accessTokenTicket:(OAServiceTicket*)ticket didFinishWithData:(NSData*)data 
{
     NSString* httpBodyData = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
     OAToken *accessToken = [[OAToken alloc] initWithHTTPResponseBody:httpBodyData];
    [self saveTwitterAccountWithAccessToken:accessToken];
}

- (void)accessTokenTicket:(OAServiceTicket *)ticket didFailWithError:(NSData *)data
{
    // Failed
    if (DEBUGMODE) NSLog(@"Access Token - Fetch Failure");
}

- (void)saveTwitterAccountWithAccessToken:(OAToken *)accessToken
{
    
    NSString *token = accessToken.key;
    NSString *secret = accessToken.secret;
    
    // Store Twitter Account on device as ACAccount
    ACAccountType *twitterType = [self.twitterAccountStore accountTypeWithAccountTypeIdentifier:ACAccountTypeIdentifierTwitter];
    ACAccount *newAccount = [[ACAccount alloc] initWithAccountType:twitterType];
    ACAccountCredential *credential = [[ACAccountCredential alloc] initWithOAuthToken:token tokenSecret:secret];
    newAccount.credential = credential;
    
    [self.twitterAccountStore saveAccount:newAccount withCompletionHandler:^(BOOL success, NSError *error) {

        // This completionHandler block is NOT performed on the Main Thread
        if (success) {

            if (DEBUGMODE) NSLog(@"New Account Saved to Store: %@", newAccount.username);
            
            // Reverse Auth must be performed on Main Thread.
            dispatch_async(dispatch_get_main_queue(), ^{
                [self getReverseAuthRequestToken];
            });
    
        }
    }];

}

#pragma mark - OAuthConsumer - Reverse Auth Request Token Methods
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
                           didFinishSelector:@selector(reverseAuthRequestTokenTicket:didFinishWithData:)
                             didFailSelector:nil]; 
    
}

- (void)reverseAuthRequestTokenTicket:(OAServiceTicket *)ticket didFinishWithData:(NSData *)data 
{
    NSString *httpBodyData = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    [self getReverseAuthAccessToken:httpBodyData];
}

- (void)reverseAuthRequestTokenTicket:(OAServiceTicket *)ticket didFailWithError:(NSData *)data
{
    // Failed
    if (DEBUGMODE) NSLog(@"Reverse Auth Request Token - Fetch Failure");
}


#pragma mark - OAuthConsumer - Reverse Auth Access Token Methods
- (void)getReverseAuthAccessToken:(NSString *)reverseAuthRequestResults
{
    
    NSURL *accessTokenURL = [NSURL URLWithString:@"https://api.twitter.com/oauth/access_token"];
    NSDictionary *parameters = [NSDictionary dictionaryWithObjectsAndKeys:SocialFacadeTwitterConsumerKey, @"x_reverse_auth_target", reverseAuthRequestResults, @"x_reverse_auth_parameters", nil];
    TWRequest *reverseAuthAccessTokenRequest = [[TWRequest alloc] initWithURL:accessTokenURL parameters:parameters requestMethod:TWRequestMethodPOST];
    
    ACAccountType *twitterType = [self.twitterAccountStore accountTypeWithAccountTypeIdentifier:ACAccountTypeIdentifierTwitter];
    [self.twitterAccountStore requestAccessToAccountsWithType:twitterType withCompletionHandler:^(BOOL granted, NSError *error) {
        
        [reverseAuthAccessTokenRequest setAccount:self.twitterAccount];
        [reverseAuthAccessTokenRequest performRequestWithHandler:^(NSData *responseData, NSHTTPURLResponse *urlResponse, NSError *error) {
                    if ( responseData ) {
            
                        NSString *results = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
                        [self sendReverseAuthAccessResultsToServer:results];
                    
                    }
            
                }];
        
    }];
}

- (void)sendReverseAuthAccessResultsToServer:(NSString *)reverseAuthAccessResults
{
    // Send to Shelby for Token Swap
    if (DEBUGMODE) NSLog(@"Token swap with Shelby occurs here");
}

#pragma mark - AuthenticateTwitterDelegate Methods
- (void)authenticationRequestDidReturnPin:(NSString *)pin
{
    [self getAccessTokenWithPin:pin];
    
}

#pragma mark - UIActionSheetDelegate Method
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (buttonIndex) {
     
        case 0:     // User clicked 'Yes'
            
            [self getReverseAuthRequestToken];
            break;
        
        case 1:     // User clicked 'No'
            // Do Nothing
            break;
        
        case 2:     // User clicked 'New Account'
            
            [self getRequestToken];
            break;
        
        default:
            break;
    }
}

#pragma mark - UIPickerViewDataSource Methods
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    ACAccountType *twitterType = [self.twitterAccountStore accountTypeWithAccountTypeIdentifier:ACAccountTypeIdentifierTwitter];
    
    
    
    NSArray *accounts = [self.twitterAccountStore accountsWithAccountType:twitterType];
    
    self.twitterPickerViewChoices = [NSMutableArray arrayWithArray:accounts];
    [self.twitterPickerViewChoices addObject:kTwitterNewAccount];
    [self.twitterPickerViewChoices addObject:@"Cancel"];
    
    
    return [self.twitterPickerViewChoices count];
}

#pragma mark - UIPickerViewDelegate Method
-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    NSString *title;
    
    if ( row < [self.twitterPickerViewChoices count]-2 ) {
        
        ACAccount *twitterAccount = (ACAccount*)[self.twitterPickerViewChoices objectAtIndex:row];
        title = twitterAccount.username;
    
    } else {
    
        title = [self.twitterPickerViewChoices objectAtIndex:row];
   
    }
    
    if (DEBUGMODE) NSLog(@"TwitterPickerView Selection %@", title);
    
    return title;
}

-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    
    if ( row < [self.twitterPickerViewChoices count]-2 ) {             // User selected existing account
        
        [self.twitterPickerView removeFromSuperview];
        self.twitterAccount = (ACAccount*)[self.twitterPickerViewChoices objectAtIndex:row];
        [self getReverseAuthRequestToken];
        
    } else if ( row == [self.twitterPickerViewChoices count]-2 ) {     // User selected 'New Account'
        
        [self.twitterPickerView removeFromSuperview];
        
    } else {                                                    // User selected 'Cancel'
        
        [self.twitterPickerView removeFromSuperview];
        [self getRequestToken];
    }
    
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