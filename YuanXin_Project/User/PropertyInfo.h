//
//  PropertyInfo.h
//  YuanXin_Project
//
//  Created by Yuanin on 15/10/29.
//  Copyright © 2015年 yuanxin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SingleProductInfo.h"

//返回值 list  id（商品id）、project_name（理财项目名称）、expire_time（到期时间）、amount（投资金额）、interest（到期总收益）、created（投资时间）

@interface PropertyInfo : SingleProductInfo

@property (copy, nonatomic, readonly) NSString *expireTime;
@property (copy, nonatomic, readonly) NSString *createdTime;
@property (copy, nonatomic, readonly) NSString *investMoney;
@property (copy, nonatomic, readonly) NSString *interest;
@property (copy, nonatomic, readonly) NSString *restOfTheTime;
@property (copy, nonatomic, readonly) NSString *propertyState;
@property (copy, nonatomic, readonly) NSString *propertySignImageName;
@property (copy, nonatomic, readonly) NSString *investID;

+ (instancetype)propertyInfoWithDictionary:(NSDictionary *)aDic;
- (instancetype)initWithDictionary:(NSDictionary *)aDic;
@end
