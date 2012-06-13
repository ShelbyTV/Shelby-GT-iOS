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

// Constants
#import "StaticDeclarations.h"

@interface LoginViewController () <SocialFacadeDelegate>

@property (strong, nonatomic) SocialFacade *socialFacade;
@property (strong, nonatomic) UIActivityIndicatorView *activityIndicator;

- (void)initializationOnLoad;
- (void)animateOnLoad;
- (void)loginAnimationStageOne:(UIView*)object;
- (void)loginAnimationStageTwo:(UIView*)object;
- (void)loginAnimationStageThree:(UIView*)object;
- (void)logoutAnimationStageOne:(UIView*)object;
- (void)logoutAnimationStageTwo:(UIView*)object;
- (void)didFinishLoadingDataOnLogin:(NSNotification*)notification;

@end

@implementation LoginViewController
@synthesize logoImageView = _logoImageView;
@synthesize sloganLabel = _sloganLabel;
@synthesize blackBarImageView = _blackBarImageView;
@synthesize facebookImageView = _facebookImageView;
@synthesize twitterImageView = _twitterImageView;
@synthesize facebookButton = _facebookButton;
@synthesize twitterButton = _twitterButton;
@synthesize socialFacade = _socialFacade;
@synthesize activityIndicator = _activityIndicator;

#pragma mark - Memory Deallocation Method
- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:SocialFacadeAuthorizationStatus object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:TextConstants_DidFinishLoadingDataOnLogin object:nil];
    self.logoImageView = nil;
    self.blackBarImageView = nil;
    self.sloganLabel = nil;
    self.facebookImageView = nil;
    self.twitterImageView = nil;
    self.facebookButton = nil;
    self.twitterButton = nil;
}

#pragma mark - View Lifecycle Methods
- (void)viewDidUnload
{
    self.sloganLabel = nil;
    [super viewDidUnload];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Initialize Elements
    [self initializationOnLoad];
    
    // Animate Elements
    [self animateOnLoad];
    
    // Check if user has authorized Facebook or Twitter with Shelby
    dispatch_async(dispatch_get_main_queue(), ^{
        [self authorizationStatus];
    });
    
}

#pragma mark - Private Methods
- (void)initializationOnLoad
{
    // Set Background
    self.view.backgroundColor = kColorConstantBackgroundColor;
    
    // Set font for sloganLavel
    [self.sloganLabel setFont:[UIFont fontWithName:@"Ubuntu" size:10]];
    [self.sloganLabel setTextColor:[UIColor colorWithRed:227.0f/255.0f green:227.0f/255.0f blue:227.0f/255.0f alpha:1.0]];
    
    // Reference Social Facade Singleton
    self.socialFacade = (SocialFacade*)[SocialFacade sharedInstance];
    
    // Create Observer for facebookAuthorizationStatus
    [[NSNotificationCenter defaultCenter] addObserver:self 
                                             selector:@selector(authorizationStatus) 
                                                 name:SocialFacadeAuthorizationStatus 
                                               object:nil];
    
}

- (void)animateOnLoad
{
    [UIView animateWithDuration:1.0 
                          delay:0.0 
                        options:UIViewAnimationCurveEaseIn 
                     animations:^{
                     
                         self.logoImageView.frame = CGRectMake(51.0f, 120.0f, 217.0f, 55.0f);
                     
                     } completion:^(BOOL finished) {

                         if ( finished ) {
                         
                             [UIView animateWithDuration:0.75 animations:^{
                             
                                 [self.blackBarImageView setAlpha:1.0f];
                                 [self.sloganLabel setAlpha:1.0f];
                             
                             } completion:^(BOOL finished) {
                                 
                                 if ( finished ) [self loginAnimationStageOne:self.facebookImageView];
                                 
                             }];
                         }
                         
                     }];
}

- (void)loginAnimationStageOne:(UIView*)object
{
    CGRect oldFrame = object.frame;
    object.frame = CGRectMake(-25.0f + oldFrame.origin.x, 
                              -25.0f + oldFrame.origin.y, 
                              50.0f + oldFrame.size.width,
                              50.0f + oldFrame.size.height);
    
    [UIView animateWithDuration:0.5 
                     animations:^{
                         
                         object.frame = oldFrame;
                         object.alpha = 1.0f;
                         
                     } completion:^(BOOL finished) {
                         
                         if ( finished ) {
                         
                             [self loginAnimationStageTwo:object];
                             
                             /*
                              Begin Twitter animation if object is facebookImageView
                              Begin second animation (twitter), if first animaiton (facebook) is currently being animated
                              */
                              if ( object == self.facebookImageView ) [self loginAnimationStageOne:self.twitterImageView];

                         }
                     }];
}

- (void)loginAnimationStageTwo:(UIView*)object
{
    
    [UIView animateWithDuration:0.4 
                     animations:^{

                         object.frame = CGRectMake(-5.0f + object.frame.origin.x, 
                                                   -2.0f + object.frame.origin.y, 
                                                   4.0f + object.frame.size.width, 
                                                   4.0f + object.frame.size.height);;
                     } completion:^(BOOL finished) {
                         
                         if ( finished ) [self loginAnimationStageThree:object];
                                
                     }];

    
}

