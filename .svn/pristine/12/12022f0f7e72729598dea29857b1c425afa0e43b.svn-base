//
//  BaseViewController.h
//  YuanXin_Project
//
//  Created by Yuanin on 16/9/6.
//  Copyright © 2016年 yuanxin. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "NavigationBarAnimation.h"

@interface BaseViewController : UIViewController <NavigationBarAnimationDateSource>

@property (assign, nonatomic, readonly) BOOL didShow;

@property (nonatomic, assign) IBInspectable CGFloat navigationBarAlpha; /**< 不改变bar的alpha */

- (void)changeNavigationBarAlpha:(CGFloat)navigationBarAlpha;

/**
 *  隐藏以后将 coverView的透明度设为0
 */
- (void)hideNavigationBar;
- (void)showNavigationBar;
@end
