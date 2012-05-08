//
//  AsynchronousFreeloader.m
//  Asynchronous Freeloader
//
//  Created by Arthur Ariel Sabintsev on 5/7/12.
//  Copyright (c) 2012 ArtSabintsev. All rights reserved.
//

#import "AsynchronousFreeloader.h"

@interface AsynchronousFreeloader ()

+ (NSMutableDictionary*)createReferenceToCache;                             // Create local instance of NSMutableDictionary

+ (BOOL)doesImageWithName:(NSString*)name                                   // Check if image exists in cache and on device (determines if HTTP request needs to be performed)
                   exist:(NSMutableDictionary*)cache;                                          

+ (void)saveImageWithName:(NSString*)name                                   // Save data from asynchronous response to tmp directory on device
                 fromData:(NSData*)data;                    

+ (void)successfulResponseForImageView:(UIImageView*)imageView              // Asynchronous request succeeded
                              withData:(NSData *)data
                              fromLink:(NSString*)link;

+ (void)failedResponseForImageView:(UIImageView*)imageView;                 // Asynchronous request failed

@end

@implementation AsynchronousFreeloader

#pragma mark - Public Methods
+ (void)loadImageFromLink:(NSString *)link forImageView:(UIImageView *)imageView
{
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        NSMutableDictionary *cache = [AsynchronousFreeloader createReferenceToCache];
        
        BOOL imageExists = [AsynchronousFreeloader doesImageWithName:link exist:cache];
        
        if ( imageExists ) {
            
            imageView.image = [UIImage imageWithContentsOfFile:[cache objectForKey:link]];
            
        } else {
            
            // Create asychronous request
            NSURL *url = [NSURL URLWithString:link];
            NSURLRequest *request = [[NSURLRequest alloc] initWithURL:url];
            NSOperationQueue *queue = [[NSOperationQueue alloc] init];
            
            [NSURLConnection sendAsynchronousRequest:request queue:queue completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
                
                if ([data length] > 0 && error == nil) {    // Successful asynchronous response
                    
                    [AsynchronousFreeloader successfulResponseForImageView:imageView withData:data fromLink:link];
                    
                } else {                                    // Failed asynchronous response
                    
                    [AsynchronousFreeloader failedResponseForImageView:imageView];
                    
                }
                
            }];
            
        }

        
    });
    
}

#pragma mark - Private Methods
+ (NSMutableDictionary*)createReferenceToCache
{
    
    NSMutableDictionary *cache = [NSMutableDictionary dictionary];
    
    if ( [[NSUserDefaults standardUserDefaults] objectForKey:AsynchronousFreeloaderCache] ) {
        
        // If cache exists in NSUserDefaults
        [cache setDictionary:[[NSUserDefaults standardUserDefaults] objectForKey:AsynchronousFreeloaderCache]];
        
    }
    
    return cache;
}

+ (BOOL)doesImageWithName:(NSString *)name exist:(NSMutableDictionary *)cache
{
    
    BOOL imageExists;
    
    // Check if image reference exists in cache
    BOOL cacheReferenceExists = ( [cache objectForKey:name] ) ? YES : NO;
    
    // Check if image exists at referenced path
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL pathReferenceExists = [fileManager fileExistsAtPath:[cache objectForKey:name]];
    
    if ( cacheReferenceExists && pathReferenceExists ) {            // If image exists in cache and on device
        
        imageExists = YES;
    
    } else if ( cacheReferenceExists && !pathReferenceExists ) {    // If image exists in cache, but doesn't exist on device
        
        // Remove image-reference from cache and update NSUserDefaults
        [cache removeObjectForKey:name];
        [[NSUserDefaults standardUserDefaults] setObject:cache forKey:AsynchronousFreeloaderCache];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
    } else {                                                        // If image doesn't exists in cache, nor on the device
        
        imageExists = NO;
        
    }
    
    return imageExists;
}


+ (void)saveImageWithName:(NSString *)name fromData:(NSData *)data
{
    
    NSMutableDictionary *cache = [AsynchronousFreeloader createReferenceToCache];
    
    // Save image to disk with URL-based fileName
    NSString *filename = [NSString stringWithFormat:@"%@", name];
    filename = [filename stringByReplacingOccurrencesOfString:@"http://" withString:@""];
    filename = [filename stringByReplacingOccurrencesOfString:@"/" withString:@""];
    NSString *path = [NSString stringWithFormat:@"%@%@", NSTemporaryDirectory(), filename];
    [data writeToFile:path atomically:YES];
    
    // Save path to cache
    [cache setObject:path forKey:name];
    
    // Save cache to NSUserDefaults
    [[NSUserDefaults standardUserDefaults] setObject:cache forKey:AsynchronousFreeloaderCache];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
}

+ (void)successfulResponseForImageView:(UIImageView *)imageView withData:(NSData *)data fromLink:(NSString *)link
{

    [AsynchronousFreeloader saveImageWithName:link fromData:data];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        // Update UI on Main Thread
        imageView.image = [UIImage imageWithData:data];
    
    });
    
}

+ (void)failedResponseForImageView:(UIImageView *)imageView
{
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        // Custom failed response
        
    });
    
}

@end