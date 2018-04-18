//
//  GestureFinishedAnimation.m
//  YuanXin_Project
//
//  Created by Yuanin on 16/2/4.
//  Copyright © 2016年 yuanxin. All rights reserved.
//

#import "GestureFinishedAnimation.h"
#import "AppDelegate.h"

#define CACHE_IMAGE_KEY @"cacheImage"

@implementation GestureFinishedAnimation

+ (void)beginAnimationWithView:(UIView *)view slicingY:(NSInteger)slicingY complete:(void(^)())completeBlock {
    
    CGFloat realSlicingY = slicingY + (IS_HOTSPOT_CONNECTED ? HOTSPOT_STATUSBAR_HEIGHT : 0);
    //ImageView
    CGRect upRect = CGRectMake(0, 0, view.width, realSlicingY);
    CGRect downRect = CGRectMake(0, realSlicingY, view.width, view.height - realSlicingY);
    
    UIImageView *upImageView = [[UIImageView alloc] initWithImage:[self imageWithView:view captureRect:upRect]];
    UIImageView *downImageView = [[UIImageView alloc] initWithImage:[self imageWithView:view captureRect:downRect]];

    upRect.origin.y   += IS_HOTSPOT_CONNECTED ? HOTSPOT_STATUSBAR_HEIGHT : 0;
    downRect.origin.y += IS_HOTSPOT_CONNECTED ? HOTSPOT_STATUSBAR_HEIGHT : 0;
    //
    upImageView.frame   = upRect;
    downImageView.frame = downRect;
    
    //LineView
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(view.center.x, realSlicingY + (IS_HOTSPOT_CONNECTED ? HOTSPOT_STATUSBAR_HEIGHT : 0), 1, 1)];
    lineView.backgroundColor = [UIColor whiteColor];
    
    [( (AppDelegate *)[UIApplication sharedApplication].delegate).window addSubview:upImageView];
    [( (AppDelegate *)[UIApplication sharedApplication].delegate).window addSubview:downImageView];
    [( (AppDelegate *)[UIApplication sharedApplication].delegate).window addSubview:lineView];
    
    [UIView animateWithDuration:2*NORMAL_ANIMATION_DURATION animations:^{
        lineView.frame = CGRectMake(0, lineView.center.y, view.width, 1);
    } completion:^(BOOL finished) {
        
        [UIView animateWithDuration:2*NORMAL_ANIMATION_DURATION animations:^{
            lineView.alpha = 0;
            lineView.frame = CGRectMake(0, 0, view.width, view.height);
            upImageView.frame = CGRectMake(0, -upImageView.height, upImageView.width, upImageView.height);
            downImageView.frame = CGRectMake(0, UISCREEN_HEIGHT, downImageView.width, downImageView.height);
        } completion:^(BOOL finished) {
            
            [upImageView removeFromSuperview];
            [downImageView removeFromSuperview];
            [lineView removeFromSuperview];
            PerformEmptyParameterBlock(completeBlock);
        }];
    }];
}

+ (UIImage *)imageWithView:(UIView *)view captureRect:(CGRect)rect {
    UIImage *result = [UIImage imageWithContentsOfFile:[AiMiApplication pathForCachesWithFileName:NSStringFromCGRect(rect)]];
    
    if (!result) {
        result = [self createImageWithView:view captureRect:rect];
        dispatch_async(dispatch_queue_create(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            if ([UIImageJPEGRepresentation(result, 0.5) writeToFile:[AiMiApplication pathForCachesWithFileName:NSStringFromCGRect(rect)] atomically:YES]) {
                
                NSMutableArray *cacheImages = [[NSMutableArray alloc] initWithArray:[USERDEFAULTS objectForKey:CACHE_IMAGE_KEY]];
                [cacheImages addObject:NSStringFromCGRect(rect)];
                [USERDEFAULTS setValue:cacheImages forKey:CACHE_IMAGE_KEY];
                [USERDEFAULTS synchronize];
            }
        });
    }
    return result;
}
//+ (UIImage *)downImageWithView:(UIView *)view captureRect:(CGRect)rect {
//    UIImage *result = [UIImage imageWithContentsOfFile:[AiMiApplication pathForCachesWithFileName:Down_Image_Name]];
//    
//    if (!result) {
//        result = [self createImageWithView:view captureRect:rect];
//        dispatch_async(dispatch_queue_create(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//            [UIImagePNGRepresentation(result) writeToFile:[AiMiApplication pathForCachesWithFileName:Down_Image_Name] atomically:YES];
//        });
//    }
//    return result;
//}

+ (UIImage *)createImageWithView:(UIView *)view captureRect:(CGRect)rect {
    
    UIGraphicsBeginImageContextWithOptions(view.frame.size, YES, [UIScreen mainScreen].scale);
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
    CGContextSaveGState(ctx);
    
    UIRectClip(rect);
    [view.layer renderInContext:ctx];
    
    CGRect scaleRect = CGRectMake(rect.origin.x*[UIScreen mainScreen].scale, rect.origin.y*[UIScreen mainScreen].scale, rect.size.width*[UIScreen mainScreen].scale, rect.size.height*[UIScreen mainScreen].scale);
    CGImageRef newImageRef = CGImageCreateWithImageInRect(UIGraphicsGetImageFromCurrentImageContext().CGImage, scaleRect);
    
    UIImage *result = [UIImage imageWithCGImage:newImageRef]; CGImageRelease(newImageRef);
    
    CGContextRestoreGState(ctx);
    UIGraphicsEndImageContext();

    return result;
}


+ (void)removeCacheGestureImage {
    
    NSFileManager *manager = [NSFileManager defaultManager];
    
    for (NSString *imageName in [USERDEFAULTS objectForKey:CACHE_IMAGE_KEY]) {
        if ([manager fileExistsAtPath:[AiMiApplication pathForCachesWithFileName:imageName]]) {
            [manager removeItemAtPath:[AiMiApplication pathForCachesWithFileName:imageName] error:nil];
        }
    }

}
@end
