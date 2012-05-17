//
//  AuthenticateTwitterViewController.m
//  Shelby-tv
//
//  Created by Arthur Ariel Sabintsev on 5/17/12.
//  Copyright (c) 2012 Shelby.tv. All rights reserved.
//

#import "AuthenticateTwitterViewController.h"

@interface AuthenticateTwitterViewController ()

@end

@implementation AuthenticateTwitterViewController
@synthesize webView = _webView;

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
    
    [self.view addSubview:self.webView];
}


#pragma mark - Interface Orientation Methods
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end