//
//  AuthenticateTwitterViewController.m
//  Shelby-tv
//
//  Created by Arthur Ariel Sabintsev on 5/17/12.
//  Copyright (c) 2012 Shelby.tv. All rights reserved.
//

#import "AuthenticateTwitterViewController.h"

@interface AuthenticateTwitterViewController ()

@property(assign, nonatomic) BOOL pinPageLoaded;

@end

@implementation AuthenticateTwitterViewController
@synthesize webView = _webView;
@synthesize pinPageLoaded = _pinPageLoaded;

#pragma mark - View Lifecycle Methods
- (void)viewDidUnload
{
    
    [super viewDidUnload];
}

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
    
    self.pinPageLoaded = ( [request.URL.absoluteString compare:@"https://api.twitter.com/oauth/authorize"] == NSOrderedSame);
    
    return YES;
}


- (void)webViewDidFinishLoad:(UIWebView *)webView 
{

    if( self.pinPageLoaded ) {
        
        NSString *script = @"(function() { return document.getElementsByTagName(\"code\")[0].textContent; } ())";
        NSString *pin = [self.webView stringByEvaluatingJavaScriptFromString:script];
        
        NSLog(@"%@", pin);
        
        if ( [pin length] > 0 ) {
            
            [self dismissModalViewControllerAnimated:YES];

        }
        
        self.pinPageLoaded = NO;
    }
}

#pragma mark - Interface Orientation Methods
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end