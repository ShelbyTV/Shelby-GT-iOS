//
//  VideoCardController.h
//  Shelby.tv
//
//  Created by Arthur Ariel Sabintsev on 6/1/12.
//  Copyright (c) 2012 Shelby.tv. All rights reserved.
//

#import "VideoCardCell.h"
#import "VideoCardExpandedCell.h"

@protocol VideoCardDelegate <NSObject>

- (void)upvote:(UIButton *)button;
- (void)downvote:(UIButton *)button;
- (void)comment:(UIButton *)button;
- (void)roll:(UIButton *)button;
- (void)share:(UIButton *)button;

@optional
- (void)populateTableViewCell:(VideoCardCell*)cell withDashboardContent:(DashboardEntry*)dashboardEntry inRow:(NSUInteger)row;
- (void)populateTableViewCell:(VideoCardCell*)cell withFrameContent:(Frame*)frame inRow:(NSUInteger)row;

@end

@interface VideoCardController : NSObject

- (id)initWithFrame:(Frame*)frame;
- (void)upvote;
- (void)downvote;
- (void)comment;
- (void)roll;
- (void)share;

@end