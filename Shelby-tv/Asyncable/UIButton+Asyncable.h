//
//  UIButton+Asyncable.h
//  Fashism
//
//  Created by dev9 on 09/02/11.
//  Copyright 2011 Ophio. All rights reserved.


#import <Foundation/Foundation.h>


@interface UIButton (Asyncable)


-(void)loadImageAsynchronouslyFromURL:(NSString *)url withLoadingImage:(UIImage *)loadingImage;
-(void)refreshForAsyncable:(NSString*)url;

@end
