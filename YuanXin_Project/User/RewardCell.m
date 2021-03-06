//
//  RewardCell.m
//  YuanXin_Project
//
//  Created by Yuanin on 16/1/15.
//  Copyright © 2016年 yuanxin. All rights reserved.
//

#import "RewardCell.h"

@implementation RewardCell

- (void)awakeFromNib {
    // Initialization code
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

//返回值 list id（用户领取红包、体验金id）、name（名称）、amount（金额）、min_invest_amount（最小投资额度；0表示不限）、startdate（有效期开始日期）、expirydate（有效期结束日期）、status（0表示未使用；1表示已使用；2表示已过期）、usetime（使用时间；有可能没有值）
//     did_user no_user out_of_date

- (IBAction)useExoperient:(UIButton *)sender {
    
    if (self.useExperienceBlock) {
        self.useExperienceBlock();
    }
}

//- (void)setRewardState:(UILabel *)rewardState {
//    _rewardState = rewardState;
//    
//    _rewardState.attributedText = [self changeParagraphStyle:rewardState.text];
//}

- (void)configureCellWithInfo:(NSDictionary *)aDic {
    
//    self.name.text = aDic[@"name"];
    self.money.text = [CommonTools convertToStringWithObject:aDic[@"amount"]];
    self.time.text = [NSString stringWithFormat:@"有效期至%@", aDic[@"expirydate"]];
    
    NSInteger status = [aDic[@"status"] integerValue];

//    self.rewardState.attributedText = [self changeParagraphStyle:[self rewardStateDescriptionWithState:status]];
//    self.rewardState.textColor = 0 == status ? [UIColor whiteColor] : RGB(0xCCCCCC);
}

- (NSString *)rewardStateDescriptionWithState:(NSInteger)state {
    
    switch (state) {
        case 0:
            return @"未使用";
            break;
        case 1:
            return @"已使用";
            break;
        case 2:
            return @"已过期";
            break;
            
        default:
            return @"未定义";
    }
}
- (NSAttributedString *)changeParagraphStyle:(NSString *)string {
    
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:string];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    
    [paragraphStyle setLineSpacing:10];//调整行间距
    
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [string length])];
    
    return attributedString;
}

@end
