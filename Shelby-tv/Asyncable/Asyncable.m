//
//  Asyncable.m
//  ShopStar
//
//  Created by kball on 2/1/11.
//  Copyright 2011 tween.as. All rights reserved.
//

#import "Asyncable.h"

NSString * const ASYNCABLE_REFRESH_NOTIFICATION = @"ASYNCABLE_REFRESH_NOTIFICATION";
NSString * const ASYNCABLE_LOAD_FAILED_NOTIFICATION = @"ASYNCABLE_LOAD_FAILED_NOTIFICATION";
static Asyncable *_instance;

@interface Asyncable ()

//@property (nonatomic, retain) NSMutableDictionary *images;

@end

@implementation Asyncable

@synthesize images;

+(Asyncable *)sharedInstance {
	if (!_instance) {
		_instance = [[Asyncable alloc] init];
	}
	return _instance;
}

//-(id)init {
//	if (self = [super init]) {
//		images = [[NSMutableDictionary alloc] init];
//	}
//	return self;
//}

-(id)init {
    if (self = [super init]) {
        images = [[NSMutableDictionary alloc] init];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didReceiveMemoryWarningNotification:)
                                                     name:UIApplicationDidReceiveMemoryWarningNotification object:[UIApplication sharedApplication]];
    }
    return self;
}

-(void)didReceiveMemoryWarningNotification:(NSNotification *)notification {
    [images release]; images = nil;
}

-(UIImage *)imageForView:(UIImageView *)imageView fromURL:(NSString *)url forObject:(UIView*)obj{
	UIImage *newImage;
	if ((newImage = [self.images objectForKey:url])) {
		return newImage;
	}
	if (url) {
		AsyncableWorker *worker = [AsyncableWorker workerWithURL:url forClient:imageView delegate:self forObject:obj];
		[worker retain];
	}
	return nil;
}


-(void)preloadImageFromURL:(NSString *)url {
	AsyncableWorker *worker = [AsyncableWorker workerWithURL:url forClient:nil delegate:self forObject:nil];
	[worker retain];
}

-(void)dumpUrl:(NSString*)url{
    if ([self.images objectForKey:url]) {
        [self.images removeObjectForKey:url];
    }
}

-(void)worker:(AsyncableWorker *)worker loadedImage:(UIImage *)image forClient:(UIImageView *)imageViewClient fromURL:(NSString *)url forObject:(UIView*)obj{
	[self.images setObject:image forKey:url];
	imageViewClient.image = image;
	[imageViewClient refreshForAsyncable];
	
	if ([obj isKindOfClass:[UIButton class]]) {
		[(UIButton *)obj refreshForAsyncable:url];
	}
	[worker release];
}

-(void)worker:(AsyncableWorker *)worker failedToLoadImageForURL:(NSString *)url {
    
    [worker.client refreshForAsyncableForFailedImage];
	[worker release];
}

-(NSMutableDictionary *)images {
	if (!images) {
		images = [[NSMutableDictionary dictionary] retain];
	}
	return images;
}


-(void)dealloc {
	[images release]; images = nil;
	[super dealloc];
}

@end
