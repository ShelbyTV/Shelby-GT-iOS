//
//  Messages.h
//  Shelby-tv
//
//  Created by Arthur Ariel Sabintsev on 5/25/12.
//  Copyright (c) 2012 Shelby.tv. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Conversation;

@interface Messages : NSManagedObject

@property (nonatomic, retain) NSString * conversationID;
@property (nonatomic, retain) NSString * createdAt;
@property (nonatomic, retain) NSString * messageID;
@property (nonatomic, retain) NSString * nickname;
@property (nonatomic, retain) NSString * originNetwork;
@property (nonatomic, retain) NSString * text;
@property (nonatomic, retain) NSDate * timestamp;
@property (nonatomic, retain) NSString * userImageURL;
@property (nonatomic, retain) Conversation *conversation;

@end
