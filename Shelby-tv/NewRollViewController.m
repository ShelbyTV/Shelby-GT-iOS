//
//  NewRollViewController.m
//  Shelby.tv
//
//  Created by Arthur Ariel Sabintsev on 7/17/12.
//  Copyright (c) 2012 Shelby.tv. All rights reserved.
//

#import "NewRollViewController.h"
#import "AsynchronousFreeloader.h"

@interface NewRollViewController ()

@property (strong, nonatomic) Frame *frame;

- (void)addCustomBackButton;
- (void)customizeView;
- (void)populateView;

@end

@implementation NewRollViewController
@synthesize thumbnailImageView = _thumbnailImageView;
@synthesize nicknameLabel = _nicknameLabel;
@synthesize videoNameLabel = _videoNameLabel;
@synthesize createNewRollLabel = _createNewRollLabel;
@synthesize rollNameLabel = _rollNameLabel;
@synthesize titleTextField = _titleTextField;
@synthesize privacySwitch = _privacySwitch;
@synthesize shareButton = _shareButton;
@synthesize rollButton = _rollButton;
@synthesize frame = _frame;

#pragma mark - Initialization Method
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil andFrame:(Frame *)frame
{
    if ( self == [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil] ) {
        
        self.frame = frame;
        
    }
    
    return self;
}

#pragma mark - View Lifecycle Methods
- (void)viewDidUnload
{
    self.thumbnailImageView = nil;
    self.nicknameLabel = nil;
    self.videoNameLabel = nil;
    self.createNewRollLabel = nil;
    self.rollNameLabel = nil;
    self.titleTextField = nil;
    self.shareButton = nil;
    self.rollButton = nil;
    [super viewDidUnload];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self customizeView];
    [self populateView];
}

#pragma mark - Private Methods
- (void)customizeView
{
    
    // Add Custom Back Button
    [self addCustomBackButton];
    
    // Customize view and tableView background and appearance
    self.view.backgroundColor = ColorConstants_BackgroundColor;
    
    // Change title to Share
    [self.navigationItem setTitle:@"Roll"];
    
    // Customize UILabels (all of which are IBOutlets)
    [self.nicknameLabel setFont:[UIFont fontWithName:@"Ubuntu-Bold" size:self.nicknameLabel.font.pointSize]];
    [self.nicknameLabel setTextColor:ColorConstants_GrayTextColor];
    
    [self.videoNameLabel setFont:[UIFont fontWithName:@"Ubuntu-Bold" size:self.videoNameLabel.font.pointSize]];
    [self.videoNameLabel setTextColor:[UIColor whiteColor]];
    
    [self.createNewRollLabel setFont:[UIFont fontWithName:@"Ubuntu-Bold" size:self.createNewRollLabel.font.pointSize]];
    [self.createNewRollLabel setTextColor:[UIColor whiteColor]];
    
    [self.rollNameLabel setFont:[UIFont fontWithName:@"Ubuntu-Bold" size:self.rollNameLabel.font.pointSize]];
    [self.rollNameLabel setTextColor:[UIColor whiteColor]];
    
    [self.shareButton setTitle:@"Share with Contacts" forState:UIControlStateNormal];
    [self.shareButton setTitle:@"Share with Contacts" forState:UIControlStateSelected];
    [self.shareButton setTitle:@"Share with Contacts" forState:UIControlStateHighlighted];
    [self.shareButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.shareButton setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
    [self.shareButton.titleLabel setFont:[UIFont fontWithName:@"Ubuntu-Bold" size:17.0f]];
    
    [self.rollButton setTitle:@"Roll It" forState:UIControlStateNormal];
    [self.rollButton setTitle:@"Roll It" forState:UIControlStateSelected];
    [self.rollButton setTitle:@"Roll It" forState:UIControlStateHighlighted];
    [self.rollButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.rollButton setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
    [self.rollButton.titleLabel setFont:[UIFont fontWithName:@"Ubuntu-Bold" size:17.0f]];
    
}

- (void)populateView
{
    // Thumbnail
    [AsynchronousFreeloader loadImageFromLink:self.frame.video.thumbnailURL forImageView:self.thumbnailImageView withPlaceholderView:nil];
    
    // Labels
    self.nicknameLabel.text = self.frame.creator.nickname;
    self.videoNameLabel.text = self.frame.video.title;
    
}

- (void)addCustomBackButton
{
    UIButton *backBarButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 51, 30)];
    [backBarButton setImage:[UIImage imageNamed:@"backButton"] forState:UIControlStateNormal];
    [backBarButton addTarget:self.navigationController action:@selector(popViewControllerAnimated:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *backBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backBarButton];
    [self.navigationItem setHidesBackButton:YES];
    [self.navigationItem setLeftBarButtonItem:backBarButtonItem];
}

#pragma mark - UIResponder Methods
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    if ( [self.titleTextField isFirstResponder] ) [self.titleTextField resignFirstResponder];
}

#pragma mark - Interface Orientation Methods
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end