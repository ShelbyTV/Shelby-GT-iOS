//
//  NewRollViewController.h
//  Shelby.tv
//
//  Created by Arthur Ariel Sabintsev on 7/17/12.
//  Copyright (c) 2012 Shelby.tv. All rights reserved.
//

#import "ShelbySocialViewController.h"
#import "CustomTextField.h"
#import "CustomSwitch.h"

@interface NewRollViewController : ShelbySocialViewController <UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UILabel *createNewRollLabel;
@property (weak, nonatomic) IBOutlet UILabel *rollNameLabel;
@property (weak, nonatomic) IBOutlet CustomTextField *titleTextField;
@property (weak, nonatomic) IBOutlet CustomSwitch *privacySwitch;
@property (weak, nonatomic) IBOutlet UIButton *shareButton;
@property (weak, nonatomic) IBOutlet UIButton *rollButton;
@property (strong, nonatomic) NSMutableArray *chosenPeopleArray;

- (IBAction)shareButtonAction:(id)sender;
- (IBAction)rollButtonAction:(id)sender;

@end