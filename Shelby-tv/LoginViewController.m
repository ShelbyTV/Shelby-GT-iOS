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

@end

@implementation LoginViewController
@synthesize sloganLabel = _sloganLabel;
@synthesize socialFacade = _socialFacade;


#pragma mark - Memory Deallocation Method
- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
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
    
    // Initialization
    [self initializationOnLoad];

}

#pragma mark - Private Methods
- (void)initializationOnLoad
{
    // Set Background
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"loginBackground"]];
    
    // Set font for sloganLavel
    [self.sloganLabel setFont:[UIFont fontWithName:@"Ubuntu" size:10]];
    [self.sloganLabel setTextColor:[UIColor colorWithRed:227.0f/255.0f green:227.0f/255.0f blue:227.0f/255.0f alpha:1.0]];
    
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
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - SocialFacadeDelegate Methods
-(void)facebookAuthorizationStatus
{
    if ( [self.socialFacade facebookAuthorized] ) {
        
        [self dismissViewControllerAnimated:YES completion:nil];
        
    } else {
        
        
    }
}

- (void)twitterAuthorizationStatus
{
    
    if ( [self.socialFacade twitterAuthorized] ) {
        
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
