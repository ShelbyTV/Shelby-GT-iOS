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

- (void)createMenuView;
- (void)removeCurrentlyPresentedSection;
- (void)adjustFrame:(UIView*)view;

@end

@implementation ShelbyMenuController
@synthesize menuView = _menuView;
@synthesize viewControllers = _viewControllers;
@synthesize currentType = _currentType;

#pragma mark - Initialization Method
- (id)initWithViewControllers:(NSMutableDictionary*)dictionary
{
    
    if ( self = [super init] ) {
        
        self.view.backgroundColor = ColorConstants_BackgroundColor;
        
        // Reference sections (sent from App Delegate)
        self.viewControllers = [NSMutableDictionary dictionaryWithDictionary:dictionary];
        
        // Set currentType to nil
        self.currentType = GuideType_None;
        
        // Create ShelbyMenuView and connect actions to menu buttons
        [self createMenuView];
        
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
            
            UINavigationController *navigationController = (UINavigationController*)[self.viewControllers objectForKey:TextConstants_Section_BrowseRolls];
            [self adjustFrame:navigationController.view];
            [self.view addSubview:navigationController.view];
            [self.menuView.browseRollsButton setHighlighted:YES];
            navigationController.view.tag = type;
            self.currentType = type;
            
        } break;
        
        case GuideType_MyRolls:{
            
            UINavigationController *navigationController= (UINavigationController*)[self.viewControllers objectForKey:TextConstants_Section_MyRolls];
            [self adjustFrame:navigationController.view];
            [self.view addSubview:navigationController.view];
            [self.menuView.myRollsButton setHighlighted:YES];
            navigationController.view.tag = type;
            self.currentType = type;
            
        } break;
        
        case GuideType_PeopleRolls:{
            
            UINavigationController *navigationController = (UINavigationController*)[self.viewControllers objectForKey:TextConstants_Section_PeopleRolls];
            [self adjustFrame:navigationController.view];
            [self.view addSubview:navigationController.view];
            [self.menuView.peopleRollsButton setHighlighted:YES];
            navigationController.view.tag = type;
            self.currentType = type;
            
        } break;
            
        case GuideType_Settings:{
            
            UINavigationController *navigationController = (UINavigationController*)[self.viewControllers objectForKey:TextConstants_Section_Settings];
            [self adjustFrame:navigationController.view];
            [self.view addSubview:navigationController.view];
            [self.menuView.settingsButton setHighlighted:YES];
            navigationController.view.tag = type;
            self.currentType = type;
            
        } break;
            
        case GuideType_Stream:{
            
            UINavigationController *navigationController = (UINavigationController*)[self.viewControllers objectForKey:TextConstants_Section_Stream];
            [self adjustFrame:navigationController.view];
            [self.view addSubview:navigationController.view];
            [self.menuView.streamButton setHighlighted:YES];
            navigationController.view.tag = type;
            self.currentType = type;
            
        } break;
            
        default:
            break;
    }
}

- (void)browseRollsButton
{
    [self presentSection:GuideType_BrowseRolls];
}
- (void)myRollsButton
{
    [self presentSection:GuideType_MyRolls];
}

- (void)peopleRollsButton
{
    [self presentSection:GuideType_PeopleRolls];
}

- (void)settingsButton
{
    [self presentSection:GuideType_Settings];
}

- (void)streamButton
{
    [self presentSection:GuideType_Stream];
}

#pragma mark - Private Methods
- (void)createMenuView
{
    // Grab reference to menuView nib
    NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"ShelbyMenuView" owner:self options:nil];
    self.menuView = (ShelbyMenuView*)[nib objectAtIndex:0];
    
    // Add Target-Action to Buttons
    [self.menuView.browseRollsButton addTarget:self action:@selector(browseRollsButton) forControlEvents:UIControlEventTouchUpInside];
    [self.menuView.myRollsButton addTarget:self action:@selector(myRollsButton) forControlEvents:UIControlEventTouchUpInside];
    [self.menuView.peopleRollsButton addTarget:self action:@selector(peopleRollsButton) forControlEvents:UIControlEventTouchUpInside];
    [self.menuView.settingsButton addTarget:self action:@selector(settingsButton) forControlEvents:UIControlEventTouchUpInside];
    [self.menuView.streamButton addTarget:self action:@selector(streamButton) forControlEvents:UIControlEventTouchUpInside];

    // Add Tags to Buttons
    self.menuView.browseRollsButton.tag = GuideType_BrowseRolls;
    self.menuView.myRollsButton.tag = GuideType_MyRolls;
    self.menuView.peopleRollsButton.tag = GuideType_PeopleRolls;
    self.menuView.settingsButton.tag = GuideType_Settings;
    self.menuView.streamButton.tag = GuideType_Stream;
    
}

- (void)removeCurrentlyPresentedSection
{

    if ( self.currentType ) { // Condition satisfied when 'self.currentType' IS NOT equal to 'GuideType_None'
    
        for (UIView *currentView in [self.view subviews]) {
            
            if ( self.currentType == currentView.tag ) [currentView removeFromSuperview];
            
            for (UIButton *button in [self.menuView subviews]) {
                
                if ( button.tag == self.currentType ) [button setHighlighted:NO];
                
            }
            
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