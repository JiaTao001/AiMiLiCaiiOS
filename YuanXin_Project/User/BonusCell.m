//
//  BonusCell.m
//  YuanXin_Project
//
//  Created by Yuanin on 16/4/27.
//  Copyright © 2016年 yuanxin. All rights reserved.
//

#import "BonusCell.h"

@implementation BonusCell

- (void)configureCellWithInfo:(NSDictionary *)aDic {
    [super configureCellWithInfo:aDic];
    
    NSInteger status = [aDic[@"status"] integerValue];
    
    self.rewardExplain.text     = aDic[@"content"];
    self.minInvestAmount.text   = [NSString stringWithFormat:@"%@元", [CommonTools convertToStringWithObject:aDic[@"min_invest_amount"]]];
    if (status == 0) {
        self.rewardBakcground.image = [UIImage imageNamed:@"bouns_backImage"];
    }
    if (status == 1) {
        self.rewardBakcground.image = [UIImage imageNamed:@"used_backImage"];
    }
    if (status == 2) {
        self.rewardBakcground.image = [UIImage imageNamed:@"overdate_backImage"];
    }
//    self.rewardBakcground.image = [UIImage imageNamed:0 == status ? @"bouns_backImage" : @"used_backImage"];
    
    self.money.textColor           = 0 == status ? Theme_Color : RGB(0xCCCCCC);
//    self.name.textColor            = self.money.textColor;
    self.minInvestAmount.textColor = self.money.textColor;
    self.symbol.textColor          = self.money.textColor;
    self.unit.textColor            = self.money.textColor;
    self.time.textColor            = 0 == status ? RGB(0x666666) : RGB(0xCCCCCC);
    self.rewardExplain.textColor   = self.time.textColor;
    self.moneyTitle.textColor      = self.time.textColor;
}


@end
