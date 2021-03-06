//
//  RecommendProductCell.h
//  YuanXin_Project
//
//  Created by Yuanin on 16/4/19.
//  Copyright © 2016年 yuanxin. All rights reserved.
//

#import "ProductCell.h"

#import "RecommendProductInfo.h"

#define Recommend_Product_Identifier @"RecommendProductCell"

@interface RecommendProductCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *MiBaoLB;
@property (weak, nonatomic) IBOutlet UILabel *AddRateLB;

@property (weak, nonatomic) IBOutlet UILabel *rateLB;
@property (weak, nonatomic) IBOutlet UILabel *timeLB;
//@property (weak, nonatomic) IBOutlet UILabel *replyMethodLB;
//@property (weak, nonatomic) IBOutlet UILabel *moneyLB;
@property (weak, nonatomic) IBOutlet UIButton *purchase;
@property (weak, nonatomic) IBOutlet UILabel *productName;
@property (weak, nonatomic) IBOutlet UILabel *restOfShareLB;
@property (copy, nonatomic) void(^purchaseProduct)();
- (void)loadInterfactInfoWithProductInfo:(RecommendProductInfo *)aInfo;
@end
