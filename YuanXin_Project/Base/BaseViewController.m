//
//  BaseViewController.m
//  YuanXin_Project
//
//  Created by Yuanin on 16/9/6.
//  Copyright © 2016年 yuanxin. All rights reserved.
//

#import "BaseViewController.h"

#import "UINavigationBar+BackgroundColor.h"
#import "TransitionAnimation.h"
#import "InteractiveTransition.h"

@interface BaseViewController ()

@property (assign, nonatomic, readwrite) BOOL didShow;
@end

@implementation BaseViewController

#pragma mark - Life Cycle 
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    if (!self.view.backgroundColor) {
        self.view.backgroundColor = Background_Color;
    }
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.extendedLayoutIncludesOpaqueBars = YES;
    
    self.navigationBarAlpha = 1.0f;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    self.didShow = YES;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    self.didShow = NO;
    [self.view endEditing:YES];
}

#pragma mark - Action
- (void)hideNavigationBar
{
    self.navigationController.navigationBarHidden = YES;
    self.navigationController.navigationBar.coverView.alpha = 0;
}

- (void)showNavigationBar
{
    self.navigationController.navigationBarHidden = NO;
}

- (void)changeNavigationBarAlpha:(CGFloat)navigationBarAlpha
{
    self.navigationBarAlpha = navigationBarAlpha;
    self.navigationController.navigationBar.coverView.alpha = navigationBarAlpha;
}

#ifdef DEBUG
- (void)dealloc {
    
    debugMethod();
}
#endif


@end
