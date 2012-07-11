//
//  ShareViewController.m
//  Shelby-tv
//
//  Created by Arthur Ariel Sabintsev on 7/9/12.
//  Copyright (c) 2012 Shelby.tv. All rights reserved.
//

#import "ShareViewController.h"
#import "SocialFacade.h"
#import "AsynchronousFreeloader.h"

@interface ShareViewController () <UITextViewDelegate>

@property (strong, nonatomic) Frame *frame;

- (void)createObserver;
- (void)buildView;

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
        
        self.view.backgroundColor = ColorConstants_BackgroundColor;
        self.frame = frame;
        
        [self buildView];
        
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
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

#pragma mark - Private Methods
- (void)buildView
{
    // Thumbnail
    [AsynchronousFreeloader loadImageFromLink:self.frame.video.thumbnailURL forImageView:self.imageView withPlaceholderView:nil];

    // Labels
    self.nicknameLabel.text = self.frame.creator.nickname;
    self.videoNameLabel.text = self.frame.video.title;
    
}

- (void)createObserver
{
    
}

#pragma mark - Action Methods
- (void)shareButton:(id)sender
{
    
    [self createObserver];
    
    // Create request string and add frameID and shelbyToken
    
    NSString *requestString = [NSString stringWithFormat:APIRequest_ShareFrame, self.frame.frameID, [SocialFacade sharedInstance].shelbyToken];

    
    if ( [self.facebookButton isSelected] ) requestString = [NSString stringWithFormat:@"%@&destination[]=facebook", requestString];
    if ( [self.twitterButton isSelected] ) requestString = [NSString stringWithFormat:@"%@&destination[]=twitter", requestString];
    
    
}

#pragma mark - Interface Orientation Method
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
