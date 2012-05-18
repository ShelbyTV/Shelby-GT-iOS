//
//  AuthenticateTwitterViewController.m
//  Shelby-tv
//
//  Created by Arthur Ariel Sabintsev on 5/17/12.
//  Copyright (c) 2012 Shelby.tv. All rights reserved.
//

#import "AuthenticateTwitterViewController.h"

@interface AuthenticateTwitterViewController ()

@property (strong, nonatomic) id <AuthenticateTwitterDelegate> delegate;  
@property(assign, nonatomic) BOOL pinPageLoaded;

@end

@implementation AuthenticateTwitterViewController
@synthesize webView = _webView;
@synthesize delegate = _delegate;
@synthesize pinPageLoaded = _pinPageLoaded;

#pragma mark - Initialization Methods
- (id)initWithDelegate:(id<AuthenticateTwitterDelegate>)delegate
{
    if ( self = [super init] ) {
        
        self.delegate = delegate;
        
    }
    
    return self;
}

#pragma mark - View Lifecycle Methods
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UIBarButtonItem *cancelBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Cancel" style:UIBarButtonItemStyleDone target:self action:@selector(dismissModalViewControllerAnimated:)];
    self.navigationItem.leftBarButtonItem = cancelBarButtonItem;
    
    self.webView = [[UIWebView alloc] initWithFrame:self.view.frame];
    self.webView.delegate = self;
    
    [self.view addSubview:self.webView];
}

#pragma mark - UIWebViewDelegate
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    
    self.pinPageLoaded = ( [request.URL.absoluteString compare:@"https://api.twitter.com/oauth/authenticate"] == NSOrderedSame);
    
    return YES;
}


- (void)webViewDidFinishLoad:(UIWebView *)webView 
{

    if( self.pinPageLoaded ) {
        
        self.pinPageLoaded = NO;
        NSString *script = @"(function() { return document.getElementsByTagName(\"code\")[0].textContent; } ())";
        NSString *pin = [self.webView stringByEvaluatingJavaScriptFromString:script];

        if ( [pin length] > 0 ) {
            
            [self.delegate authenticationRequestDidReturnPin:pin];
            [self dismissModalViewControllerAnimated:YES];

        }

    }
}

#pragma mark - Interface Orientation Methods
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end