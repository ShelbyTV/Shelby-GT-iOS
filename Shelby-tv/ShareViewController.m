//
//  ShareViewController.m
//  Shelby-tv
//
//  Created by Arthur Ariel Sabintsev on 7/9/12.
//  Copyright (c) 2012 Shelby.tv. All rights reserved.
//

#import "ShareViewController.h"
#import "SocialFacade.h"
#import "ShelbyAPIClient.h"
#import "AsynchronousFreeloader.h"
#import "NSString+TypedefConversion.h"

@interface ShareViewController () <UITextViewDelegate>

@property (strong, nonatomic) Frame *frame;

- (void)addCustomBackButton;
- (void)createAPIObservers;
- (void)customizeView;
- (void)populateView;

@end

@implementation ShareViewController
@synthesize imageView = _imageView;
@synthesize nicknameLabel = _nicknameLabel;
@synthesize videoNameLabel = _videoNameLabel;
@synthesize commentLabel = _commentLabel;
@synthesize shareToLabel = _shareToLabel;
@synthesize commentTextView = _commentTextView;
@synthesize twitterButton = _twitterButton;
@synthesize facebookButton = _facebookButton;
@synthesize shareButton = _shareButton;
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
    [super viewDidUnload];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = ColorConstants_BackgroundColor;
    
    [self customizeView];
    [self populateView];
}

#pragma mark - Private Methods
- (void)customizeView
{
    
    [self addCustomBackButton];
    [self.navigationItem setTitle:@"Share"];
    
    [self.nicknameLabel setFont:[UIFont fontWithName:@"Ubuntu-Bold" size:self.nicknameLabel.font.pointSize]];
    [self.nicknameLabel setTextColor:[UIColor whiteColor]];
    
    [self.videoNameLabel setFont:[UIFont fontWithName:@"Ubuntu-Bold" size:self.videoNameLabel.font.pointSize]];
    [self.videoNameLabel setTextColor:[UIColor whiteColor]];
    
    [self.commentLabel setFont:[UIFont fontWithName:@"Ubuntu-Bold" size:self.videoNameLabel.font.pointSize]];
    [self.commentLabel setTextColor:[UIColor whiteColor]];

    [self.shareToLabel setFont:[UIFont fontWithName:@"Ubuntu-Bold" size:self.shareToLabel.font.pointSize]];
    [self.shareToLabel setTextColor:[UIColor whiteColor]];
    
}

- (void)populateView
{
    // Thumbnail
    [AsynchronousFreeloader loadImageFromLink:self.frame.video.thumbnailURL forImageView:self.imageView withPlaceholderView:nil];

    // Labels
    self.nicknameLabel.text = self.frame.creator.nickname;
    self.videoNameLabel.text = self.frame.video.title;
    
}

- (void)addCustomBackButton
{
    UIButton *backBarButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 51, 30)];
    [backBarButton setImage:[UIImage imageNamed:@"navigationButtonBack"] forState:UIControlStateNormal];
    [backBarButton addTarget:self.navigationController action:@selector(popViewControllerAnimated:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *backBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backBarButton];
    [self.navigationItem setHidesBackButton:YES];
    [self.navigationItem setLeftBarButtonItem:backBarButtonItem];
}

- (void)createAPIObservers
{
    
    NSString *notificationName = [NSString requestTypeToString:APIRequestType_PostShareFrame];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(dataReturnedFromAPI:)
                                                 name:notificationName
                                               object:nil];
}

#pragma mark - Action Methods
- (IBAction)twitterButtonAction:(id)sender
{
    ( [self.twitterButton isSelected] ) ? [self.twitterButton setSelected:NO] : [self.twitterButton setSelected:YES];
}

- (IBAction)facebookButtonAction:(id)sender
{
    ( [self.facebookButton isSelected] ) ? [self.facebookButton setSelected:NO] : [self.facebookButton setSelected:YES];
}

- (IBAction)shareButtonAction:(id)sender
{
    
    // Add Observer
    [self createAPIObservers];
    
    // Create request string and add frameID and shelbyToken
    NSString *requestString = [NSString stringWithFormat:APIRequest_ShareFrame, self.frame.frameID, [SocialFacade sharedInstance].shelbyToken];
    
    NSString *commentsString = [[NSURL URLWithString:self.commentTextView.text] absoluteString];
    requestString = [NSString stringWithFormat:@"%@&text=%@", requestString, commentsString];
    
    // Build string
    if ( [self.facebookButton isSelected] ) requestString = [NSString stringWithFormat:@"%@&destination[]=facebook", requestString];
    if ( [self.twitterButton isSelected] ) requestString = [NSString stringWithFormat:@"%@&destination[]=twitter", requestString];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:requestString]];
    ShelbyAPIClient *client = [[ShelbyAPIClient alloc] init];
    [client performRequest:request ofType:APIRequestType_GetStream];
    
    // Add shared successfully
}

#pragma mark - UIResponder Methods
-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if( [text isEqualToString:@"\n"] ) [textView resignFirstResponder];
    
    return YES;
}

#pragma mark - Interface Orientation Method
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
