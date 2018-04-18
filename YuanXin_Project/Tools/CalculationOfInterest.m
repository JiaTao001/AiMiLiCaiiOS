//
//  calculationOfInterest.m
//  YuanXin_Project
//
//  Created by Yuanin on 16/1/14.
//  Copyright © 2016年 yuanxin. All rights reserved.
//

#import "CalculationOfInterest.h"

@interface CalculationOfInterest()

@property (assign, nonatomic, readwrite) CGFloat    yield;
@property (assign, nonatomic, readwrite) NSUInteger expires;
@property (assign, nonatomic, readwrite) CGFloat    sumOfMoney;
@property (assign, nonatomic, readwrite) CGFloat    sumOfInterest;

@property (assign, nonatomic, readwrite) InterestCalculationPatternType type;
@end

@implementation CalculationOfInterest

- (instancetype)initWithCalculationPattern:(InterestCalculationPatternType)type
                                     yield:(CGFloat)yield
                                   expires:(NSUInteger)expires {
    self = [super init];
    if (self) {
        _type       = type;
        _yield      = yield;
        _expires    = expires;
        _sumOfMoney = 0;
    }
    return self;
}

+ (instancetype)calculationOfInterestWithCalculationPattern:(InterestCalculationPatternType)type
                                                      yield:(CGFloat)yield
                                                    expires:(NSUInteger)expires {
    
    return [[CalculationOfInterest alloc] initWithCalculationPattern:type yield:yield expires:expires];
}

- (CGFloat)interestWithNumberOfRestPeriods:(NSUInteger)numberOfRestPeriods {
    NSParameterAssert(numberOfRestPeriods > 0);
    NSParameterAssert(numberOfRestPeriods <= self.expires);
    
    CGFloat interest = 0;
    switch (self.type) {
        case kInterestCalculationPatternOnce:
            
            interest = self.money * self.yield * self.expires/12;
            break;
        case kInterestCalculationPatternFirstInterest:
            
            interest = self.money * self.yield/12;
            break;
        case kInterestCalculationPatternAverageCapital:
            
            interest = [self calculationAverageCapital:numberOfRestPeriods];
            break;
        case kInterestCalculationPatternAverageCapitalPlusInterest:
            
            interest = [self calculationAverageCapitalPlusInterest:numberOfRestPeriods];
            break;
    }
    
    NSLog(@"期数---%lu，利息---%lf", (unsigned long)numberOfRestPeriods, interest);
    
    return interest;
}

- (CGFloat)principalWithNumberOfRestPeriods:(NSUInteger)numberOfRestPeriods {
    NSParameterAssert( (numberOfRestPeriods > 0) || (numberOfRestPeriods <= self.expires) );
    
    CGFloat principal = 0;
    switch (self.type) {
        case kInterestCalculationPatternOnce:
            
            return self.money;
            break;
        case kInterestCalculationPatternFirstInterest:
            
            if (numberOfRestPeriods == self.expires) {
                return self.money;
            }
            break;
        case kInterestCalculationPatternAverageCapital:
            
            principal = self.money / self.expires;
            break;
        case kInterestCalculationPatternAverageCapitalPlusInterest:
            
            break;
    }
    
    return principal;
}

- (CGFloat)calculationSumOfMoney {
    
    CGFloat sumInterest = 0;
    if (kInterestCalculationPatternOnce == self.type) {
        sumInterest = [self interestWithNumberOfRestPeriods:1];
    } else {
        
        for (NSInteger i = 1; i <= self.expires; ++i) {
            sumInterest += [self interestWithNumberOfRestPeriods:i];
        }
    }
    
    return sumInterest;
}
- (CGFloat)calculationAverageCapitalPlusInterest:(NSUInteger)numberOfRestPeriods {
    
    CGFloat interest = 0;
    
    //    //等额本息
    //    //每月应还利息=贷款本金×月利率×〔(1+月利率)^还款月数-(1+月利率)^(还款月序号-1)〕÷〔(1+月利率)^还款月数-1〕
    CGFloat monthYield = self.yield/12;//月利率
    if (1 == numberOfRestPeriods) {
        interest = self.money * monthYield;
    } else {
        CGFloat base = 0;
        for (NSInteger i = 1; i <= self.expires; ++i) {
            if (1 == i) {
                base = 1 + monthYield;
            } else {
                base = base*(1 + monthYield);
            }
        }
        
        CGFloat monthBase = 0;
        for (NSInteger i = 1; i <= numberOfRestPeriods - 1; ++i) {
            if (1 == i) {
                monthBase = 1 + monthYield;
            } else {
                monthBase = monthBase*(1 + monthYield);
            }
        }
        
        interest = self.money * monthYield * (base - monthBase);
        interest = interest/(base - 1);
    }

    return interest;
}
- (CGFloat)calculationAverageCapital:(NSUInteger)numberOfRestPeriods {
    
    CGFloat monthYield = self.yield/12;
    CGFloat surplusMoney = self.money * (self.expires - numberOfRestPeriods - 1)/ self.expires;
    
    return surplusMoney * monthYield;
}

- (void)setMoney:(CGFloat)money {
    _money = money;
    
    self.sumOfInterest = [self calculationSumOfMoney];
    self.sumOfMoney = self.money + self.sumOfInterest;
}


@end
