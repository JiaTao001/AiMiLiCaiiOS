//
//  PropertyInformationCell.m
//  YuanXin_Project
//
//  Created by Yuanin on 15/10/29.
//  Copyright © 2015年 yuanxin. All rights reserved.
//

#define Type @"type"
#define Interest_Rate @"年化收益率："

#import "PropertyInformationCell.h"

@implementation PropertyInformationCell

- (void)awakeFromNib {
    // Initialization code
    [super awakeFromNib];
    
    if ([self respondsToSelector:@selector(layoutMargins)]) {
        self.layoutMargins = UIEdgeInsetsZero;
    } else {
        self.separatorInset = UIEdgeInsetsZero;
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)loadCellWithModel:(PropertyInfo *)info {
    
    if (!info && ![info isMemberOfClass:[PropertyInfo class]]) return;

    self.name.text          = info.productName;
    self.money.text         = info.investMoney;
    self.buyTime.text       = info.createdTime;
    self.sumIncome.text     = info.interest;
    self.maturityTime.text  = info.expireTime;
    self.restOfTheTime.text = info.restOfTheTime;
    self.propertyState.text = info.propertyState;
    self.propertySign.image = [UIImage imageNamed:info.propertySignImageName];
}

- (void)setInThePayment:(BOOL)inThePayment {
    _inThePayment = inThePayment;
    
    self.restOfTheTime.hidden = self.restOfTheTimeTitle.hidden = !inThePayment;
}

@end
