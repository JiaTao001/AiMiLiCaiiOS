//
//  HKWebVC.h
//  YuanXin_Project
//
//  Created by Yuanin on 2017/5/11.
//  Copyright © 2017年 yuanxin. All rights reserved.
//

#import "WebVC.h"

@interface HKWebVC : WebVC
@property(assign,nonatomic)BOOL isbackRoot;
@property (copy, nonatomic) void(^FinishBlock)();
@end
