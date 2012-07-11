//
//  ShareViewController.h
//  Shelby-tv
//
//  Created by Arthur Ariel Sabintsev on 7/9/12.
//  Copyright (c) 2012 Shelby.tv. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "StaticDeclarations.h"

@interface ShareViewController : UIViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil andFrame:(Frame*)frame;

@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UILabel *nicknameLabel;
@property (weak, nonatomic) IBOutlet UILabel *videoNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *commentLabel;
@property (weak, nonatomic) IBOutlet UILabel *shareToLabel;
@property (weak, nonatomic) IBOutlet UITextView *commentTextView;
@property (weak, nonatomic) IBOutlet UIButton *twitterButton;
@property (weak, nonatomic) IBOutlet UIButton *facebookButton;
@property (weak, nonatomic) IBOutlet UIButton *shareButton;

- (IBAction)twitterButtonAction:(id)sender;
- (IBAction)facebookButtonAction:(id)sender;
- (IBAction)shareButtonAction:(id)sender;

@end
