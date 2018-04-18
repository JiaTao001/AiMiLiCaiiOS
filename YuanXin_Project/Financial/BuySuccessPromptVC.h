//
//  BuySuccessPromptVCViewController.h
//  YuanXin_Project
//
//  Created by Yuanin on 16/1/19.
//  Copyright © 2016年 yuanxin. All rights reserved.
//

#import "BaseViewController.h"

#define PROMPT_STORYBOARD_ID @"BuySuccessPromptVC"

#define Product_Name      @"product_name"
#define Indent_Money      @"indent_money"
#define Platform_Reward   @"platform_reward"


@interface BuySuccessPromptVC : BaseViewController

@property (strong, nonatomic) NSDictionary *buyProductInfo;
@end
