//
//  Video.h
//  Shelby-tv
//
//  Created by Arthur Ariel Sabintsev on 5/10/12.
//  Copyright (c) 2012 Shelby.tv. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Video : NSManagedObject

@property (nonatomic, retain) NSString * id;
@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSString * thumbnailURL;
@property (nonatomic, retain) NSString * sourceURL;
@property (nonatomic, retain) NSString * caption;
@property (nonatomic, retain) NSManagedObject *frame;
@property (nonatomic, retain) NSManagedObject *dashboardEntry;

@end
