//
//  LoginViewController.m
//  Shelby-tv
//
//  Created by Arthur Ariel Sabintsev on 4/20/12.
//  Copyright (c) 2012 Shelby.tv. All rights reserved.
//

// LoginViewController
#import "LoginViewController.h"

// Models
#import "SocialFacade.h"
#import "ShelbyAPIClient.h"
#import "CoreDataUtility.h"
#import "AppDelegate.h"

// Controllers
#import "ShelbyMenuViewController.h"

// Constants
#import "StaticDeclarations.h"


@interface LoginViewController () <SocialFacadeDelegate>

@property (strong, nonatomic) SocialFacade *socialFacade;
@property (strong, nonatomic) AppDelegate *appDelegate;

- (void)initializationOnLoad;
- (void)didFinishLoadingDataOnLogin:(NSNotification*)notification;

@end

@implementation LoginViewController
@synthesize menuController = _menuController;
@synthesize topBarImageView = _topBarImageView;
@synthesize sloganLabel = _sloganLabel;
@synthesize facebookButton = _facebookButton;
@synthesize twitterButton = _twitterButton;
@synthesize socialFacade = _socialFacade;
@synthesize appDelegate = _appDelegate;

#pragma mark - Memory Deallocation Method
- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:SocialFacadeAuthorizationStatus object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:TextConstants_CoreData_DidFinishLoadingDataOnLogin object:nil];
}

#pragma mark - View Lifecycle Methods
- (void)viewDidUnload
{
    self.topBarImageView = nil;
    self.sloganLabel = nil;
    self.facebookButton = nil;
    self.twitterButton = nil;
    [super viewDidUnload];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Initialize Elements
    [self initializationOnLoad];
    
    // Check if user has authorized Facebook or Twitter with Shelby
    dispatch_async(dispatch_get_main_queue(), ^{
        [self authorizationStatus];
    });
    
}

#pragma mark - Private Methods
- (void)initializationOnLoad
{
    // Set Background
    self.view.backgroundColor = ColorConstants_BackgroundColor;
    
    // Reference AppDelegate
    self.appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    
    // Set font for sloganLavel
    [self.sloganLabel setFont:[UIFont fontWithName:@"Ubuntu" size:self.sloganLabel.font.pointSize]];
    [self.sloganLabel setTextColor:[UIColor colorWithRed:227.0f/255.0f green:227.0f/255.0f blue:227.0f/255.0f alpha:1.0]];
    
    // Reference Social Facade Singleton
    self.socialFacade = (SocialFacade*)[SocialFacade sharedInstance];
    
    // Create Observer for facebookAuthorizationStatus
    [[NSNotificationCenter defaultCenter] addObserver:self 
                                             selector:@selector(authorizationStatus) 
                                                 name:SocialFacadeAuthorizationStatus 
                                               object:nil];
    
}

- (void)didFinishLoadingDataOnLogin:(NSNotification*)notification
{
    
    [UIView animateWithDuration:1.0 animations:^{
        
        [self.topBarImageView setAlpha:0.0f];
        [self.sloganLabel setAlpha:0.0f];
        [self.facebookButton setAlpha:0.0f];
        [self.twitterButton setAlpha:0.0f];
        [self.view setAlpha:0.10f];
        
    } completion:^(BOOL finished) {
        
        if (finished)  {
        
            [self.appDelegate removeHUD];
            [self.menuController presentSection:GuideType_Stream];
            [self dismissViewControllerAnimated:NO completion:nil];
        
        }
    }];
    
}

#pragma mark - Action Methods
- (IBAction)facebookLogin:(id)sender
{
    [self.socialFacade facebookLogin];
}

- (IBAction)twitterLogin:(id)sender
{
    [self.socialFacade twitterLogin];
}

#pragma mark - SocialFacadeDelegate Methods
- (void)authorizationStatus
{
    
    if ( [self.socialFacade shelbyAuthorized] ) {       // If user is authorized with Shelby
     
        if ( [self.socialFacade firstTimeLogin] ) {     // If this is the first time the user has loggedin, show the animation
            
            
            [[NSNotificationCenter defaultCenter] addObserver:self 
                                                     selector:@selector(didFinishLoadingDataOnLogin:) 
                                                         name:TextConstants_CoreData_DidFinishLoadingDataOnLogin 
                                                       object:nil];

            
            // Perform Initial API Request
            NSString *stremRequestString = [NSString stringWithFormat:APIRequest_GetStream, [SocialFacade sharedInstance].shelbyToken];
            NSMutableURLRequest *streamRequest = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:stremRequestString]];
            ShelbyAPIClient *streamClient = [[ShelbyAPIClient alloc] init];
            [streamClient performRequest:streamRequest ofType:APIRequestType_GetStream];
            
            [self.appDelegate addHUDWithMessage:@"Getting Stream (Step 1 of 3)"];
            
        } else {                                        // If the user has logged in before, dismiss LoginViewController
            
            [self dismissViewControllerAnimated:NO completion:nil];
            
        }
               
    } 
    
}

#pragma mark - Interface Orientation Method
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
