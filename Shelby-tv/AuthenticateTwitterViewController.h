//
//  AuthenticateTwitterViewController.h
//  Shelby-tv
//
//  Created by Arthur Ariel Sabintsev on 5/17/12.
//  Copyright (c) 2012 Shelby.tv. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AuthenticateTwitterViewController : UIViewController <UIWebViewDelegate>

@property (strong, nonatomic) UIWebView *webView;

@end