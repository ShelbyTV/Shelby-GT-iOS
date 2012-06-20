//
//  ShelbyNavigationControllerViewController.m
//  Shelby-tv
//
//  Created by Arthur Ariel Sabintsev on 6/19/12.
//  Copyright (c) 2012 Shelby.tv. All rights reserved.
//

#import "ShelbyMenuController.h"

@interface ShelbyMenuController ()

@property (strong, nonatomic) NSDictionary *viewControllers;
@property (assign, nonatomic) NSUInteger currentType;

- (void)presentSection:(GuideType)type;
- (void)removeCurrentlyPresentedSection;
- (void)adjustFrame:(UIView*)view;

@end

@implementation ShelbyMenuController
@synthesize viewControllers = _viewControllers;
@synthesize currentType = _currentType;

#pragma mark - Initialization Method
- (id)initWithViewControllers:(NSMutableDictionary*)dictionary
{
    
    if ( self = [super init] ) {
        
        // Reference sections (sent from App Delegate)
        self.viewControllers = [NSMutableDictionary dictionaryWithDictionary:dictionary];
  
        // Set currentType to nil
        self.currentType = GuideType_None;
        
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
    
    // Step 2: Present new setion's view
    switch (type) {
            
        case GuideType_BrowseRolls:{
            
            UINavigationController *navigationController = (UINavigationController*)[self.viewControllers objectForKey:TextConstants_BrowseRollsSection];
            [self adjustFrame:navigationController.view];
            [self.view addSubview:navigationController.view];
            navigationController.view.tag = type;
            self.currentType = type;
            
        } break;
        
        case GuideType_MyRolls:{
            
            UINavigationController *navigationController= (UINavigationController*)[self.viewControllers objectForKey:TextConstants_MyRollsSection];
            [self adjustFrame:navigationController.view];
            [self.view addSubview:navigationController.view];
            navigationController.view.tag = type;
            self.currentType = type;
            
        } break;
        
        case GuideType_PeopleRolls:{
            
            UINavigationController *navigationController = (UINavigationController*)[self.viewControllers objectForKey:TextConstants_PeopleRollsSection];
            [self adjustFrame:navigationController.view];
            [self.view addSubview:navigationController.view];
            navigationController.view.tag = type;
            self.currentType = type;
            
        } break;
            
        case GuideType_Settings:{
            
            UINavigationController *navigationController = (UINavigationController*)[self.viewControllers objectForKey:TextConstants_SettingsSection];
            [self adjustFrame:navigationController.view];
            [self.view addSubview:navigationController.view];
            navigationController.view.tag = type;
            self.currentType = type;
            
        } break;
            
        case GuideType_Stream:{
            
            UINavigationController *navigationController = (UINavigationController*)[self.viewControllers objectForKey:TextConstants_StreamSection];
            [self adjustFrame:navigationController.view];
            [self.view addSubview:navigationController.view];
            navigationController.view.tag = type;
            self.currentType = type;
            
        } break;
            
        default:
            break;
    }
}

- (IBAction)browseRollsButton:(id)sender
{
    [self presentSection:GuideType_BrowseRolls];
}
- (IBAction)myRollsButton:(id)sender
{
    [self presentSection:GuideType_MyRolls];
}

- (IBAction)peopleRollsButton:(id)sender
{
    [self presentSection:GuideType_PeopleRolls];
}

- (IBAction)settingsButton:(id)sender
{
    [self presentSection:GuideType_Settings];
}

- (IBAction)streamButton:(id)sender
{
    [self presentSection:GuideType_Stream];
}

#pragma mark - Private Methods
- (void)removeCurrentlyPresentedSection
{

    if ( self.currentType ) { // Condition satisfied when 'self.currentType' IS NOT equal to 'GuideType_None'
    
        for (UIView *currentView in [self.view subviews]) {
            
            if ( self.currentType == currentView.tag ) [currentView removeFromSuperview];
            self.currentType = GuideType_None;
            
        }
    
    }

}

- (void)adjustFrame:(UIView *)navigationView
{
    CGRect frame = navigationView.frame;
    if ( 0 == navigationView.frame.origin.y ) {
    navigationView.frame = CGRectMake(frame.origin.x,
                                      -20+frame.origin.y,
                                      frame.size.width,
                                      frame.size.height);
    }
}

#pragma mark - Interface Orientation Method
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end