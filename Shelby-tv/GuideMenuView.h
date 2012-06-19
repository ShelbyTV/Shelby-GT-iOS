//
//  GuideMenuView.h
//  Shelby-tv
//
//  Created by Arthur Ariel Sabintsev on 6/12/12.
//  Copyright (c) 2012 Shelby.tv. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GuideMenuView : UIView

@property (weak, nonatomic) IBOutlet UIButton *browseRollsButton;
@property (weak, nonatomic) IBOutlet UIButton *myRollsButton;
@property (weak, nonatomic) IBOutlet UIButton *peopleRollsButton;
@property (weak, nonatomic) IBOutlet UIButton *settingsButton;
@property (weak, nonatomic) IBOutlet UIButton *streamButton;

@end
