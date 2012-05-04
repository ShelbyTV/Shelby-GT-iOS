//
//  UIImageView+Asyncable.m
//  ShopStar
//
//  Created by kball on 2/1/11.
//  Copyright 2011 tween.as. All rights reserved.
//

#import "UIImageView+Asyncable.h"
#import "Asyncable.h"
//#import <QuartzCore/QuartzCore.h>

@implementation UIImageView (Asyncable)


-(void)loadImageAsynchronouslyFromURL:(NSString *)url withLoadingImage:(UIImage *)loadingImage {
    
    UIImage *cachedImage;
	
    if ((cachedImage = [[Asyncable sharedInstance] imageForView:self fromURL:url forObject:self])) {
        [self setImage:cachedImage];
        [self refreshForAsyncable];
    } else if (loadingImage != nil){
		[self setImage:loadingImage];
	}    

}

	

-(void)refreshForAsyncable {
	[[NSNotificationCenter defaultCenter] postNotificationName:ASYNCABLE_REFRESH_NOTIFICATION object:self];
}

-(void)refreshForAsyncableForFailedImage{
    [[NSNotificationCenter defaultCenter] postNotificationName:ASYNCABLE_LOAD_FAILED_NOTIFICATION object:self];
}

@end
