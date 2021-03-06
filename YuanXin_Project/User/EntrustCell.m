//
//  EntrustCell.m
//  YuanXin_Project
//
//  Created by Yuanin on 16/5/3.
//  Copyright © 2016年 yuanxin. All rights reserved.
//

#import "EntrustCell.h"

@implementation EntrustCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)loadInterfaceWithDictionary:(NSDictionary *)aDic {
//方案名称
    self.entrustName.text     = aDic[@"remark"];
    
//投资期限
    NSString *min_unit = aDic[@"min_unit"];
     NSString *max_unit = aDic[@"max_unit"];
    if ([min_unit isEqualToString:max_unit]) {
        if ([min_unit isEqualToString:@"0"]) {
            self.investTime.text      = @"不限";
        }else{
            self.investTime.text      = [NSString stringWithFormat:@"%@个月",min_unit];
        }
    }else{
        if ([min_unit isEqualToString:@"0"]) {
            self.investTime.text      = [NSString stringWithFormat:@"1个月～%@个月",max_unit];
        }else{
            self.investTime.text      = [NSString stringWithFormat:@"%@个月～%@个月",min_unit,max_unit];
        }
    }
// 年化收益
    NSString *min_annual = aDic[@"min_annual"];
    NSString *max_annual = aDic[@"max_annual"];
    
    if ([min_annual isEqualToString:max_annual]) {
        if ([min_annual isEqualToString:@"0"]) {
            self.annual.text      = @"不限";
        }else{
            self.annual.text      = [NSString stringWithFormat:@"%@%%",min_annual];
        }
    }else{
        if ([min_annual isEqualToString:@"0"]) {
            self.annual.text      = [NSString stringWithFormat:@"1%%～%@%%",max_annual];
        }else{
            self.annual.text      = [NSString stringWithFormat:@"%@%%～%@%%",min_annual,max_annual];
        }
    }
  

//投资方式
    if ([aDic[@"all_amount"] integerValue] == 0) {
         self.startTime.text       = @"固定单笔出借金额";
        self.money.hidden = NO;
        self.touzijineLB.hidden = NO;
         self.money.text = aDic[@"amount"];
    }else{
        self.startTime.text       = @"账户余额全部出借";
        self.money.hidden = YES;
        self.touzijineLB.hidden = YES;
    }
   
//是否适用优惠券
    if ([aDic[@"is_red"] integerValue]== 0) {
         self.amount.text          = @"不使用";
    }else{
         self.amount.text          = @"使用";
    }

   
//    self.entrustSwitch.hidden = NO;
    if ([aDic[@"status"] integerValue] == 0) {
        self.entrustSwitch.on  = YES;
    }else{
        self.entrustSwitch.on  = NO;
    }
   
}

- (IBAction)changeEntrustState:(UISwitch *)sender {
    
    if (self.changeStateBlock) {
        self.changeStateBlock(sender);
    }
}


@end
