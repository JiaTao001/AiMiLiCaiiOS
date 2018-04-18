//
//  TransactionRecordsInfo.m
//  YuanXin_Project
//
//  Created by Yuanin on 15/10/28.
//  Copyright © 2015年 yuanxin. All rights reserved.
//

#import "TransactionRecordsInfo.h"

//返回值 list type（名称）、created(时间)、money(金额)、after_money（交易后的金额）、status(已完成还是未完成)


@interface TransactionRecordsInfo()

@property (strong, nonatomic, readwrite) NSString *type;
@property (strong, nonatomic, readwrite) NSString *created;
@property (strong, nonatomic, readwrite) NSString *money;
@property (strong, nonatomic, readwrite) NSString *afterMoney;
@property (strong, nonatomic, readwrite) NSString *status;
@end

@implementation TransactionRecordsInfo

+ (instancetype)TransactionRecordsInfoWithDictaionary:(NSDictionary *)aDic {
    
    return [[TransactionRecordsInfo alloc] initWithDictionary:aDic];
}
- (instancetype)initWithDictionary:(NSDictionary *)aDic {
    
    if (self = [super init]) {

        self.type       = aDic[@"type"];
        self.created    = aDic[@"created"];
        self.money      = [CommonTools convertToStringWithObject:aDic[@"money"]];
        self.afterMoney = [CommonTools convertToStringWithObject:aDic[@"after_money"]];
        self.status     = aDic[@"status"];
    }
    return self;
}

- (UIColor *)statusColor {
    
    return [self.status isEqualToString:@"交易成功"] ? Normal_Green : [self.status isEqualToString:@"交易失败"] ? Theme_Color : RGB(0x666666);
}
@end
