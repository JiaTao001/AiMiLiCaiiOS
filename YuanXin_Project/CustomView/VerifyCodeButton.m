//
//  AuthCodeButton.m
//  wujin-tourist
//
//  Created by wujin  on 15/7/15.
//  Copyright (c) 2015年 wujin. All rights reserved.
//

#import "VerifyCodeButton.h"

#import "TheCountDown.h"

@interface VerifyCodeButton()

@property (assign, nonatomic) NSInteger         countDownCount;
@property (strong, nonatomic, readonly) NSString          *pristineTitle;

@property (strong, nonatomic) TheCountDown *theCountDown;
@end

@implementation VerifyCodeButton {
    
    NSString *_pristineTitle;
}

- (instancetype)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        
        [self configureAuthCodeButton];
    }
    return self;
}
- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        
        [self configureAuthCodeButton];
    }
    return self;
}

- (void)configureAuthCodeButton {
        
    self.titleLabel.minimumScaleFactor        = 0.5f;
    self.titleLabel.adjustsFontSizeToFitWidth = YES;
}

- (void)countDown:(NSInteger)count {
    
    [self.theCountDown stopCountDown];
    self.theCountDown.number = count;
    [self.theCountDown startCountDown];
}

- (void)setCountDownCount:(NSInteger)countDownCount {
    

    
    @synchronized (self) {
        _countDownCount = countDownCount;
        
        self.userInteractionEnabled = (_countDownCount <= 0);
        [self setTitle:[self thePresentTitle] forState:UIControlStateNormal];
    }
}

- (NSString *)thePresentTitle {
    
    if (!_pristineTitle) {
        _pristineTitle = [self titleForState:UIControlStateNormal];
    }
    
    return (_countDownCount <= 0) ? _pristineTitle : [NSString stringWithFormat:@"(%@s)重新发送", @(self.countDownCount)];
}

- (TheCountDown *)theCountDown
{
    if (!_theCountDown) {
        @weakify(self)
        _theCountDown = [TheCountDown theCountDownWithNumber:0 countDown:^(TheCountDown *countDown) {
            @strongify(self)
            if (countDown.numberOfAfterCountDown < 0) {
                [self.theCountDown stopCountDown];
            } else {
                self.countDownCount = countDown.numberOfAfterCountDown;
            }
        }];
    }
    return _theCountDown;
}

@end
