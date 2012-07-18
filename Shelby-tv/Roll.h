//
//  Roll.h
//  Shelby.tv
//
//  Created by Arthur Ariel Sabintsev on 7/10/12.
//  Copyright (c) 2012 Shelby.tv. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Frame;

@interface Roll : NSManagedObject

@property (nonatomic, retain) NSString * creatorID;
@property (nonatomic, retain) NSString * creatorNickname;
@property (nonatomic, retain) NSNumber * followingCount;
@property (nonatomic, retain) NSNumber * frameCount;
@property (nonatomic, retain) NSNumber * isExplore;
@property (nonatomic, retain) NSNumber * isCollaborative;
@property (nonatomic, retain) NSNumber * isGenius;
@property (nonatomic, retain) NSNumber * isMy;
@property (nonatomic, retain) NSNumber * isFriends;
@property (nonatomic, retain) NSNumber * isPersonal;
@property (nonatomic, retain) NSNumber * isPublic;
@property (nonatomic, retain) NSString * rollID;
@property (nonatomic, retain) NSString * thumbnailURL;
@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSSet *frame;
@end

@interface Roll (CoreDataGeneratedAccessors)

- (void)addFrameObject:(Frame *)value;
- (void)removeFrameObject:(Frame *)value;
- (void)addFrame:(NSSet *)values;
- (void)removeFrame:(NSSet *)values;

@end
