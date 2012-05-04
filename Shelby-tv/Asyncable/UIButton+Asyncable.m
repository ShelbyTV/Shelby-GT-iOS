//
//  UIButton+Asyncable.m
//  Fashism
//
//  Created by dev9 on 09/02/11.
//  Copyright 2011 Ophio. All rights reserved.
//

#import "UIButton+Asyncable.h"
#import "Asyncable.h"

@implementation UIButton (Asyncable)

-(void)loadImageAsynchronouslyFromURL:(NSString *)url withLoadingImage:(UIImage *)loadingImage {
	self.alpha = 1;
	self.imageView.contentMode = UIViewContentModeScaleAspectFit;
	UIImage *cachedImage;
	if ((cachedImage = [[Asyncable sharedInstance] imageForView:self.imageView fromURL:url forObject:self])) {
		[self setImage:cachedImage forState:UIControlStateNormal];
	}
	else {
		if (loadingImage != nil) {
			[self setImage:loadingImage forState:UIControlStateNormal];
		}
		else{
			self.alpha = 0;
		}
	}
}

-(void)refreshForAsyncable:(NSString*)url {
	
	UIImage *cachedImage;
	if ((cachedImage = [[Asyncable sharedInstance].images objectForKey:url])) {
		[self setImage:cachedImage forState:UIControlStateNormal];
	}
	
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDuration:.5];
	self.alpha = 1;
	[UIView commitAnimations];
}

@end
