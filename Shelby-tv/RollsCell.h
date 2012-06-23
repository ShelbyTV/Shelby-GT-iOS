//
//  RollsCell.h
//  Shelby-tv
//
//  Created by Arthur Ariel Sabintsev on 6/23/12.
//  Copyright (c) 2012 Shelby.tv. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RollsCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *rollsCoverImageView;
@property (weak, nonatomic) IBOutlet UILabel *creatorNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *rollsNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *videoCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *watchingLabel;

@end
