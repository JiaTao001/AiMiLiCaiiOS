//
//  UIViewController+NavigationBarAnimation.m
//  YuanXin_Project
//
//  Created by Yuanin on 16/9/6.
//  Copyright © 2016年 yuanxin. All rights reserved.
//

#import "NavigationBarAnimation.h"

#import "TransitionAnimation.h"
#import "InteractiveTransition.h"
#import "UINavigationBar+BackgroundColor.h"


@interface NavigationBarAnimation ()

@property (strong, nonatomic) InteractiveTransition *interactiveTransition;
@property (strong, nonatomic) TransitionAnimation *transitionAnimation;
@end

@implementation NavigationBarAnimation

#pragma mark - NavigationControllerDelegate

- (id<UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController animationControllerForOperation:(UINavigationControllerOperation)operation fromViewController:(UIViewController *)fromVC toViewController:(UIViewController *)toVC
{
    self.transitionAnimation.operation = operation;
    return self.transitionAnimation;
}
- (id<UIViewControllerInteractiveTransitioning>)navigationController:(UINavigationController *)navigationController interactionControllerForAnimationController:(TransitionAnimation *)animationController
{
    return self.interactiveTransition.panInterActiveTransition;
}

- (void)navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    self.interactiveTransition.viewController = viewController;
    navigationController.navigationBar.coverView.alpha = [self.transitionAnimation navigationBarAlphaForViewController:viewController];
}


#pragma mark - Getter
- (InteractiveTransition *)interactiveTransition
{
    if (!_interactiveTransition)
    {
        _interactiveTransition = [[InteractiveTransition alloc] init];
    }
    return _interactiveTransition;
}
- (TransitionAnimation *)transitionAnimation
{
    if (!_transitionAnimation)
    {
        _transitionAnimation = [[TransitionAnimation alloc] init];
    }
    return _transitionAnimation;
}
@end
