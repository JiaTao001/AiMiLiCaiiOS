//
//  UIViewController+NavigationBarAnimation.h
//  YuanXin_Project
//
//  Created by Yuanin on 16/9/6.
//  Copyright © 2016年 yuanxin. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol NavigationBarAnimationDateSource <NSObject>

- (CGFloat)navigationBarAlpha;

@end

@interface NavigationBarAnimation:NSObject <UINavigationControllerDelegate>

@end
