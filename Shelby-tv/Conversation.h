//
//  Conversation.h
//  Shelby-tv
//
//  Created by Arthur Ariel Sabintsev on 5/10/12.
//  Copyright (c) 2012 Shelby.tv. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Conversation, Frame;

@interface Conversation : NSManagedObject

@property (nonatomic, strong) NSString * id;
@property (nonatomic, strong) Frame *frame;
@property (nonatomic, strong) Conversation *dashboardEntry;

@end
