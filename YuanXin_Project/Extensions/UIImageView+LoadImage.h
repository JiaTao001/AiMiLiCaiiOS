//
//  UIImageView+LoadImage.h
//  YouRong_Project
//
//  Created by Yuanin on 16/6/2.
//  Copyright © 2016年 YouRong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImageView (LoadImage)

- (void)loadImageWithPath:(NSString *)path;
- (void)loadImageWithPath:(NSString *)path complete:(void(^)(UIImage *image, NSError *error))complete;
- (void)loadImageWithPath:(NSString *)path placeholderImage:(UIImage *)placeholder complete:(void(^)(UIImage *image, NSError *error))complete;

@end
