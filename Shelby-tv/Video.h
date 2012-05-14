//
//  Video.h
//  Shelby-tv
//
//  Created by Arthur Ariel Sabintsev on 5/10/12.
//  Copyright (c) 2012 Shelby.tv. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class DashboardEntry, Frame;

@interface Video : NSManagedObject

@property (nonatomic, strong) NSString * id;
@property (nonatomic, strong) NSString * title;
@property (nonatomic, strong) NSString * thumbnailURL;
@property (nonatomic, strong) NSString * sourceURL;
@property (nonatomic, strong) NSString * caption;
@property (nonatomic, strong) NSManagedObject *frame;
@property (nonatomic, strong) NSManagedObject *dashboardEntry;

@end
