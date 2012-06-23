//
//  Roll.h
//  Shelby-tv
//
//  Created by Arthur Ariel Sabintsev on 6/23/12.
//  Copyright (c) 2012 Shelby.tv. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Frame;

@interface Roll : NSManagedObject

@property (nonatomic, retain) NSString * creatorID;
@property (nonatomic, retain) NSNumber * isPublic;
@property (nonatomic, retain) NSString * rollID;
@property (nonatomic, retain) NSString * thumbnail_url;
@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSNumber * browseRoll;
@property (nonatomic, retain) NSSet *frame;
@end

@interface Roll (CoreDataGeneratedAccessors)

- (void)addFrameObject:(Frame *)value;
- (void)removeFrameObject:(Frame *)value;
- (void)addFrame:(NSSet *)values;
- (void)removeFrame:(NSSet *)values;

@end
