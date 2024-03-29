//
//  Messages.h
//  Shelby.tv
//
//  Created by Arthur Ariel Sabintsev on 7/16/12.
//  Copyright (c) 2012 Shelby.tv. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Conversation;

@interface Messages : NSManagedObject

@property (nonatomic, retain) NSString * conversationID;
@property (nonatomic, retain) NSString * createdAt;
@property (nonatomic, retain) NSString * messagesID;
@property (nonatomic, retain) NSString * nickname;
@property (nonatomic, retain) NSString * originNetwork;
@property (nonatomic, retain) NSString * text;
@property (nonatomic, retain) NSDate * timestamp;
@property (nonatomic, retain) NSString * userImage;
@property (nonatomic, retain) NSSet *conversation;
@end

@interface Messages (CoreDataGeneratedAccessors)

- (void)addConversationObject:(Conversation *)value;
- (void)removeConversationObject:(Conversation *)value;
- (void)addConversation:(NSSet *)values;
- (void)removeConversation:(NSSet *)values;

@end
