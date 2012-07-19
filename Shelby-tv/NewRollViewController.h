//
//  NewRollViewController.h
//  Shelby.tv
//
//  Created by Arthur Ariel Sabintsev on 7/17/12.
//  Copyright (c) 2012 Shelby.tv. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "StaticDeclarations.h"

@interface NewRollViewController : UIViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil andFrame:(Frame *)frame;

@property (weak, nonatomic) IBOutlet UIImageView *thumbnailImageView;
@property (weak, nonatomic) IBOutlet UILabel *nicknameLabel;
@property (weak, nonatomic) IBOutlet UILabel *videoNameLabel;

@end
