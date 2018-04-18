//
//  TheTimeCountdown.m
//  YuanXin_Project
//
//  Created by Yuanin on 16/9/23.
//  Copyright © 2016年 yuanxin. All rights reserved.
//

#import "TheTimeCountdown.h"

@interface TheTimeCountDown ()

@property (strong, nonatomic, readwrite) TheCountDown *theCountDown;
@property (strong, nonatomic, readwrite) SecondsConversionTime *secondsConversionTime;

@property (strong, nonatomic) RACDisposable *enterForeground;
@property (strong, nonatomic) RACDisposable *enterBackground;
@property (strong, nonatomic) NSDate *enterBackgroundDate;

@property (copy, nonatomic) void(^countDownBlock)(TheTimeCountDown *countDown);
@end

@implementation TheTimeCountDown
@synthesize seconds = _seconds;

+ (instancetype)theTimeCountDownWithSecond:(NSInteger)second countDown:(void(^)(TheTimeCountDown *countDown))countDownBlock
{
    return [[[self class] alloc] initWithSecond:second countDown:countDownBlock];
}

- (instancetype)initWithSecond:(NSInteger)second countDown:(void(^)(TheTimeCountDown *countDown))countDownBlock
{
    if (self = [super init]) {
        _countDownBlock = [countDownBlock copy];
    }
    return self;
}

- (void)setSeconds:(NSInteger)seconds
{
    if (seconds <= 0) {
        return;
    }
    [self.theCountDown stopCountDown];
    self.theCountDown.number = seconds;
    [self.theCountDown startCountDown];
    
    [self.enterForeground dispose];
    [self.enterBackground dispose];
    @weakify(self)
    self.enterForeground = [[[NSNotificationCenter defaultCenter] rac_addObserverForName:UIApplicationWillEnterForegroundNotification object:nil] subscribeNext:^(id x) {
        @strongify(self)
        if (self.enterBackgroundDate) {
            self.theCountDown.number = self.theCountDown.numberOfAfterCountDown + self.enterBackgroundDate.timeIntervalSinceNow;
            [self.theCountDown startCountDown];
        }
    }];
    self.enterBackground = [[[NSNotificationCenter defaultCenter] rac_addObserverForName:UIApplicationDidEnterBackgroundNotification object:nil] subscribeNext:^(id x) {
        @strongify(self)
        self.enterBackgroundDate = [NSDate date];
        [self.theCountDown stopCountDown];
    }];
}

- (NSInteger)seconds
{
    return self.theCountDown.number;
}

- (TheCountDown *)theCountDown
{
    if (!_theCountDown) {
        
        @weakify(self)
        _theCountDown = [TheCountDown theCountDownWithNumber:0 countDown:^(TheCountDown *countDown) {
            @strongify(self)
            
            if (countDown.numberOfAfterCountDown < 0) {
                [countDown stopCountDown];
            } else {
                self.secondsConversionTime.seconds = countDown.numberOfAfterCountDown;
            }
            !self.countDownBlock ? : self.countDownBlock(self);
        }];
    }
    return _theCountDown;
}

- (SecondsConversionTime *)secondsConversionTime
{
    if (!_secondsConversionTime) {
        _secondsConversionTime = [[SecondsConversionTime alloc] init];
    }
    return _secondsConversionTime;
}

@end


@implementation SecondsConversionTime

- (NSString *)day
{
    return [NSString stringWithFormat:@"%li", (long)self.seconds/(60*60*24)];
}

- (NSString *)hour
{
    return [NSString stringWithFormat:@"%li", (long)(self.seconds/(60*60))%24];
}

- (NSString *)min
{
    return [NSString stringWithFormat:@"%li", (long)(self.seconds/60)%60];
}

- (NSString *)sec
{
    return [NSString stringWithFormat:@"%li", (long)self.seconds%60];
}

@end
