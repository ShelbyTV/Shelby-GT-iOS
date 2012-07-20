//
//  NewRollViewController.h
//  Shelby.tv
//
//  Created by Arthur Ariel Sabintsev on 7/17/12.
//  Copyright (c) 2012 Shelby.tv. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "StaticDeclarations.h"
#import "CustomTextField.h"
#import "CustomSwitch.h"

@interface NewRollViewController : UIViewController <UITextFieldDelegate>

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil andFrame:(Frame *)frame;

@property (weak, nonatomic) IBOutlet UIImageView *thumbnailImageView;
@property (weak, nonatomic) IBOutlet UILabel *nicknameLabel;
@property (weak, nonatomic) IBOutlet UILabel *videoNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *createNewRollLabel;
@property (weak, nonatomic) IBOutlet UILabel *rollNameLabel;
@property (weak, nonatomic) IBOutlet CustomTextField *titleTextField;
@property (weak, nonatomic) IBOutlet CustomSwitch *privacySwitch;
@property (weak, nonatomic) IBOutlet UIButton *shareButton;
@property (weak, nonatomic) IBOutlet UIButton *rollButton;

- (IBAction)shareButtonAction:(id)sender;
- (IBAction)rollButtonAction:(id)sender;

@end