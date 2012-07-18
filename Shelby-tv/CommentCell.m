//
//  CommentCell.m
//  Shelby.tv
//
//  Created by Arthur Ariel Sabintsev on 7/13/12.
//  Copyright (c) 2012 Shelby.tv. All rights reserved.
//

#import "CommentCell.h"
#import "StaticDeclarations.h"

@implementation CommentCell
@synthesize thumbnailImageView = _thumbnailImageView;
@synthesize nicknameLabel = _nicknameLabel;
@synthesize commentLabel = _commentLabel;
@synthesize timestampLabel = _timestampLabel;
@synthesize replyButton = _replyButton;

- (void)dealloc
{
    self.thumbnailImageView = nil;
    self.nicknameLabel = nil;
    self.commentLabel = nil;
    self.timestampLabel = nil;
    self.replyButton = _replyButton;
}

- (void)awakeFromNib
{
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.backgroundColor = ColorConstants_BackgroundColor;
    
    [self.nicknameLabel setFont:[UIFont fontWithName:@"Ubuntu-Bold" size:self.nicknameLabel.font.pointSize]];
    [self.nicknameLabel setTextColor:ColorConstants_GrayTextColor];
    [self.commentLabel setFont:[UIFont fontWithName:@"Ubuntu" size:self.commentLabel.font.pointSize]];
    [self.commentLabel setTextColor:[UIColor whiteColor]];
    [self.timestampLabel setFont:[UIFont fontWithName:@"Ubuntu" size:self.timestampLabel.font.pointSize]];
    [self.timestampLabel setTextColor:[UIColor whiteColor]];
    
}

@end
