//
//  UpvoteUsers.h
//  Shelby-tv
//
//  Created by Arthur Ariel Sabintsev on 8/1/12.
//  Copyright (c) 2012 Shelby.tv. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Frame;

@interface UpvoteUsers : NSManagedObject

@property (nonatomic, retain) NSString * nickname;
@property (nonatomic, retain) NSString * rollID;
@property (nonatomic, retain) NSString * upvoterID;
@property (nonatomic, retain) NSString * userImage;
@property (nonatomic, retain) NSString * frameID;
@property (nonatomic, retain) NSSet *frame;
@end

@interface UpvoteUsers (CoreDataGeneratedAccessors)

- (void)addFrameObject:(Frame *)value;
- (void)removeFrameObject:(Frame *)value;
- (void)addFrame:(NSSet *)values;
- (void)removeFrame:(NSSet *)values;

@end
