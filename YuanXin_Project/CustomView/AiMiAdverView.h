//
//  AiMiAdverView.h
//  YuanXin_Project
//
//  Created by Yuanin on 17/1/17.
//  Copyright © 2017年 yuanxin. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import "BaseViewController.h"

@interface AiMiAdverView :UIViewController
@property (copy, nonatomic) void(^completionBlock)(BOOL AdverIsShow);
@property (assign,nonatomic)NSArray *data;
+ (BOOL)canShow;

@end
