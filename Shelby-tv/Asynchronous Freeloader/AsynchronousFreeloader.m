//
//  AsynchronousFreeloader.m
//  Asynchronous Freeloader
//
//  Created by Arthur Ariel Sabintsev on 5/7/12.
//  Copyright (c) 2012 ArtSabintsev. All rights reserved.
//

#import "AsynchronousFreeloader.h"

@interface AsynchronousFreeloader ()

+ (NSMutableDictionary*)createReferenceToCache;
+ (BOOL)checkCache:(NSMutableDictionary*)cache ForLink:(NSString *)link;
+ (void)successfulResponseForData:(NSData *)data fromLink:(NSString*)link toPresentInImageView:(UIImageView*)imageView;
+ (void)failedResponse;

@end

@implementation AsynchronousFreeloader

#pragma mark - Public Methods
+ (void)loadImageFromLink:(NSString *)link forImageView:(UIImageView *)imageView
{

    NSMutableDictionary *cache = [AsynchronousFreeloader createReferenceToCache];
    
    BOOL imageExists = [AsynchronousFreeloader checkCache:cache ForLink:link];
    
    if ( imageExists ) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            imageView.image = [cache objectForKey:link];
            
        });
        
    } else {
        
        NSURL *url = [NSURL URLWithString:link];
        NSURLRequest *request = [[NSURLRequest alloc] initWithURL:url];
        NSOperationQueue *queue = [[NSOperationQueue alloc] init];
        
        [NSURLConnection  sendAsynchronousRequest:request queue:queue completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
            
            if ([data length] > 0 && error == nil) {
                
                [AsynchronousFreeloader successfulResponseForData:data fromLink:link toPresentInImageView:imageView];
                
            } else {
                
                [AsynchronousFreeloader failedResponse];
            }
            
        }];
        
    }
    
        
}

+ (void)removeImageFromCacheForLink:(NSString *)link
{
    
    NSMutableDictionary *cache = [AsynchronousFreeloader createReferenceToCache];
    BOOL imageExists = [AsynchronousFreeloader checkCache:cache ForLink:link];
    
    if ( cache && imageExists ) {
    
        [cache removeObjectForKey:link];
        [[NSUserDefaults standardUserDefaults] setObject:cache forKey:AsynchronousFreeloaderCache];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
    }
    
}

#pragma mark - Private Method
+ (NSMutableDictionary*)createReferenceToCache
{
    
    NSMutableDictionary *cache;
    
    if ( [[NSUserDefaults standardUserDefaults] objectForKey:AsynchronousFreeloaderCache] ) {
        
        cache = [[NSUserDefaults standardUserDefaults] objectForKey:AsynchronousFreeloaderCache];
        
    } else {
        
        cache = [NSMutableDictionary dictionary];
        
    }

    return cache;
    
}

+ (BOOL)checkCache:(NSMutableDictionary *)cache ForLink:(NSString *)link
{
    return ( [cache objectForKey:link] ) ? YES : NO;
}

+ (void)successfulResponseForData:(NSData *)data fromLink:(NSString*)link toPresentInImageView:(UIImageView*)imageView
{
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
    
        NSMutableDictionary *cache = [[NSUserDefaults standardUserDefaults] objectForKey:AsynchronousFreeloaderCache];
        
        UIImage *image = [UIImage imageWithData:data];
        
        [cache setObject:image forKey:link];
        [[NSUserDefaults standardUserDefaults] setObject:cache forKey:AsynchronousFreeloaderCache];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            imageView.image = [UIImage imageWithData:data];
            
        });
        
    });
    
}

+ (void)failedResponse
{
    
}

@end