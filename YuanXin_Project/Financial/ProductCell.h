//
//  ProductCell.h
//  YuanXin_Project
//
//  Created by Yuanin on 16/4/20.
//  Copyright © 2016年 yuanxin. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "ProductInfo.h"

typedef NS_ENUM(NSInteger, ProductCellType) {
    
    kProductCell,
    kRecommendProductCell
};

@interface ProductCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *MiBaoJiaXiLB;
@property (weak, nonatomic) IBOutlet UILabel *AddRateLB;

//@property (weak, nonatomic) IBOutlet UILabel *productName;
//@property (weak, nonatomic) IBOutlet UILabel *annualInterest;
//@property (weak, nonatomic) IBOutlet UILabel *lockPeriod;
//@property (weak, nonatomic) IBOutlet UILabel *restOfShare;
//@property (weak, nonatomic) IBOutlet UILabel *replyMethod;
//@property (weak, nonatomic) IBOutlet UILabel *guaranteeMethod;
//
//@property (weak, nonatomic) IBOutlet UIButton *purchase;
@property (weak, nonatomic) IBOutlet UILabel *annualInterestLB;
@property (weak, nonatomic) IBOutlet UILabel *timeLB;
@property (weak, nonatomic) IBOutlet UILabel *productName;
@property (weak, nonatomic) IBOutlet UIButton *purchase;
@property (weak, nonatomic) IBOutlet UILabel *restOfShareLB;

//@property (weak, nonatomic) IBOutlet UILabel *replyMethod;
//@property (weak, nonatomic) IBOutlet UILabel *moneyLB;

@property (copy, nonatomic) void(^purchaseProduct)();

- (void)loadInterfactInfoWithProductInfo:(ProductInfo *)aInfo;
@end
