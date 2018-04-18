//
//  PropertyDetailUpCell.m
//  YuanXin_Project
//
//  Created by Yuanin on 16/7/14.
//  Copyright © 2016年 yuanxin. All rights reserved.
//

#import "PropertyDetailUpCell.h"

@implementation PropertyDetailUpCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)configureCellWithDictionary:(NSDictionary *)aDic {

    self.investMoney.text = [NSString stringWithFormat:@"%@元", aDic[@"amount"]];
    self.investInterestRate.text = [CommonTools convertToStringWithObject:aDic[@"annual"]];
    self.totalRevenue.text = [NSString stringWithFormat:@"%@元", aDic[@"interest_total"]];
    self.projektdauer.text = [CommonTools convertToStringWithObject:aDic[@"term"]];
    self.paymentMethod.text = [CommonTools convertToStringWithObject:aDic[@"repay_method"]];
}

@end
