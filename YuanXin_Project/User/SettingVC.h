//
//  SettingTVC.h
//  YuanXin_Project
//
//  Created by Yuanin on 15/10/10.
//  Copyright © 2015年 yuanxin. All rights reserved.
//

#import "BaseViewController.h"

#define SETTING_SEGUE_IDENTIFIER @"ToPersonCenter"

@interface SettingVC : BaseViewController

- (void)setLogoutCallBack:( void(^)() ) callBack;
@end