//
//  Roll.h
//  Shelby-tv
//
//  Created by Arthur Ariel Sabintsev on 5/24/12.
//  Copyright (c) 2012 Shelby.tv. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Frame;

@interface Roll : NSManagedObject

@property (nonatomic, retain) NSString * rollID;
@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) Frame *frame;

@end
