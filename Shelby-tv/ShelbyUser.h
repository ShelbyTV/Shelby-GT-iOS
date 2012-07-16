//
//  ShelbyUser.h
//  Shelby-tv
//
//  Created by Arthur Ariel Sabintsev on 7/16/12.
//  Copyright (c) 2012 Shelby.tv. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface ShelbyUser : NSManagedObject

@property (nonatomic, retain) NSString * authToken;
@property (nonatomic, retain) NSString * heartRollID;
@property (nonatomic, retain) NSString * nickname;
@property (nonatomic, retain) NSString * personalRollID;
@property (nonatomic, retain) NSString * shelbyID;
@property (nonatomic, retain) NSString * userImage;
@property (nonatomic, retain) NSString * watchLaterRollID;
@property (nonatomic, retain) NSNumber * authenticatedWithFacebook;
@property (nonatomic, retain) NSNumber * authenticatedWithTwitter;
@property (nonatomic, retain) NSNumber * authenticatedWithTumblr;

@end
