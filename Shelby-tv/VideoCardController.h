//
//  VideoCardController.h
//  Shelby-tv
//
//  Created by Arthur Ariel Sabintsev on 6/1/12.
//  Copyright (c) 2012 Shelby.tv. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "VideoCardCell.h"
#import "StaticDeclarations.h"


@interface VideoCardController : NSObject

- (id)initWithCell:(VideoCardCell*)cell 
         withFrame:(Frame*)frame 
  inViewController:(UIViewController*)viewController;

- (BOOL)checkIfUserUpvoted;

- (void)comment;

- (void)roll;

- (void)share;

- (void)upvote;

@end