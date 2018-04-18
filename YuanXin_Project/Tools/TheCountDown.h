//
//  TheCountDown.h
//  YuanXin_Project
//
//  Created by Yuanin on 16/9/23.
//  Copyright © 2016年 yuanxin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TheCountDown : NSObject

@property (assign, atomic, readwrite) NSInteger number;
@property (assign, atomic, readonly) NSInteger numberOfAfterCountDown;
@property (assign, nonatomic, readonly, getter=isActive) BOOL active;

+ (instancetype)theCountDownWithNumber:(NSInteger)Number countDown:(void(^)(TheCountDown *countDown))countDownBlock;
- (instancetype)initWithNumber:(NSInteger)Number countDown:(void(^)(TheCountDown *countDown))countDownBlock;

- (void)startCountDown;
- (void)stopCountDown;
@end
