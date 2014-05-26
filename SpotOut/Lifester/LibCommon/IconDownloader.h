//
//  IconDownloader.h
//  IconDownloader
//
//  Created by Nikunj on 4/17/13.
//  Copyright (c) 2013 Nikunj. All rights reserved.
//

#import <Foundation/Foundation.h>

#pragma mark - Software Author Customized Definitions

#define IconDownloaderCache         @"Aynchronous IconDownloaderloader Cache"
#define IconDownloaderCachePaths    @"Aynchronous IconDownloaderloader Cache Path"
#define IconDownloaderCacheNames    @"Aynchronous IconDownloaderloader Cache Name"

#pragma mark - User Customized Definitions
#define IconDownloaderCacheSize     1000

@interface IconDownloader : NSObject

/* 

 Asynchronously load image from 'link' and set it in 'imageView'. 
 Optionally, you may add a placeholderView to be displayed while your image is being fetched.
 If you pass 'nil' to placeholderView, a white UIActivityIndicatorView will be used.
 
 */

+ (void)loadImageFromLink:(NSString *)link
             forImageView:(UIImageView *)imageView
          withPlaceholder:(UIImage*)placeholder
           andContentMode:(UIViewContentMode)contentMode;

// Remove an image from the cache (images use links as dictionary keys)
+ (void)removeImageFromCache:(NSString*)link;

// Empty the cache
+ (void)removeAllImages;

@end