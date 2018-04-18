//
//  TheTimeCountdown.h
//  YuanXin_Project
//
//  Created by Yuanin on 16/9/23.
//  Copyright © 2016年 yuanxin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TheCountDown.h"

@class SecondsConversionTime;

@interface TheTimeCountDown : NSObject

@property (strong, nonatomic, readonly) TheCountDown *theCountDown;
@property (strong, nonatomic, readonly) SecondsConversionTime *secondsConversionTime;
@property (assign, nonatomic, readwrite) NSInteger seconds;

+ (instancetype)theTimeCountDownWithSecond:(NSInteger)second countDown:(void(^)(TheTimeCountDown *countDown))countDownBlock;
- (instancetype)initWithSecond:(NSInteger)second countDown:(void(^)(TheTimeCountDown *countDown))countDownBlock;

@end


@interface SecondsConversionTime : NSObject

@property (assign, nonatomic) NSInteger seconds;

@property (assign, nonatomic, readonly) NSString *day;
@property (assign, nonatomic, readonly) NSString *hour;
@property (assign, nonatomic, readonly) NSString *min;
@property (assign, nonatomic, readonly) NSString *sec;
@end