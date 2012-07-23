//
//  VideoCardController.h
//  Shelby.tv
//
//  Created by Arthur Ariel Sabintsev on 6/1/12.
//  Copyright (c) 2012 Shelby.tv. All rights reserved.
//

#import "VideoCardCell.h"
#import "VideoCardExpandedCell.h"

@interface VideoCardController : NSObject

- (id)initWithFrame:(Frame*)frame;

- (void)upvote;

- (void)downvote;

- (void)comment:(UINavigationController*)navigationController;

- (void)roll:(UINavigationController*)navigationController;

- (void)share:(UINavigationController*)navigationController;

@end