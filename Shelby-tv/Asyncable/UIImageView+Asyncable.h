//
//  UIImageView+Asyncable.h
//  ShopStar
//
//  Created by kball on 2/1/11.
//  Copyright 2011 tween.as. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface UIImageView (Asyncable)

-(void)loadImageAsynchronouslyFromURL:(NSString *)url withLoadingImage:(UIImage *)loadingImage;
-(void)refreshForAsyncable;
-(void)refreshForAsyncableForFailedImage;

@end
