//
//  LoginViewController.h
//  Shelby.tv
//
//  Created by Arthur Ariel Sabintsev on 4/20/12.
//  Copyright (c) 2012 Shelby.tv. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ShelbyMenuViewController;
@interface LoginViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIImageView *topBarImageView;
@property (weak, nonatomic) IBOutlet UILabel *sloganLabel;
@property (weak, nonatomic) IBOutlet UIButton *facebookButton;
@property (weak, nonatomic) IBOutlet UIButton *twitterButton;

- (IBAction)facebookLogin:(id)sender;
- (IBAction)twitterLogin:(id)sender;

@end