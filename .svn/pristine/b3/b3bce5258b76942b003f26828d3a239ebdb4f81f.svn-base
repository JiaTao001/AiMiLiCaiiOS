//
//  PropertyDetailDownCell.m
//  YuanXin_Project
//
//  Created by Yuanin on 16/7/14.
//  Copyright © 2016年 yuanxin. All rights reserved.
//

#import "PropertyDetailDownCell.h"

@implementation PropertyDetailDownCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)configureCellWithDictionary:(NSDictionary *)aDic {
    
    self.notRepaymentCapital.text = [CommonTools convertToStringWithObject:aDic[@"capital_wait"]];
    self.didRepaymentCapital.text = [CommonTools convertToStringWithObject:aDic[@"capital_yes"]];
    self.notRepaymentInterest.text = [CommonTools convertToStringWithObject:aDic[@"interest_wait"]];
    self.didRepaymentInterest.text = [CommonTools convertToStringWithObject:aDic[@"interest_yes"]];
}

@end
