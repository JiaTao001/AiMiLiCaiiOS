//
//  PastProductsCell.m
//  YuanXin_Project
//
//  Created by Yuanin on 16/1/6.
//  Copyright © 2016年 yuanxin. All rights reserved.
//

#import "PastProductsCell.h"

@implementation PastProductsCell

- (void)awakeFromNib {
    // Initialization code
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)configureCellInfo:(NSDictionary *)aDic {
    
    self.name.text           = aDic[@"project_name"];
    self.time.text           = aDic[@"buylastdate"];
    self.yield.text          = [CommonTools convertToStringWithObject:aDic[@"annual"]];
    self.sumOflimit.text     = [CommonTools convertToStringWithObject:aDic[@"amount"]];
    self.peopleOfInvest.text = [CommonTools convertToStringWithObject:aDic[@"qty"]];
    self.productState.text   = [self productStateWithStatus:[aDic[@"status"] integerValue]];
}

- (NSString *)productStateWithStatus:(NSInteger)status {
    
    NSString *result = @"";
    
    switch (status) {
        case 3:
            result = @"已满标";
            break;
        case 4:
            result = @"已流标";
            break;
        case 5:
            result = @"还款中";
            break;
        case 6:
            result = @"即将到期";
            break;
        case 7:
            result = @"已还款";
            break;
        case 8:
            result = @"已逾期";
            break;
        case 9:
            result = @"提前结清";
            break;
    }
    return result;
}
@end
