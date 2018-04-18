//
//  TheCountDown.m
//  YuanXin_Project
//
//  Created by Yuanin on 16/9/23.
//  Copyright © 2016年 yuanxin. All rights reserved.
//

#import "TheCountDown.h"

#import "TimerIntermediary.h"

@interface TheCountDown ()

@property (assign, atomic, readwrite) NSInteger numberOfAfterCountDown;
@property (assign, nonatomic, readwrite) BOOL active;

@property (copy, nonatomic) void(^countDownBlock)(TheCountDown *countDown);
@property (strong, nonatomic) TimerIntermediary *timerIntermediary;

@end

@implementation TheCountDown
@synthesize number = _number;

+ (instancetype)theCountDownWithNumber:(NSInteger)number countDown:(void(^)(TheCountDown *countDown))countDownBlock
{
    return [[[self class] alloc] initWithNumber:number countDown:countDownBlock];
}
- (instancetype)initWithNumber:(NSInteger)number countDown:(void(^)(TheCountDown *countDown))countDownBlock
{
    if (self = [super init]) {
        _number = number;
        _numberOfAfterCountDown = number + 1;//start的时候会立即调用一次。所以事先加上一
        _active = NO;
        _countDownBlock = [countDownBlock copy];
    }
    return self;
}

- (void)startCountDown
{
    if (self.active) {
        return;
    }
    self.active = YES;
    [self.timerIntermediary start];
}

- (void)stopCountDown
{
    if (!self.active) {
        return;
    }
    self.active = NO;
    [self.timerIntermediary stop];
}

- (void)setNumber:(NSInteger)number
{
    @synchronized (self) {
        _number = number;
        self.numberOfAfterCountDown = number + 1;
    }
}

- (NSInteger)number
{
    @synchronized (self) {
        return _number;
    }
}

- (TimerIntermediary *)timerIntermediary {
    
    if (!_timerIntermediary) {
        _timerIntermediary = [TimerIntermediary timerIntermediaryWithTimeInterval:1 target:self action:^(TimerIntermediary *intermediary, TheCountDown *target) {
            
            target.numberOfAfterCountDown -= 1;
            !target.countDownBlock ? : target.countDownBlock(target);
        } userInfo:nil repeats:YES];
    }
    
    return _timerIntermediary;
}
@end
