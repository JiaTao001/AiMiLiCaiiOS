//
//  BuyFinanicalItemVC.h
//  YuanXin_Project
//
//  Created by Yuanin on 15/12/28.
//  Copyright © 2015年 yuanxin. All rights reserved.
//

#import "BaseViewController.h"

#import "SingleProductInfo.h"

#define BUY_FINANICAL_STORYBOARD_ID @"BuyFinanicalItemVC"

@interface BuyFinanicalItemVC : BaseViewController

@property (strong, nonatomic) SingleProductInfo *productInfo;
@property (assign, nonatomic) BOOL canIntoProductDetail;
@end
