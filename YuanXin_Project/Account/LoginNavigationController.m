//
//  LoginNavigationController.m
//  YuanXin_Project
//
//  Created by Sword on 15/9/22.
//  Copyright © 2015年 yuanxin. All rights reserved.
//

#import "LoginNavigationController.h"
#import "UINavigationBar+BackgroundColor.h"
#import "RegisterViewController.h"
#import "UMessage.h"

@interface LoginNavigationController ()

@property (nonatomic, copy) LoginResult loginResult;
@end

@implementation LoginNavigationController

- (void)viewDidLoad
{
    [super viewDidLoad];
   
}


- (void)setLoginResult:(LoginResult) loginResult
{
    if (_loginResult == loginResult) {
        return;
    }
    _loginResult = [loginResult copy];
}

- (void)dismissLoginSuccess:(BOOL) success completion:(void(^)(void)) completion
{
    !self.loginResult ? : self.loginResult( success);
    if (success) {
        [UMessage setAlias:[UserinfoManager sharedUserinfo].userInfo.userid type:UM_Alias_Type response:nil];
    }
    
    [self dismissViewControllerAnimated:YES completion:completion];
}

- (void)changeRootViewControllerForRegister
{
    [self setViewControllers:@[[AiMiApplication obtainControllerForStoryboard:LOGIN_STORYBOARD_NAME controller:NSStringFromClass([RegisterViewController class])]]];
}

@end
