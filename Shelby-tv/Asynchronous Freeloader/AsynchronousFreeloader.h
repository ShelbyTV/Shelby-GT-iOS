//
//  AsynchronousFreeloader.h
//  Asynchronous Freeloader
//
//  Created by Arthur Ariel Sabintsev on 5/7/12.
//  Copyright (c) 2012 ArtSabintsev. All rights reserved.
//

#import <Foundation/Foundation.h>

#define AsynchronousFreeloaderCache @"Aynchronous Freeloader Cache"

@interface AsynchronousFreeloader : NSObject

+ (void)loadImageFromLink:(NSString *)link forImageView:(UIImageView *)imageView;       // Asynchronously load image from 'link' and set it in 'imageView'

@end