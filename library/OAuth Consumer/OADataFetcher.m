//
//  OADataFetcher.m
//  OAuthConsumer
//
//  Created by Jon Crosby on 11/5/07.
//  Copyright 2007 Kaboomerang LLC. All rights reserved.
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.


#import "OADataFetcher.h"


@implementation OADataFetcher

- (id)init {
	if ((self = [super init])) {
		_responseData = [[NSMutableData alloc] init];
	}
	return self;
}


/* Protocol for async URL loading */
- (void)connection:(NSURLConnection *)aConnection didReceiveResponse:(NSURLResponse *)aResponse {
	_response = aResponse;
	[_responseData setLength:0];
}
	
- (void)connection:(NSURLConnection *)aConnection didFailWithError:(NSError *)error {
	OAServiceTicket *ticket = [[OAServiceTicket alloc] initWithRequest:_request
															  response:_response
																  data:_responseData
															didSucceed:NO];

    
	[_delegate performSelector:_didFailSelector withObject:ticket withObject:error];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
	[_responseData appendData:data];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    
//    if ( [(NSHTTPURLResponse *)_response statusCode] != 200 ) {
//        
//        connection = nil;
//        _connection = [[NSURLConnection alloc] initWithRequest:_request delegate:self];
//        
//    } else {
    
    OAServiceTicket *ticket = [[OAServiceTicket alloc] initWithRequest:_request
                                                              response:_response
                                                                  data:_responseData
                                                            didSucceed:YES];
    
    [_delegate performSelector:_didFinishSelector withObject:ticket withObject:_responseData];

//    }
	    
}

- (void)fetchDataWithRequest:(OAMutableURLRequest *)aRequest delegate:(id)aDelegate didFinishSelector:(SEL)finishSelector didFailSelector:(SEL)failSelector {
	
    _request = aRequest;
    _delegate = aDelegate;
    _didFinishSelector = finishSelector;
    _didFailSelector = failSelector;
    
    [_request prepare];

    _request.HTTPShouldHandleCookies = NO;
    
	_connection = [[NSURLConnection alloc] initWithRequest:aRequest delegate:self];
}

@end
