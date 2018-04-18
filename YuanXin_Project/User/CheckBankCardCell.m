//
//  BankCardCell.m
//  YuanXin_Project
//
//  Created by Yuanin on 16/7/12.
//  Copyright © 2016年 yuanxin. All rights reserved.
//

#import "CheckBankCardCell.h"

@implementation CheckBankCardCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (void)configureCellWithDictionary:(NSDictionary *)aDic {

    [self.bankCardLogo loadImageWithPath:aDic[@"logo"]];
    self.bankName.text = aDic[@"full_name"];
    self.bankCardNumber.text = aDic[@"card_no"];
    self.phoneNumLB.text = aDic[@"mobile"];
//    self.bankType.text = [self isSafeCard:aDic[@"is_safe"]] ? @"安全卡" : @"支付卡";
    self.unbindButton.hidden = NO;
}
//- (BOOL)isSafeCard:(NSString *)str {
//    
//    return [@"Y" isEqualToString:str];
//}
- (IBAction)unbind:(id)sender {
    
//    PerformEmptyParameterBlock(self.unbindBankCard);
    if (self.unbindBankCard) {
        self.unbindBankCard(1);
    }
}
- (IBAction)phonechange:(id)sender {
//     PerformEmptyParameterBlock(self.unbindBankCard(2));
    if (self.unbindBankCard) {
        self.unbindBankCard(2);
    }
}

@end
