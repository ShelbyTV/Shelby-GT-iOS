//
//  VideoCardController.m
//  Shelby-tv
//
//  Created by Arthur Ariel Sabintsev on 6/1/12.
//  Copyright (c) 2012 Shelby.tv. All rights reserved.
//

#import "VideoCardController.h"
#import "CoreDataUtility.h"
#import "SocialFacade.h"

@interface VideoCardController ()

@property (strong, nonatomic) VideoCardCell *cell;
@property (strong, nonatomic) Frame *frame;
@property (strong, nonatomic) UIViewController *viewController;

- (void)addActionsToCellButtons;

@end

@implementation VideoCardController
@synthesize cell = _cell;
@synthesize frame = _frame;
@synthesize viewController = _viewController;

- (id)initWithCell:(VideoCardCell *)cell 
         withFrame:(Frame *)frame 
  inViewController:(UIViewController *)viewController
{
    if ( self == [super init] ) {
        
        self.cell = cell;
        self.frame = frame;
        self.viewController = viewController;
    
        [self addActionsToCellButtons];
    }
    
    return self;
}

- (void)addActionsToCellButtons
{
    [self.cell.upvoteButton addTarget:self action:@selector(upvote) forControlEvents:UIControlEventTouchUpInside];
    [self.cell.commentsButton addTarget:self action:@selector(comment) forControlEvents:UIControlEventTouchUpInside];
    [self.cell.rollButton addTarget:self action:@selector(roll) forControlEvents:UIControlEventTouchUpInside];
    [self.cell.shareButton addTarget:self action:@selector(share) forControlEvents:UIControlEventTouchUpInside];
}

- (BOOL)checkIfUserUpvoted
{
    return [CoreDataUtility checkIfUserUpvotedInFrame:self.frame];
}

- (void)comment
{
    
}

- (void)roll
{
    
}

- (void)share
{
    
}

- (void)upvote
{
    
}

@end