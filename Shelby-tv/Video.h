//
//  Video.h
//  Shelby-tv
//
//  Created by Arthur Ariel Sabintsev on 5/14/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class DashboardEntry, Frame;

@interface Video : NSManagedObject

@property (nonatomic, retain) NSString * caption;
@property (nonatomic, retain) NSString * idString;
@property (nonatomic, retain) NSString * sourceURL;
@property (nonatomic, retain) NSString * thumbnailURL;
@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) DashboardEntry *dashboardEntry;
@property (nonatomic, retain) Frame *frame;

@end
