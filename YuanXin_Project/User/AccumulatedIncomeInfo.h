//
//  AccumulatedIncomeInfo.h
//  YuanXin_Project
//
//  Created by Yuanin on 15/10/29.
//  Copyright © 2015年 yuanxin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AccumulatedIncomeInfo : NSObject

@property (strong, nonatomic) NSString *interest, *repayTime, *name, *periodqty, *incomeState;
@property (strong, nonatomic) UIColor *incomeStateColor;

+ (instancetype)accumulatedIncomeInfoWithDictionary:(NSDictionary *)aDic;
- (instancetype)initWithDictionary:(NSDictionary *)aDic;
@end
