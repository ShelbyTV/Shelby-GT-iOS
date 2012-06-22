//
//  VideoCardController.h
//  Shelby-tv
//
//  Created by Arthur Ariel Sabintsev on 6/1/12.
//  Copyright (c) 2012 Shelby.tv. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "VideoCardCell.h"
#import "VideoCardExpandedCell.h"
#import "StaticDeclarations.h"


@interface VideoCardController : NSObject

- (id)initWithFrameID:(NSString *)frameID;

- (void)upvote;

- (void)downvote;

- (void)comment;

- (void)roll;

- (void)share;

@end