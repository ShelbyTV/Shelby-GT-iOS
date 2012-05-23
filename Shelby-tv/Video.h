//
//  Video.h
//  Shelby-tv
//
//  Created by Arthur Ariel Sabintsev on 5/23/12.
//  Copyright (c) 2012 Shelby.tv. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Frame;

@interface Video : NSManagedObject

@property (nonatomic, retain) NSString * caption;
@property (nonatomic, retain) NSString * providerName;
@property (nonatomic, retain) NSString * sourceURL;
@property (nonatomic, retain) NSString * thumbnailURL;
@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSString * videoID;
@property (nonatomic, retain) Frame *frame;

@end
