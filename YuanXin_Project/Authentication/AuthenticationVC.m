//
//  AuthenticationVC.m
//  YuanXin_Project
//
//  Created by Yuanin on 16/7/8.
//  Copyright © 2016年 yuanxin. All rights reserved.
//

#import "AuthenticationVC.h"

#import "CertificationVC.h"

#import "TradePasswordVC.h"
#import "BindBankCardVC.h"
@interface AuthenticationVC ()

@property (strong, nonatomic) UIViewController *currentViewController;
@property (strong, nonatomic) UIViewController *tmpNextViewController;

@property (copy, nonatomic) void(^callBack)();
@end

@implementation AuthenticationVC

- (instancetype)initWithCancelCallBack:(void(^)())callBack
{
    self = [super init];
    if (self) {
        self.hidesBottomBarWhenPushed = YES;
        _callBack = callBack;
    }
    return self;
}

- (instancetype)init
{
    if (self = [super init]) {
        self.hidesBottomBarWhenPushed = YES;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    if (self.status == 2) {
        [self changeRootViewControllerToViewControoler:[AiMiApplication obtainControllerForStoryboard:@"Auth" controller:TRADEPSD_SETUP_STORYBOARD_ID]];
    }else if(self.status == 3){
        [ self   changeRootViewControllerToViewControoler:[AiMiApplication obtainControllerForStoryboard:@"Auth" controller:BIND_BANK_CARD_STORYBOARD_ID]];
    }else{

    [self transitionToViewController:[AiMiApplication obtainControllerForStoryboard:@"Auth" controller:NSStringFromClass([CertificationVC class])]];
    }
}
- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    if (self.tmpNextViewController) {
        [self  transitionToViewController:self.tmpNextViewController];
    }
}
- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    PerformEmptyParameterBlock(self.callBack);
}

#pragma mark - Setter
- (void)transitionToViewController:(UIViewController *)viewController
{
    if (!viewController || _currentViewController == viewController) return;
    
    self.tmpNextViewController = viewController;
    if (_currentViewController) {
        
        [self addChildViewController:viewController];
        [self transitionFromViewController:_currentViewController toViewController:viewController duration:1.0f options:UIViewAnimationOptionTransitionFlipFromRight animations:nil completion:^(BOOL finished) {
            
            if (finished) {
                [self finishTransition];
            }
        }];
    } else {
        
        [self addChildViewController:viewController];
        [self.view addSubview:viewController.view];

        [self finishTransition];
    }
}
- (void)finishTransition
{
    [self copyNavigationItem:self.tmpNextViewController];
    [self.currentViewController removeFromParentViewController];
    self.currentViewController = self.tmpNextViewController;
    self.tmpNextViewController = nil;
}

- (void)copyNavigationItem:(UIViewController *)viewController
{
    self.navigationItem.title = viewController.navigationItem.title;
    self.navigationItem.rightBarButtonItem = viewController.navigationItem.rightBarButtonItem;
    self.navigationItem.leftBarButtonItem = viewController.navigationItem.leftBarButtonItem;
}


- (void)changeRootViewControllerToViewControoler:(UIViewController *)viewController
{
    if (self.view.window) {
        [self transitionToViewController:viewController];
    } else {
        self.tmpNextViewController = viewController;
    }
}

@end
