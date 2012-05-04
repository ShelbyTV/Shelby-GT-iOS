//
//  AsyncableWorker.m
//  ShopStar
//
//  Created by kball on 2/1/11.
//  Copyright 2011 tween.as. All rights reserved.
//

#import "AsyncableWorker.h"

@interface AsyncableWorker ()

@property (nonatomic, retain) NSMutableData *responseData;

@end

@implementation AsyncableWorker

@synthesize delegate, client, responseData, url,object;

+(AsyncableWorker *)workerWithURL:(NSString *)imageURL forClient:(UIImageView *)imageViewClient delegate:(id <AsyncableWorkerDelegate>)del forObject:(UIView*)obj{
	return [[[AsyncableWorker alloc] initWithURL:imageURL forClient:imageViewClient delegate:del forObject:obj] autorelease];
}

-(id)initWithURL:(NSString *)imageURL forClient:(UIImageView *)imageViewClient delegate:(id <AsyncableWorkerDelegate>)del forObject:(UIView*)obj{

	if (self = [super init]) {
		url = [imageURL retain];
		client = [imageViewClient retain];
		delegate = [del retain];
		object = [obj retain];
        startTime = [[NSDate date] retain];
		NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
		[NSURLConnection connectionWithRequest:request delegate:self];        
	}
	
	return self;
}

//-(void)cancelLoad

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
	self.responseData = [NSMutableData data];
	
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
	[self.responseData appendData:data];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
	UIImage *newImage = [[[UIImage alloc] initWithData:responseData] autorelease];
	if (newImage) {
		[self.delegate worker:self loadedImage:newImage forClient:self.client fromURL:self.url forObject:object];
	}
	else {
		[self.delegate worker:self failedToLoadImageForURL:self.url];
	}

}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
	[self.delegate worker:self failedToLoadImageForURL:self.url];
}

- (BOOL)connection:(NSURLConnection *)connection canAuthenticateAgainstProtectionSpace:(NSURLProtectionSpace *)protectionSpace {
    return [protectionSpace.authenticationMethod isEqualToString:NSURLAuthenticationMethodServerTrust];
}

- (void)connection:(NSURLConnection *)connection didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge {
    if ([challenge.protectionSpace.authenticationMethod isEqualToString:NSURLAuthenticationMethodServerTrust])
//        if (... user allows connection despite bad certificate ...)
            [challenge.sender useCredential:[NSURLCredential credentialForTrust:challenge.protectionSpace.serverTrust] forAuthenticationChallenge:challenge];
    
    [challenge.sender continueWithoutCredentialForAuthenticationChallenge:challenge];
}

-(void)dealloc {
	[url release]; url = nil;
	[responseData release]; responseData = nil;
	[delegate release]; delegate = nil;
	[client release]; client = nil;
	[object release]; object = nil;
    [startTime release];
	
	[super dealloc];
}

@end
