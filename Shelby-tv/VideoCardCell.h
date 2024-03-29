//
//  VideoCardCell.h
//  Shelby.tv
//
//  Created by Arthur Ariel Sabintsev on 5/4/12.
//  Copyright (c) 2012 Shelby.tv. All rights reserved.
//

@class VideoCardController, GuideTableViewController;

@interface VideoCardCell : UITableViewCell

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
@property (strong, nonatomic) VideoCardController *videoCardController;
@property (strong, nonatomic) GuideTableViewController *guideController;

@end