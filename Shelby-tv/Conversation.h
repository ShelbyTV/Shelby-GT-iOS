//
//  Conversation.h
//  Shelby-tv
//
//  Created by Arthur Ariel Sabintsev on 5/23/12.
//  Copyright (c) 2012 Shelby.tv. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Frame, Messages;

@interface Conversation : NSManagedObject

@property (nonatomic, retain) NSString * conversationID;
@property (nonatomic, retain) Frame *frame;
@property (nonatomic, retain) Messages *messages;

@end
