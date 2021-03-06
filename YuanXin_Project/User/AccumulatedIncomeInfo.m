//
//  AccumulatedIncomeInfo.m
//  YuanXin_Project
//
//  Created by Yuanin on 15/10/29.
//  Copyright © 2015年 yuanxin. All rights reserved.
//

#import "AccumulatedIncomeInfo.h"

@implementation AccumulatedIncomeInfo

+ (instancetype)accumulatedIncomeInfoWithDictionary:(NSDictionary *)aDic {
    
    return [[AccumulatedIncomeInfo alloc] initWithDictionary:aDic];
}
- (instancetype)initWithDictionary:(NSDictionary *)aDic {
    self = [super init];
    
    if (self) {
        
        _interest  = [CommonTools convertToStringWithObject:aDic[@"interest"]];
        _periodqty = [CommonTools convertToStringWithObject:aDic[@"periodqty"]];

        _repayTime = aDic[@"repay_time"];
        _name      = aDic[@"project_name"];
        
        switch ([aDic[@"status"] integerValue]) {
            case 0://逾期
                _incomeState = @"已逾期";
                _incomeStateColor = Font_Shallow_Gray;
                break;
            case 1://待还款
                _incomeState = @"待还款";
                _incomeStateColor = Theme_Color;
                break;
            case 2://即将到期
                _incomeState = @"即将到期";
                _incomeStateColor = RGB(0x30c4d1);
                break;
            case 3://已还款
                _incomeState = @"已还款";
                _incomeStateColor = Font_Shallow_Gray;
                break;
            case 4://提前还款
                _incomeState = @"提前结清";
                _incomeStateColor = Font_Orange_Gray;
                break;
        }
       
    }
    return self;
}

- (NSString *)periodqty {
    if (_periodqty && _periodqty.length) {
        return [NSString stringWithFormat:@"%@期", _periodqty];
    }else{
    return [NSString stringWithFormat:@"%@", _periodqty];
    }
}
- (NSString *)repayTime {
    return [NSString stringWithFormat:@"%@到期", _repayTime];
}
@end