- (void)loginAnimationStageThree:(UIView*)object
{
    [UIView animateWithDuration:0.4 
                     animations:^{
                         
                         object.frame = CGRectMake(2.0f + object.frame.origin.x, 
                                                   2.0f + object.frame.origin.y, 
                                                  -4.0f + object.frame.size.width, 
                                                  -4.0f + object.frame.size.height);
                         
                     } completion:^(BOOL finished) {
                    
                         
                         if ( finished ) {
                        
                             // Replace imageView object with UIButton
                             if ( object == self.facebookImageView ) {
                                  
                                 [self.facebookButton setFrame:object.frame];
                                 [self.facebookButton setAlpha:1.0f];
                                 
                             } else {
                                 
                                 [self.twitterButton setFrame:object.frame];
                                 [self.twitterButton setAlpha:1.0f];
                                 
                             } 
                              
                            // Hide object
                            object.alpha = 0.0;
                         }
                              
                     }];
}
  


- (void)logoutAnimationStageOne:(UIView *)object
{
    
    if ( object == self.facebookButton ) { 
        
        [self.facebookImageView setAlpha:1.0f];
        [self.facebookButton setAlpha:0.0f];
    
    } else {
    
        [self.twitterImageView setAlpha:1.0f]; 
        [self.twitterButton setAlpha:0.0f];
   
    }
    
    [UIView animateWithDuration:0.4 
                     animations:^{
                         
                         if ( object == self.facebookButton ) {
                             
                             [self.facebookImageView setAlpha:0.0f];
                             [self.facebookImageView setFrame:CGRectMake(100.0f + self.facebookImageView.frame.origin.x, 
                                                                         25.0f + self.facebookImageView.frame.origin.y, 
                                                                         -200.0f + self.facebookImageView.frame.size.width,
                                                                         -50.0f + self.facebookImageView.frame.size.height)];
                             
                         } else {
                            
                             [self.twitterImageView setAlpha:0.0f];
                             [self.twitterImageView setFrame:CGRectMake(100.0f + self.twitterImageView.frame.origin.x, 
                                                                        25.0f + self.twitterImageView.frame.origin.y, 
                                                                        -200.0f + self.twitterImageView.frame.size.width,
                                                                        -50.0f + self.twitterImageView.frame.size.height)];
                             
                         }
                         
                     } 
                     
                     completion:^(BOOL finished) {
                         
                         if ( finished ) {
                             
                             [self logoutAnimationStageTwo:object];
                             
                         }
                     
                     }];
}

- (void)logoutAnimationStageTwo:(UIView *)object
{
    
    if ( object == self.twitterButton ) {
        
        [self logoutAnimationStageOne:self.facebookButton];
        
    } else {
        
        [UIView animateWithDuration:0.5 
                         animations:^{
                             
                             self.blackBarImageView.frame = CGRectMake(self.blackBarImageView.frame.origin.x, 
                                                                       53.0f + self.blackBarImageView.frame.origin.y, 
                                                                       self.blackBarImageView.frame.size.width, 
                                                                       self.blackBarImageView.frame.size.height);
                             self.sloganLabel.frame = CGRectMake(self.sloganLabel.frame.origin.x, 
                                                                 53.0f + self.sloganLabel.frame.origin.y, 
                                                                 self.sloganLabel.frame.size.width, 
                                                                 self.sloganLabel.frame.size.height);
                             
                             self.logoImageView.frame = CGRectMake(self.logoImageView.frame.origin.x, 
                                                                   53.0f + self.logoImageView.frame.origin.y, 
                                                                   self.logoImageView.frame.size.width, 
                                                                   self.logoImageView.frame.size.height);
                             
                             
                         } completion:^(BOOL finished) {
                             
                             self.activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
                             [self.activityIndicator setFrame:self.view.frame];
                             [self.activityIndicator setCenter:CGPointMake(self.view.frame.size.width/2.0f, 
                                                              50.0f + self.blackBarImageView.frame.size.height + self.blackBarImageView.frame.origin.y)];
                             [self.view addSubview:self.activityIndicator];
                             [self.activityIndicator startAnimating];
                             [self.activityIndicator setAlpha:0.0f];
                             
                             [UIView animateWithDuration:0.5f animations:^{
                                 [self.activityIndicator setAlpha:1.0f];
                             }];
                             
                         }];
    }
}

- (void)didFinishLoadingDataOnLogin:(NSNotification*)notification
{
    
    [UIView animateWithDuration:1.0 animations:^{
        
        [self.logoImageView setAlpha:0.0f];
        [self.blackBarImageView setAlpha:0.0f];
        [self.sloganLabel setAlpha:0.0f];
        [self.activityIndicator setAlpha:0.0f];
        [self.activityIndicator stopAnimating];
        [self.view setAlpha:0.25f];
        
    } completion:^(BOOL finished) {
        
        if (finished)  [self dismissViewControllerAnimated:NO completion:nil];
   
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
                                                         name:TextConstants_DidFinishLoadingDataOnLogin 
                                                       object:nil];
            
            if ( self.activityIndicator.superview ) [self.activityIndicator removeFromSuperview];
            
            
            // Peeform Initial API Request
            NSString *requestString = [NSString stringWithFormat:kAPIRequestGetStream, [SocialFacade sharedInstance].shelbyToken];
            NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:requestString]];
            
            ShelbyAPIClient *client = [[ShelbyAPIClient alloc] init];
            [client performRequest:request ofType:APIRequestTypeGetStream];
            
            [self logoutAnimationStageOne:self.twitterButton];
            
            
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
