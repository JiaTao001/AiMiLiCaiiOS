//
//  RegularEntrustVC.h
//  YuanXin_Project
//
//  Created by Yuanin on 16/5/3.
//  Copyright © 2016年 yuanxin. All rights reserved.
//

#import "BaseViewController.h"

#define To_Regular_Entrust_Segue_Identifier @"To_RegularEntrustVC"

@interface RegularEntrustVC : BaseViewController

@property (copy, nonatomic) void(^entrustSuccess)();
@property (nonatomic,strong)NSDictionary *dataDic;
@end
