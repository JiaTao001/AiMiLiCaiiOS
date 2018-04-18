//
//  DemitintBehavior.h
//  YuanXin_Project
//
//  Created by Yuanin on 16/2/2.
//  Copyright © 2016年 yuanxin. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "ExclusiveButton.h"

@class Demitint;

@interface DemitintBehavior : NSObject

@property (strong, nonatomic) IBOutlet ExclusiveButton *exclusive;/**< 子按钮都是互斥的 */
@property (strong, nonatomic) IBOutlet Demitint        *demitint;/**< 渐变色 */
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *subButtons;
@end


/**
 *  demitint
 */
@interface Demitint : NSObject

@property (strong, nonatomic) IBInspectable UIColor *beginColor;
@property (strong, nonatomic) IBInspectable UIColor *endColor;

- (UIColor *)colorWithProgress:(CGFloat)progress;

+ (instancetype)demitintWithBeginColor:(UIColor *)beginColor endColor:(UIColor *)endColor;
- (instancetype)initWithBeginColor:(UIColor *)beginColor endColor:(UIColor *)endColor;
@end
