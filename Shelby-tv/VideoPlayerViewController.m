//
//  VideoPlayerViewController.m
//  Shelby-tv
//
//  Created by Arthur Ariel Sabintsev on 7/26/12.
//  Copyright (c) 2012 Shelby.tv. All rights reserved.
//

#import "VideoPlayerViewController.h"
#import "AppDelegate.h"
#import "CoreDataUtility.h"
#import <MediaPlayer/MediaPlayer.h>

@interface VideoPlayerViewController ()

@property (strong, nonatomic) AppDelegate *appDelegate;
@property (strong, nonatomic) Video *video;
@property (assign, nonatomic) VideoProvider provider;
@property (strong, nonatomic) UIActivityIndicatorView *indicator;
@property (strong, nonatomic) UIWebView *webView;

- (UIWebView*)createWebView;
- (void)loadYouTubePage;
- (void)loadVimeoPage;
- (void)processNotification:(NSNotification*)notification;
- (void)playMovie;

@end

@implementation VideoPlayerViewController
@synthesize appDelegate = _appDelegate;
@synthesize video = _video;
@synthesize provider = _provider;
@synthesize indicator = _indicator;
@synthesize webView = _webView;

#pragma mark - Initialization
- (id)initWithVideo:(Video*)video;
{
    
    if ( self = [super init]) {
        
        self.video = video;
        
        if ( self.video.videoURL.length ) { // If videoURL exists, dismissViewController

                NSLog(@"%@", self.video.videoURL);
            [self playMovie];
            
        } else { // If videoURL does not exist, get videoURL
            
            self.appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
            
            self.webView = [self createWebView];
            
            if ( [self.video.providerName isEqualToString:@"vimeo"] ) {
                
                [self setProvider:VideoProvider_Vimeo];
                [self loadVimeoPage];
                
            } else if ( [self.video.providerName isEqualToString:@"youtube"] ) {
                
                [self setProvider:VideoProvider_YouTube];
                [self loadYouTubePage];
                
            }
            
        }
        
        
    }
    
    return self;
}

#pragma mark - View Lifecycle Methods
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor blackColor]];
    
    self.indicator = [[UIActivityIndicatorView alloc] initWithFrame:self.view.frame];
    self.indicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhiteLarge;
    [self.view addSubview:self.indicator];
    [self.indicator startAnimating];
    
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

#pragma mark - Private Methods
- (UIWebView*)createWebView
{
    UIWebView *webView = [[UIWebView alloc] initWithFrame:CGRectMake(1.0f, 1.0f, 1.0f, 1.0f)];
    webView.allowsInlineMediaPlayback = YES;
    webView.mediaPlaybackRequiresUserAction = NO;
    webView.mediaPlaybackAllowsAirPlay = NO;
    webView.hidden = YES;
    webView.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin;

    return webView;
}

- (void)loadVimeoPage
{
    
    static NSString *vimeoExtractor = @"<html><body><center><iframe id=\"player_1\" src=\"http://player.vimeo.com/video/%@?api=1&amp;player_id=player_1\" webkit-playsinline ></iframe><script src=\"http://a.vimeocdn.com/js/froogaloop2.min.js?cdbdb\"></script><script>(function(){var vimeoPlayers = document.querySelectorAll('iframe');$f(vimeoPlayers[0]).addEvent('ready', ready);function ready(player_id) {$f(player_id).api('play');}})();</script></center></body></html>";
}

- (void)loadYouTubePage
{
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(processNotification:) name:nil object:nil];
    
    static NSString *youtubeExtractor = @"<html><body><div id=\"player\"></div><script>var tag = document.createElement('script'); tag.src = \"http://www.youtube.com/player_api\"; var firstScriptTag = document.getElementsByTagName('script')[0]; firstScriptTag.parentNode.insertBefore(tag, firstScriptTag); var player; function onYouTubePlayerAPIReady() { player = new YT.Player('player', { height: '1', width: '1', videoId: '%@', events: { 'onReady': onPlayerReady, } }); } function onPlayerReady(event) { event.target.playVideo(); } </script></body></html>​";
        
    NSString *youtubeRequestString = [NSString stringWithFormat:youtubeExtractor, self.video.providerID];
    

    [self.view addSubview:self.webView];
    [self.webView loadHTMLString:youtubeRequestString baseURL:[NSURL URLWithString:@"http://shelby.tv"]];
    
}

- (void)playMovie
{
    [self.indicator stopAnimating];
    [self.indicator removeFromSuperview];
    MPMoviePlayerController *player = [[MPMoviePlayerController alloc] initWithContentURL:[NSURL URLWithString:self.video.videoURL]];
    player.controlStyle = MPMovieControlStyleFullscreen;
    player.view.frame = self.view.bounds;
    player.view.transform = CGAffineTransformConcat(player.view.transform, CGAffineTransformMakeRotation(M_PI_2));
    [self.view addSubview:player.view];
    [player play];
}


#pragma mark - Observer Methods
- (void)processNotification:(NSNotification *)notification
{
    if ( ![notification.userInfo isKindOfClass:[NSNull class]] ) {
        
        NSArray *allValues = [notification.userInfo allValues];
        
        for (NSString *value in allValues) {
            
            SEL pathSelector = @selector(path);
            
            if ([value respondsToSelector:pathSelector]) {
                
                NSString *path = [value performSelector:pathSelector];
                
                // Save to CoreData
                [CoreDataUtility storeVideoURL:path forVideo:self.video];
                
                // Remove webView
                [self.webView removeFromSuperview];
                
                // Launch MPMoviePlayer
                [self playMovie];
              
            }
        }
        
    }
}


#pragma mark - Interface Orientation Method
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
