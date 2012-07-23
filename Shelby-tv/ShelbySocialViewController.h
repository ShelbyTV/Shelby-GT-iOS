//
//  ShelbySocialViewController.h
//  Shelby-tv
//
//  Created by Arthur Ariel Sabintsev on 7/23/12.
//  Copyright (c) 2012 Shelby.tv. All rights reserved.
//

#import "AppDelegate.h"
#import "CoreDataUtility.h"
#import "ShelbyAPIClient.h"
#import "SocialFacade.h"
#import "AsynchronousFreeloader.h"
#import "NSString+TypedefConversion.h"

@interface ShelbySocialViewController : UIViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil andFrame:(Frame *)frame;

@property (weak, nonatomic) IBOutlet UIImageView *thumbnailImageView;
@property (weak, nonatomic) IBOutlet UILabel *nicknameLabel;
@property (weak, nonatomic) IBOutlet UILabel *videoNameLabel;

- (void)addCustomBackButton;

@end