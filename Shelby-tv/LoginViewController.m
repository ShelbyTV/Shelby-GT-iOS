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

// Constants
#import "StaticDeclarations.h"

@interface LoginViewController () <SocialFacadeDelegate>

@property (strong, nonatomic) SocialFacade *socialFacade;

- (void)initializationOnLoad;
- (void)animateOnLoad;
- (void)animationStageOne:(UIView*)object;
- (void)animationStageTwo:(UIView*)object;
- (void)animationStageThree:(UIView*)object;

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

#pragma mark - Memory Deallocation Method
- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:SocialFacadeAuthorizationStatus object:nil];
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
    self.view.backgroundColor = [UIColor colorWithRed:54.0f/255.0f green:54.0f/255.0f blue:54.0f/255.0f alpha:1.0f];
    
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
                         
                         [UIView animateWithDuration:0.75 animations:^{
                         
                             [self.blackBarImageView setAlpha:1.0f];
                             [self.sloganLabel setAlpha:1.0f];
                         
                         } completion:^(BOOL finished) {
                             
                             [self animationStageOne:self.facebookImageView];
                             
                         }];
                         
                     }];
}

- (void)animationStageOne:(UIView*)object
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
                         [self animationStageTwo:object];
                         
                         // Begin Twitter animation if object is facebookImageView
                         if ( object == self.facebookImageView ) [self animationStageOne:self.twitterImageView];
                         
                     }];
}

- (void)animationStageTwo:(UIView*)object
{
    
    [UIView animateWithDuration:0.4 
                     animations:^{

                         object.frame = CGRectMake(-15.0f + object.frame.origin.x, 
                                                   -15.0f + object.frame.origin.y, 
                                                   30.0f + object.frame.size.width, 
                                                   30.0f + object.frame.size.height);;
                     } completion:^(BOOL finished) {
                         
                         [self animationStageThree:object];
                                
                     }];

    
}

- (void)animationStageThree:(UIView*)object
{
    [UIView animateWithDuration:0.4 
                     animations:^{
                         
                         object.frame = CGRectMake(15.0f + object.frame.origin.x, 
                                                  15.0f + object.frame.origin.y, 
                                                  -30.0f + object.frame.size.width, 
                                                  -30.0f + object.frame.size.height);
                         
                     } completion:^(BOOL finished) {
                    
                         // Hide object
                         object.alpha = 0.0;
                         
                         // Replace imageView object with UIButton
                         if ( object == self.facebookImageView ) {
                             
                             [self.facebookButton setFrame:self.facebookImageView.frame];
                             [self.facebookButton setAlpha:1.0f];
                             
                         } else {
                             
                             [self.twitterButton setFrame:self.twitterImageView.frame];
                             [self.twitterButton setAlpha:1.0f];
                             
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
    
    if ( [self.socialFacade shelbyAuthorized] ) {
        
        [self dismissViewControllerAnimated:YES completion:nil];
        
    } else {
        
        
    }
    
}

#pragma mark - Interface Orientation Method
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
