//
//  UINavigationBar+BackgroundColor.h
//  YuanXin_Project
//
//  Created by Yuanin on 15/12/24.
//  Copyright © 2015年 yuanxin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UINavigationBar (BackgroundColor)

@property (strong, nonatomic) UIView *coverView;

/**
 *  转成自定义的背景
 */
- (void)configureNavigationBar;

- (void)setCustomBackgroundColor:(UIColor *)color;
- (void)setCustomShadowColor:(UIColor *)color;
@end
