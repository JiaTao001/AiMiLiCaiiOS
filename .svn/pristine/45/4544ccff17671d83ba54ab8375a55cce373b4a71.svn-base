//
//  calculationOfInterest.h
//  YuanXin_Project
//
//  Created by Yuanin on 16/1/14.
//  Copyright © 2016年 yuanxin. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, InterestCalculationPatternType) {
    
    kInterestCalculationPatternOnce = 1,//到期还本付息
    kInterestCalculationPatternFirstInterest,//先息后本
    kInterestCalculationPatternAverageCapital,//等额本金
    kInterestCalculationPatternAverageCapitalPlusInterest,//等额本息
};

@interface CalculationOfInterest : NSObject

@property (assign, nonatomic, readonly) InterestCalculationPatternType type;

@property (assign, nonatomic, readwrite) CGFloat    money;
@property (assign, nonatomic, readonly ) CGFloat    yield;
@property (assign, nonatomic, readonly ) NSUInteger expires;
@property (assign, nonatomic, readonly ) CGFloat    sumOfMoney;
@property (assign, nonatomic, readonly ) CGFloat    sumOfInterest;

/**
 *  在第 n 期需要偿还的利息
 *
 *  @param numberOfRestPeriods 第几期
 *
 *  @return 应还利息
 */
- (CGFloat)interestWithNumberOfRestPeriods:(NSUInteger)numberOfRestPeriods;

/**
 *  在第 n 期需要偿还的本金
 *
 *  @param numberOfRestPeriods 第几期
 *
 *  @return 应还本金
 */
- (CGFloat)principalWithNumberOfRestPeriods:(NSUInteger)numberOfRestPeriods;


/**
 *  init 利息计算
 *
 *  @param type     利息计算的方式
 *  @param money    利息计算的金额
 *  @param yield    利息计算的年利率(年利率)
 *  @param expires  利息计算的时间(期数 以月为单位)
 *
 *  @return 初始化的利息计算
 */
- (instancetype)initWithCalculationPattern:(InterestCalculationPatternType)type
                                     yield:(CGFloat)yield
                                   expires:(NSUInteger)expires;

+ (instancetype)calculationOfInterestWithCalculationPattern:(InterestCalculationPatternType)type
                                                      yield:(CGFloat)yield
                                                    expires:(NSUInteger)expires;

@end
