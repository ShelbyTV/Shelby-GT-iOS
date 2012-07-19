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

#pragma mark - Interface Orientation Methods
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end