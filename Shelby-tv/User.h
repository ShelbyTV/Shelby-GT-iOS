//
//  User.h
//  Shelby-tv
//
//  Created by Arthur Ariel Sabintsev on 5/23/12.
//  Copyright (c) 2012 Shelby.tv. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Frame;

@interface User : NSManagedObject

@property (nonatomic, retain) NSString * faux;
@property (nonatomic, retain) NSString * nickname;
@property (nonatomic, retain) NSString * publicRollID;
@property (nonatomic, retain) NSString * userID;
@property (nonatomic, retain) NSString * userImage;
@property (nonatomic, retain) Frame *frame;

@end
