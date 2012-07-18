//
//  ShelbyNavigationControllerViewController.m
//  Shelby.tv
//
//  Created by Arthur Ariel Sabintsev on 6/19/12.
//  Copyright (c) 2012 Shelby.tv. All rights reserved.
//

#import "ShelbyMenuViewController.h"
#import "ShelbyAPIClient.h"
#import "SocialFacade.h"

@interface ShelbyMenuViewController ()

@property (strong, nonatomic) NSDictionary *viewControllers;
@property (assign, nonatomic) NSUInteger currentType;

- (void)setupMenuButton;
- (void)removeCurrentlyPresentedSection;
- (void)adjustFrame:(UIView*)view;

@end

@implementation ShelbyMenuViewController
@synthesize mainView = _mainView;
@synthesize menuView = _menuView;
@synthesize exploreRollsButton = _exploreRollsButton;
@synthesize myRollsButton = _myRollsButton;
@synthesize friendsRollsButton = _friendsRollsButton;
@synthesize settingsButton = _settingsButton;
@synthesize streamButton = _streamButton;
@synthesize viewControllers = _viewControllers;
@synthesize currentType = _currentType;

#pragma mark - Deallocation Method
- (void)dealloc
{
    self.mainView = nil;
    self.menuView = nil;
    self.exploreRollsButton = nil;
    self.myRollsButton = nil;
    self.friendsRollsButton = nil;
    self.settingsButton = nil;
    self.streamButton = nil;
}

#pragma mark - Initialization Method
- (id)initWithViewControllers:(NSMutableDictionary*)dictionary
{
    
    if ( self = [super init] ) {
        
        self.view.backgroundColor = ColorConstants_BackgroundColor;
        
        // Reference sections (sent from App Delegate)
        self.viewControllers = [NSMutableDictionary dictionaryWithDictionary:dictionary];
        
        // Set currentType to nil
        self.currentType = GuideType_None;
        
        // Setup navigation buttons (actions and tags)
        [self setupMenuButton];
        
        // Section that is visible on application launch
        [self presentSection:GuideType_Stream];
        
    }
    
    return self;
}

#pragma mark - Public Methods
- (void)presentSection:(GuideType)type
{
    
    // Step 1: Remove current section's view
    [self removeCurrentlyPresentedSection];
    
    // Step 2: Set Navigation Logo
    UIImageView *logoView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"navigationLogo"]];
    
    // Step 3: Present new setion's view
    switch (type) {
            
        case GuideType_ExploreRolls:{
            
            UINavigationController *navigationController = (UINavigationController*)[self.viewControllers objectForKey:TextConstants_Section_ExploreRolls];
            [self adjustFrame:navigationController.view];
            [self.mainView addSubview:navigationController.view];
            [self.exploreRollsButton setSelected:YES];
            navigationController.visibleViewController.navigationItem.titleView = logoView;
            navigationController.view.tag = type;
            self.currentType = type;
            
        } break;
        
        case GuideType_MyRolls:{
    
            
            UINavigationController *navigationController= (UINavigationController*)[self.viewControllers objectForKey:TextConstants_Section_MyRolls];
            [self adjustFrame:navigationController.view];
            [self.mainView addSubview:navigationController.view];
            [self.myRollsButton setSelected:YES];
            navigationController.visibleViewController.navigationItem.titleView = logoView;
            navigationController.view.tag = type;
            self.currentType = type;
            
        } break;
        
        case GuideType_FriendsRolls:{
            
            UINavigationController *navigationController = (UINavigationController*)[self.viewControllers objectForKey:TextConstants_Section_FriendsRolls];
            [self adjustFrame:navigationController.view];
            [self.mainView addSubview:navigationController.view];
            [self.friendsRollsButton setSelected:YES];
            navigationController.visibleViewController.navigationItem.titleView = logoView;
            navigationController.view.tag = type;
            self.currentType = type;
            
        } break;
            
        case GuideType_Settings:{
            
            UINavigationController *navigationController = (UINavigationController*)[self.viewControllers objectForKey:TextConstants_Section_Settings];
            [self adjustFrame:navigationController.view];
            [self.mainView addSubview:navigationController.view];
            [self.settingsButton setSelected:YES];
            navigationController.visibleViewController.navigationItem.titleView = logoView;
            navigationController.view.tag = type;
            self.currentType = type;
            
        } break;
            
        case GuideType_Stream:{
            
            UINavigationController *navigationController = (UINavigationController*)[self.viewControllers objectForKey:TextConstants_Section_Stream];
            [self adjustFrame:navigationController.view];
            [self.mainView addSubview:navigationController.view];
            [self.streamButton setSelected:YES];
            navigationController.visibleViewController.navigationItem.titleView = logoView;
            navigationController.view.tag = type;
            self.currentType = type;
            
        } break;
            
        default:
            break;
    }
    

}

- (void)exploreRollsButtonAction
{
    [self presentSection:GuideType_ExploreRolls];
}
- (void)myRollsButtonAction
{
    [self presentSection:GuideType_MyRolls];
}

- (void)friendsRollsButtonAction
{
    [self presentSection:GuideType_FriendsRolls];
}

- (void)settingsButtonAction
{
    [self presentSection:GuideType_Settings];
}

- (void)streamButtonAction
{
    [self presentSection:GuideType_Stream];
}

#pragma mark - Private Methods
- (void)setupMenuButton
{

    // Add Target-Action to Buttons
    [self.exploreRollsButton addTarget:self action:@selector(exploreRollsButtonAction) forControlEvents:UIControlEventTouchUpInside];
    [self.myRollsButton addTarget:self action:@selector(myRollsButtonAction) forControlEvents:UIControlEventTouchUpInside];
    [self.friendsRollsButton addTarget:self action:@selector(friendsRollsButtonAction) forControlEvents:UIControlEventTouchUpInside];
    [self.settingsButton addTarget:self action:@selector(settingsButtonAction) forControlEvents:UIControlEventTouchUpInside];
    [self.streamButton addTarget:self action:@selector(streamButtonAction) forControlEvents:UIControlEventTouchUpInside];

    // Add Tags to Buttons
    self.exploreRollsButton.tag = GuideType_ExploreRolls;
    self.myRollsButton.tag = GuideType_MyRolls;
    self.friendsRollsButton.tag = GuideType_FriendsRolls;
    self.settingsButton.tag = GuideType_Settings;
    self.streamButton.tag = GuideType_Stream;
    
}

- (void)removeCurrentlyPresentedSection
{

    if ( self.currentType ) { // Condition satisfied when 'self.currentType' IS NOT equal to 'GuideType_None'
    
        for (UIView *currentView in [self.view subviews]) {
            
            if ( self.currentType == currentView.tag ) [currentView removeFromSuperview];
            
            for (UIButton *button in [self.menuView subviews]) {
                
                
                if ( button.tag == self.currentType && [button isMemberOfClass:[UIButton class]] ) {
                    
                    [button setSelected:NO];
                    [button setHighlighted:NO];

                }
                
            }

            self.currentType = GuideType_None;
            
        }
    
    }

}

- (void)adjustFrame:(UIView *)navigationView
{

    CGRect frame = navigationView.frame;
    if ( 0 == navigationView.frame.origin.y && 480 == navigationView.frame.size.height ) {
    navigationView.frame = CGRectMake(frame.origin.x,
                                      frame.origin.y,
                                      frame.size.width,
                                      -65.0f + frame.size.height);
        
    }
}

#pragma mark - Interface Orientation Method
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end