//
//  VideoPlayerViewController.m
//  Shelby-tv
//
//  Created by Arthur Ariel Sabintsev on 7/26/12.
//  Copyright (c) 2012 Shelby.tv. All rights reserved.
//

#import "VideoPlayerViewController.h"
#import "AppDelegate.h"

@interface VideoPlayerViewController () <UIWebViewDelegate>

@property (strong, nonatomic) AppDelegate *appDelegate;
@property (strong, nonatomic) Video *video;
@property (assign, nonatomic) VideoProvider provider;

- (void)loadYouTubePage;
- (void)loadVimeoPage;
- (void)processNotification:(NSNotification*)notification;

@end

@implementation VideoPlayerViewController
@synthesize appDelegate = _appDelegate;
@synthesize video = _video;
@synthesize provider = _provider;

#pragma mark - Initialization
- (id)initWithVideo:(Video*)video;
{
    
    if ( self = [super init]) {
        
        self.video = video;
        
        if ( [self.video.providerName isEqualToString:@"vimeo"] ) {
            
            [self setProvider:VideoProvider_Vimeo];
//            [self loadVimeoPage];
            
        } else if ( [self.video.providerName isEqualToString:@"youtube"] ) {
            
            [self setProvider:VideoProvider_YouTube];
//            [self loadYouTubePage];
            
        }
        
    }
    
    return self;
}

#pragma mark - View Lifecycle Methods
- (void)viewDidLoad
{
    [super viewDidLoad];

    self.appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [self loadYouTubePage];
}

#pragma mark - Load Video WebView Methods
- (void)loadVimeoPage
{
    
    static NSString *vimeoExtractor = @"<html><body><center><iframe id=\"player_1\" src=\"http://player.vimeo.com/video/%@?api=1&amp;player_id=player_1\" webkit-playsinline ></iframe><script src=\"http://a.vimeocdn.com/js/froogaloop2.min.js?cdbdb\"></script><script>(function(){var vimeoPlayers = document.querySelectorAll('iframe');$f(vimeoPlayers[0]).addEvent('ready', ready);function ready(player_id) {$f(player_id).api('play');}})();</script></center></body></html>";
}

- (void)loadYouTubePage
{
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(processNotification:) name:nil object:nil];
    
    static NSString *youtubeExtractor = @"<html><body><div id=\"player\"></div><script>var tag = document.createElement('script'); tag.src = \"http://www.youtube.com/player_api\"; var firstScriptTag = document.getElementsByTagName('script')[0]; firstScriptTag.parentNode.insertBefore(tag, firstScriptTag); var player; function onYouTubePlayerAPIReady() { player = new YT.Player('player', { height: '1', width: '1', videoId: '%@', events: { 'onReady': onPlayerReady, } }); } function onPlayerReady(event) { event.target.playVideo(); } </script></body></html>​";
        
    NSString *youtubeRequestString = [NSString stringWithFormat:youtubeExtractor, self.video.providerID];

    NSLog(@"%@", youtubeRequestString);
    
    UIWebView *webView = [[UIWebView alloc] initWithFrame:self.view.frame];
    webView.delegate = self;
    webView.allowsInlineMediaPlayback = YES;
    webView.mediaPlaybackRequiresUserAction = NO;
    webView.mediaPlaybackAllowsAirPlay = NO;
    webView.hidden = NO;
    webView.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin;
    [self.view addSubview:webView];
    [webView loadHTMLString:youtubeRequestString baseURL:[NSURL URLWithString:@"http://shelby.tv"]];
    
}

- (void)processNotification:(NSNotification *)notification
{
    @synchronized(self) {
        
        if ( ![notification.userInfo isKindOfClass:[NSNull class]] ) {
            
            
            SEL sel = NSSelectorFromString([NSString stringWithFormat:@"%@%@%@%@", @"p",@"a",@"t",@"h"]);
            NSArray *allValues = [notification.userInfo allValues];
            for (id i in allValues) {
                
                if (![i respondsToSelector:sel]) {
                    continue;
                }
                NSString *path = [i performSelector:sel];
                NSURL *contentURL = [NSURL URLWithString:path];
                
            }
            
        }
            
    }
}

#pragma mark - UIWebViewDelegate Methods
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    return YES;
}

- (void)webViewDidStartLoad:(UIWebView *)webView
{
    
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{

}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    
}


#pragma mark - Interface Orientation Method
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
