//
//  UIViewController+NavigationItem.h
//  YuanXin_Project
//
//  Created by Sword on 15/9/14.
//  Copyright (c) 2015年 yuanxin. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^SELBlock)(__kindof UIViewController *viewController);

#define Nav_Back_Image @"back"

@interface UIViewController (NavigationItem)

@property (copy, nonatomic) SELBlock leftAction;
@property (copy, nonatomic) SELBlock rightAction;
/**
 @brief navigation left bar of image.
 */
- (UIButton *)layoutNavigationLeftButtonWithImage:(UIImage *)image block:(SELBlock)block;

/**
 @brief navigation right bar of image.
 */
- (UIButton *)layoutNavigationRightButtonWithImage:(UIImage *)image block:(SELBlock)block;

/**
 @brief navigation right bar of text.
 */
- (UIButton *)layoutNavigationRightButtonWithTitle:(NSString *)text color:(UIColor *)color block:(SELBlock)block;

- (UIButton *)layoutNavigationButton:(BOOL)left title:(NSString *)text color:(UIColor *)color action:(SEL)action;

@end
