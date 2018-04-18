//
//  PropertyInfo.m
//  YuanXin_Project
//
//  Created by Yuanin on 15/10/29.
//  Copyright © 2015年 yuanxin. All rights reserved.
//

#import "PropertyInfo.h"

@interface PropertyInfo()

@property (copy, nonatomic, readwrite) NSString *expireTime;
@property (copy, nonatomic, readwrite) NSString *createdTime;
@property (copy, nonatomic, readwrite) NSString *investMoney;
@property (copy, nonatomic, readwrite) NSString *interest;
@property (copy, nonatomic, readwrite) NSString *restOfTheTime;
@property (copy, nonatomic, readwrite) NSString *propertySignImageName;
@property (copy, nonatomic, readwrite) NSString *investID;
@property (copy, nonatomic, readwrite) NSNumber *status;

@end

@implementation PropertyInfo

+ (instancetype)propertyInfoWithDictionary:(NSDictionary *)aDic {
    
    return [[[self class] alloc] initWithDictionary:aDic];
}
- (instancetype)initWithDictionary:(NSDictionary *)aDic {
    
    self = [super initWithProductID:[CommonTools convertToStringWithObject:aDic[@"id"]] productName:aDic[@"project_name"]];
    
    if (self) {
        
        _investID      = aDic[@"invest_id"];
        _expireTime    = aDic[@"expire_time"];
        _createdTime   = aDic[@"created"];
        _status        = aDic[@"status"];
        _investMoney   = [CommonTools convertToStringWithObject:aDic[@"amount"]];
        _interest      = [CommonTools convertToStringWithObject:aDic[@"interest"]];
        _restOfTheTime = [CommonTools convertToStringWithObject:aDic[@"days_num"]];
    }
    return self;
}

- (NSString *)restOfTheTime {
    
    return [NSString stringWithFormat:@"%@天", _restOfTheTime];
}
- (NSString *)propertyState {
    
    NSString *result;
    
    switch (self.status.integerValue) {
        case 2:
            result = @"募集中";
            break;
        case 3:
            result = @"已满标";
            break;
        case 4:
            result = @"已流标";
            break;
        case 5:
            result = @"还款中";
            break;
        case 7:
            result = @"已还款";
            break;
        case 9:
            result = @"提前结清";
            break;
        default:
            result = @"未定义";
            break;
    }
    return result;
}
- (NSString *)propertySignImageName {
    
    NSString *result;
    
    switch (self.status.integerValue) {
        case 2:
            result = @"point_blue";
            break;
        case 3:
            result = @"point_red";
            break;
        case 4:
            result = @"point_gray";
            break;
        case 5:
            result = @"point_yellow";
            break;
        case 7:
            result = @"point_orange";
            break;
        default:
            result = @"point_green";
            break;
    }
    return result;
}
@end
