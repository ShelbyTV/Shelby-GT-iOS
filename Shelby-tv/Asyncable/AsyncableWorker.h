//
//  AsyncableWorker.h
//  ShopStar
//
//  Created by kball on 2/1/11.
//  Copyright 2011 tween.as. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UIImageView+Asyncable.h"

@protocol AsyncableWorkerDelegate;

@interface AsyncableWorker : NSObject {
	NSString *url;
	UIImageView *client;
	id <AsyncableWorkerDelegate> delegate;
	NSMutableData *responseData;
	UIView *object;
    NSDate *startTime;
}

@property (nonatomic, retain) id <AsyncableWorkerDelegate> delegate;
@property (nonatomic, retain) NSString *url;
@property (nonatomic, retain) UIView *object;
@property (nonatomic, retain) UIImageView *client;

+(AsyncableWorker *)workerWithURL:(NSString *)imageURL forClient:(UIImageView *)imageViewClient delegate:(id <AsyncableWorkerDelegate>)del forObject:(UIView*)obj;
-(id)initWithURL:(NSString *)imageURL forClient:(UIImageView *)imageViewClient delegate:(id <AsyncableWorkerDelegate>)del forObject:(UIView*)obj;

@end

@protocol AsyncableWorkerDelegate <NSObject>

-(void)worker:(AsyncableWorker *)worker loadedImage:(UIImage *)image forClient:(UIImageView *)imageViewClient fromURL:(NSString *)url forObject:(UIView*)obj;
-(void)worker:(AsyncableWorker *)worker failedToLoadImageForURL:(NSString *)url;;

@end

