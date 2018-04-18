//
//  UIImageView+LoadImage.m
//  YouRong_Project
//
//  Created by Yuanin on 16/6/2.
//  Copyright © 2016年 YouRong. All rights reserved.
//

#import "UIImageView+LoadImage.h"

#import "UIImageView+WebCache.h"

@implementation UIImageView (LoadImage)

- (void)loadImageWithPath:(NSString *)path {
    
    [self loadImageWithPath:path complete:nil];
}
- (void)loadImageWithPath:(NSString *)path complete:(void(^)(UIImage *image, NSError *error))complete {
    
    [self loadImageWithPath:path placeholderImage:[UIImage imageNamed:@"default_image"] complete:complete];
}
- (void)loadImageWithPath:(NSString *)path placeholderImage:(UIImage *)placeholder complete:(void(^)(UIImage *image, NSError *error))complete {
    
    [self sd_setImageWithURL:[NSURL URLWithString:path] placeholderImage:placeholder completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        
        !complete ? : complete(image, error);
    }];
}
@end
