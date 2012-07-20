//
//  ShareViewController.m
//  Shelby.tv
//
//  Created by Arthur Ariel Sabintsev on 7/9/12.
//  Copyright (c) 2012 Shelby.tv. All rights reserved.
//

#import "ShareViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "SocialFacade.h"
#import "ShelbyAPIClient.h"
#import "AsynchronousFreeloader.h"
#import "NSString+TypedefConversion.h"
#import "AppDelegate.h"

@interface ShareViewController () <UITextViewDelegate>

@property (strong, nonatomic) Frame *frame;

- (void)addCustomBackButton;
- (void)customizeView;
- (void)populateView;

@end

@implementation ShareViewController
@synthesize thumbnailImageView = _thumbnailImageView;
@synthesize nicknameLabel = _nicknameLabel;
@synthesize videoNameLabel = _videoNameLabel;
@synthesize commentLabel = _commentLabel;
@synthesize shareToLabel = _shareToLabel;
@synthesize textView = _textView;
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
    self.thumbnailImageView = nil;
    self.nicknameLabel = nil;
    self.videoNameLabel = nil;
    self.commentLabel = nil;
    self.shareToLabel = nil;
    self.textView = nil;
    self.twitterButton = nil;
    self.facebookButton = nil;
    self.shareButton = nil;
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
    
    // Add Custom Back Button
    [self addCustomBackButton];
    
    // Change title to Share
    [self.navigationItem setTitle:@"Share"];
    
    // Customize UILabels (all of which are IBOutlets)
    [self.nicknameLabel setFont:[UIFont fontWithName:@"Ubuntu-Bold" size:self.nicknameLabel.font.pointSize]];
    [self.nicknameLabel setTextColor:ColorConstants_GrayTextColor];
    
    [self.videoNameLabel setFont:[UIFont fontWithName:@"Ubuntu-Bold" size:self.videoNameLabel.font.pointSize]];
    [self.videoNameLabel setTextColor:[UIColor whiteColor]];
    
    [self.commentLabel setFont:[UIFont fontWithName:@"Ubuntu-Bold" size:self.videoNameLabel.font.pointSize]];
    [self.commentLabel setTextColor:[UIColor whiteColor]];

    [self.shareToLabel setFont:[UIFont fontWithName:@"Ubuntu-Bold" size:self.shareToLabel.font.pointSize]];
    [self.shareToLabel setTextColor:[UIColor whiteColor]];
    
    // Styilize textView
    self.textView.layer.cornerRadius = 5;
    self.textView.clipsToBounds = YES;
    
    // Enable and select icons for social networks to which Shelby has authentication access
    [self.facebookButton setEnabled:[SocialFacade sharedInstance].shelbyHasAccessToFacebook];
    [self.facebookButton setSelected:[SocialFacade sharedInstance].shelbyHasAccessToFacebook];
    [self.twitterButton setEnabled:[SocialFacade sharedInstance].shelbyHasAccessToTwitter];
    [self.twitterButton setSelected:[SocialFacade sharedInstance].shelbyHasAccessToTwitter];
    
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
    
     if ( ![self.facebookButton isSelected] && ![self.twitterButton isSelected] ) {
     
         UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"No social network chosen."
                                                             message:@"Please choose at least one social network with which to share this video."
                                                            delegate:nil
                                                   cancelButtonTitle:@"Dismiss"
                                                   otherButtonTitles:nil, nil ];
         
         [alertView show];
     
     } else {
        
        // Create request string and add frameID and shelbyToken
        NSString *requestString = [NSString stringWithFormat:APIRequest_PostShareFrame, self.frame.frameID, [SocialFacade sharedInstance].shelbyToken];
        
        NSString *commentsString = [self.textView.text stringByAddingPercentEscapesUsingEncoding:NSASCIIStringEncoding];
        requestString = [NSString stringWithFormat:@"%@&text=%@", requestString, commentsString];
        
        // Build string
        if ( [self.facebookButton isSelected] ) requestString = [NSString stringWithFormat:@"%@&destination[]=facebook", requestString];
        if ( [self.twitterButton isSelected] ) requestString = [NSString stringWithFormat:@"%@&destination[]=twitter", requestString];
        
        // Show ProgressHUD
        AppDelegate *appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
        
        if ( [self.facebookButton isSelected] && [self.twitterButton isSelected] ) {
            
            [appDelegate addHUDWithMessage:@"Sharing video with Facebook and Twitter"];
            
        } else if ( [self.facebookButton isSelected] ) {
            
            [appDelegate addHUDWithMessage:@"Sharing video with Facebook"];
            
        } else if ( [self.twitterButton isSelected] ) {
            
            [appDelegate addHUDWithMessage:@"Sharing video with Twitter"];
            
        }
        
        // Perform API Request
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:requestString]];
        [request setHTTPMethod:@"POST"];
        ShelbyAPIClient *client = [[ShelbyAPIClient alloc] init];
        [client performRequest:request ofType:APIRequestType_PostShareFrame];
 
     }
    
}

#pragma mark - UIResponder Methods
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    if ( [self.textView isFirstResponder] ) [self.textView resignFirstResponder];
}

#pragma mark - Interface Orientation Method
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
