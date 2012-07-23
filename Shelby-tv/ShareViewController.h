//
//  ShareViewController.h
//  Shelby.tv
//
//  Created by Arthur Ariel Sabintsev on 7/9/12.
//  Copyright (c) 2012 Shelby.tv. All rights reserved.
//

#import "ShelbySocialViewController.h"

@interface ShareViewController : ShelbySocialViewController <UITextViewDelegate>

@property (weak, nonatomic) IBOutlet UILabel *commentLabel;
@property (weak, nonatomic) IBOutlet UILabel *shareToLabel;
@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (weak, nonatomic) IBOutlet UIButton *twitterButton;
@property (weak, nonatomic) IBOutlet UIButton *facebookButton;
@property (weak, nonatomic) IBOutlet UIButton *shareButton;

- (IBAction)twitterButtonAction:(id)sender;
- (IBAction)facebookButtonAction:(id)sender;
- (IBAction)shareButtonAction:(id)sender;

@end
