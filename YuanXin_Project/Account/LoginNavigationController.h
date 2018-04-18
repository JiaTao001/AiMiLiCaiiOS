//
//  LoginNavigationController.h
//  YuanXin_Project
//
//  Created by Sword on 15/9/22.
//  Copyright © 2015年 yuanxin. All rights reserved.
//

#import "BaseNavigationController.h"

#define LOGIN_NAVIGARION_STORYBOARD_ID @"LoginNavigationController"
#define LOGIN_STORYBOARD_NAME @"Login"

typedef void (^LoginResult)(BOOL success);

@interface LoginNavigationController : BaseNavigationController

- (void)dismissLoginSuccess:(BOOL) success completion:(void(^)(void)) completion;

- (void)changeRootViewControllerForRegister;
@end
