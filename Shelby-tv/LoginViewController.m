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
#import "Constants.h"

@interface LoginViewController () <SocialFacadeDelegate>

@property (weak, nonatomic) SocialFacade *socialFacade;

- (void)initializationOnLoad;

@end

@implementation LoginViewController
@synthesize socialFacade = _socialFacade;

#pragma mark - Memory Deallocation Method
- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - View Lifecycle Methods
- (void)viewDidUnload
{
    [super viewDidUnload];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Initialization
    [self initializationOnLoad];

}

#pragma mark - Private Methods
- (void)initializationOnLoad
{
    // Reference Social Facade Singleton
    self.socialFacade = (SocialFacade*)[SocialFacade sharedInstance];
    
    // Create Observer for facebookAuthorizationStatus
    [[NSNotificationCenter defaultCenter] addObserver:self 
                                             selector:@selector(facebookAuthorizationStatus) 
                                                 name:SocialFacadeFacebookAuthorizationStatus 
                                               object:nil];
    
}

#pragma mark - Action Methods
- (IBAction)facebookLogin:(id)sender
{
    [self.socialFacade facebookLogin];
}

- (IBAction)twitterLogin:(id)sender
{
    [self dismissModalViewControllerAnimated:YES];
}

#pragma mark - SocialFacadeDelegate Methods
-(void)facebookAuthorizationStatus
{
    if (self.socialFacade.facebookAuthorized) {
        
        [self dismissModalViewControllerAnimated:YES];
        
    } else {
        
        
    }
}

#pragma mark - Interface Orientation Method
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
