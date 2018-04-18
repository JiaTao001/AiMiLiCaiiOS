//
//  TransitionAnimation.h
//  YuanXin_Project
//
//  Created by Yuanin on 15/12/29.
//  Copyright © 2015年 yuanxin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TransitionAnimation : NSObject <UIViewControllerAnimatedTransitioning>

@property (assign, nonatomic) UINavigationControllerOperation operation;

- (instancetype)initWithOperation:(UINavigationControllerOperation)operation;
+ (instancetype)transitionAnimation:(UINavigationControllerOperation)operation;


- (CGFloat)navigationBarAlphaForViewController:(UIViewController *)viewController;
@end
