//
//  TransitionAnimation.m
//  YuanXin_Project
//
//  Created by Yuanin on 15/12/29.
//  Copyright © 2015年 yuanxin. All rights reserved.
//

#import "TransitionAnimation.h"

#import "NavigationBarAnimation.h"
#import "UINavigationBar+BackgroundColor.h"

@implementation TransitionAnimation

- (instancetype)initWithOperation:(UINavigationControllerOperation)operation {
    
    self = [super init];
    if (self) {
        
        if (UINavigationControllerOperationPop == operation || UINavigationControllerOperationPush == operation) {
            _operation = operation;
        } else {
            return nil;
        }
    }
    
    return self;
}
+ (instancetype)transitionAnimation:(UINavigationControllerOperation)operation {
    
    return [[TransitionAnimation alloc] initWithOperation:operation];
}

- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext {
    
    return NORMAL_ANIMATION_DURATION;
}

- (void)animateTransition:( id<UIViewControllerContextTransitioning> ) transitionContext {
    
    switch (self.operation) {
        case UINavigationControllerOperationPush:
            [self pushAnimation:transitionContext];
            break;
            
        case UINavigationControllerOperationPop:
            [self popAnimtaion:transitionContext];
            break;
        default:
            break;
    }
}

- (void)pushAnimation:( id<UIViewControllerContextTransitioning> ) transitionContext {
    
    UIViewController *fromVC = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController *toVC   = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    
    [transitionContext.containerView addSubview:toVC.view];

    CGRect nextToFrame = fromVC.view.frame;
    
    CGRect currentToFrame = nextToFrame;
    currentToFrame.origin.x = -currentToFrame.size.width/4;
    
    CGRect nextStartFrame = nextToFrame;
    nextStartFrame.origin.x = transitionContext.containerView.width;
    toVC.view.frame = nextStartFrame;

    fromVC.navigationController.navigationBar.coverView.alpha = [self navigationBarAlphaForViewController:fromVC];
    UINavigationBar *navigationBar = fromVC.navigationController.navigationBar;
    
    for (NSLayoutConstraint *constraint in toVC.view.constraints) {
        if (constraint.firstItem == toVC.topLayoutGuide
            && constraint.firstAttribute == NSLayoutAttributeHeight
            && constraint.secondItem == nil
            && constraint.constant < navigationBar.height) {
            
            constraint.constant += navigationBar.height;
        }
    }
    
    [UIView animateWithDuration:[self transitionDuration:transitionContext] delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        
        fromVC.view.frame = currentToFrame;
        toVC.view.frame = nextToFrame;
        navigationBar.coverView.alpha = [self navigationBarAlphaForViewController:toVC];
    } completion:^(BOOL finished) {
        
        [transitionContext completeTransition:YES];
    }];
}

- (void)popAnimtaion:(id<UIViewControllerContextTransitioning>)transitionContext {
    
    UIViewController *fromVC = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController *toVC   = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    
    [transitionContext.containerView insertSubview:toVC.view belowSubview:fromVC.view];
    
    CGRect nextEndFrame = fromVC.view.frame;
    
    CGRect fromEndFrame   = fromVC.view.frame;
    fromEndFrame.origin.x = transitionContext.containerView.width;
    
    CGRect nextStartFrame = nextEndFrame;
    nextStartFrame.origin.x = -nextStartFrame.size.width/4;
    toVC.view.frame = nextStartFrame;

    fromVC.navigationController.navigationBar.coverView.alpha = [self navigationBarAlphaForViewController:fromVC];
    UINavigationBar *navigationBar = toVC.navigationController.navigationBar;
    
    for (NSLayoutConstraint *constraint in toVC.view.constraints) {
        if (constraint.firstItem == toVC.topLayoutGuide
            && constraint.firstAttribute == NSLayoutAttributeHeight
            && constraint.secondItem == nil
            && constraint.constant < navigationBar.height) {
            
            constraint.constant += navigationBar.height;
        }
    }
    
    UIImageView *shadowImageView = [self shadowImageView];
    shadowImageView.alpha = 0.3;
    if (toVC.tabBarController.tabBar.hidden) {
        [fromVC.view addSubview:shadowImageView];
        shadowImageView.frame = CGRectMake(-shadowImageView.width, 0, shadowImageView.width, UISCREEN_HEIGHT);
    } else {
        [toVC.tabBarController.tabBar addSubview:shadowImageView];
        shadowImageView.frame = CGRectMake(UISCREEN_WIDTH - shadowImageView.width,
                                           -UISCREEN_HEIGHT + TABBAR_HEIGHT + ([self navigationBarAlphaForViewController:toVC] ? STATUS_AND_NAV_BAR_HEIGHT : 0),
                                           shadowImageView.width,
                                           UISCREEN_HEIGHT);
    }
    
    [UIView animateWithDuration:[self transitionDuration:transitionContext] delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
        
        fromVC.view.frame = fromEndFrame;
        toVC.view.frame = nextEndFrame;
        navigationBar.coverView.alpha = [self navigationBarAlphaForViewController:toVC];
        shadowImageView.alpha = 0.1;
    } completion:^(BOOL finished) {
        
        [shadowImageView removeFromSuperview];
        [transitionContext completeTransition:![transitionContext transitionWasCancelled]];
    }];
}

- (CGFloat)navigationBarAlphaForViewController:(UIViewController *)viewController {
    
    return [viewController conformsToProtocol:@protocol(NavigationBarAnimationDateSource)] ? ((id<NavigationBarAnimationDateSource>)viewController).navigationBarAlpha : 1;
}

- (UIImageView *)shadowImageView {
    static UIImageView *result = nil;
    
    if (nil == result) {
        result = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"gradient_alpha_black"]];
    }
    
    return result;
}

@end
