//
//  Asyncable.h
//  ShopStar
//
//  Created by kball on 2/1/11.
//  Copyright 2011 tween.as. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AsyncableWorker.h"
#import "UIImageView+Asyncable.h"
#import "UIButton+Asyncable.h"

extern NSString * const ASYNCABLE_REFRESH_NOTIFICATION;
extern NSString * const ASYNCABLE_LOAD_FAILED_NOTIFICATION;

@interface Asyncable : NSObject <AsyncableWorkerDelegate> {
	NSMutableDictionary *images;
}

+(Asyncable *)sharedInstance;
@property (nonatomic, retain) NSMutableDictionary *images;
-(UIImage *)imageForView:(UIImageView *)imageView fromURL:(NSString *)url forObject:(UIView*)obj;
-(void)preloadImageFromURL:(NSString *)url;
-(void)dumpUrl:(NSString*)url;

@end
