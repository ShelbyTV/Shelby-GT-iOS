//
//  VideoCardExpandedCell.h
//  Shelby.tv
//
//  Created by Arthur Ariel Sabintsev on 6/22/12.
//  Copyright (c) 2012 Shelby.tv. All rights reserved.
//

#import "VideoCardCell.h"

@interface VideoCardExpandedCell : VideoCardCell

@property (strong, nonatomic) Frame *shelbyFrame;

@property (weak, nonatomic) IBOutlet UIImageView *userImageView;
@property (weak, nonatomic) IBOutlet UIImageView *originNetworkImageView;
@property (weak, nonatomic) IBOutlet UIImageView *thumbnailImageView;
@property (weak, nonatomic) IBOutlet UIButton *upvoteButton;
@property (weak, nonatomic) IBOutlet UIButton *commentButton;
@property (weak, nonatomic) IBOutlet UIButton *rollButton;
@property (weak, nonatomic) IBOutlet UIButton *shareButton;
@property (weak, nonatomic) IBOutlet UILabel *createdAtLabel;
@property (weak, nonatomic) IBOutlet UILabel *videoTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *rollLabel;

@property (weak, nonatomic) IBOutlet UIImageView *upvotedUserZero;
@property (weak, nonatomic) IBOutlet UIImageView *upvotedUserOne;
@property (weak, nonatomic) IBOutlet UIImageView *upvotedUserTwo;
@property (weak, nonatomic) IBOutlet UIImageView *upvotedUserThree;
@property (weak, nonatomic) IBOutlet UIImageView *upvotedUserFour;
@property (weak, nonatomic) IBOutlet UIImageView *upvotedUserFive;
@property (weak, nonatomic) IBOutlet UIImageView *upvotedUserSix;
@property (weak, nonatomic) IBOutlet UIImageView *upvotedUserSeven;
@property (weak, nonatomic) IBOutlet UIImageView *upvotedUserEight;
@property (weak, nonatomic) IBOutlet UIImageView *upvotedUserNine;


@end