//
//  DemitintBehavior.m
//  YuanXin_Project
//
//  Created by Yuanin on 16/2/2.
//  Copyright © 2016年 yuanxin. All rights reserved.
//

#import "DemitintBehavior.h"

@implementation DemitintBehavior

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    if ( 0 <= scrollView.contentOffset.x && scrollView.contentOffset.x <= self.exclusive.invalidButton.superview.width*(self.subButtons.count - 1)) {
        
//        CGFloat relativePosition = scrollView.contentOffset.x/self.subButtons.count;
//        CGFloat itemWidth = self.exclusive.invalidButton.superview.width/self.subButtons.count;
//        //开始的X轴 与 lineX的初始位置相抵消
//        NSInteger startX = CGRectGetMinX(self.exclusive.invalidButton.frame);
        //偏移的量
        CGFloat offset =  scrollView.contentOffset.x - self.exclusive.invalidButton.superview.width*[self.subButtons indexOfObject:self.exclusive.invalidButton];
        //偏移在整个过程中的进度
        [self changeTheColor:offset/self.exclusive.invalidButton.superview.width];
      }
}

- (void)changeTheColor:(CGFloat)progress {
    
//    static CGFloat preProgress = 0;
//    if ( pow(0.01, 2)  >= pow(preProgress - progress, 2)) {
//        return;
//    }
//    preProgress = progress;
    
    UIButton *activeButton = self.exclusive.invalidButton;
    
    if (progress >= 1 || -1 >= progress) { //如果大于1.将激活的按钮设为离开始最近的按钮
        NSInteger offsetIndex = [CommonTools roundedCGFloat:progress];
        
        UIButton *nextButton = [self subButtonWithIndex:[self.subButtons indexOfObject:activeButton] + offsetIndex];
        
        if (self.exclusive.oldInvalidButton != self.exclusive.invalidButton) { //如果相等，就说明正在切换中
            [self.exclusive setButtonInvalid:nextButton];
        }
        if ([nextButton isKindOfClass:[UIButton class]]) {
            [activeButton setTitleColor:[self.demitint colorWithProgress:1] forState:UIControlStateNormal];
            [nextButton setTitleColor:[self.demitint colorWithProgress:0] forState:UIControlStateNormal];
        }
    } else {
        
        //如果为正向右改色，为负向左改色
        NSInteger offsetIndex =  progress > 0 ? ceil(progress) : floor(progress);
    
        UIButton *nextButton = [self subButtonWithIndex:[self.subButtons indexOfObject:activeButton] + offsetIndex];
        
        //进度转正
        CGFloat activeProgress = progress > 0 ? progress : -progress;
        
        if (activeButton == nextButton) {
            [activeButton setTitleColor:[self.demitint colorWithProgress:0] forState:UIControlStateNormal];
        } else if ([nextButton isKindOfClass:[UIButton class]]) {
            [activeButton setTitleColor:[self.demitint colorWithProgress:activeProgress] forState:UIControlStateNormal];
            [nextButton setTitleColor:[self.demitint colorWithProgress:1 - activeProgress] forState:UIControlStateNormal];
        }
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
        
    [self.exclusive setButtonInvalid:[self subButtonWithIndex:(scrollView.contentOffset.x/CGRectGetWidth(scrollView.frame))]];
}

- (UIButton *)subButtonWithIndex:(NSInteger) index {
    
    if (index < 0 || index >= self.subButtons.count) {
        return nil;
    }
    return self.subButtons[index];
}

- (void)setSubButtons:(NSArray *)subButtons {
    
    _subButtons = [subButtons sortedArrayUsingComparator:^NSComparisonResult(UIView *obj1, UIView *obj2) {
        return [@(obj1.tag) compare:@(obj2.tag)];
    }];
}
@end



/**
 *  demitint
 */
@implementation Demitint

+ (instancetype)demitintWithBeginColor:(UIColor *)beginColor endColor:(UIColor *)endColor {
    
    return [[[self class] alloc] initWithBeginColor:beginColor endColor:endColor];
}
- (instancetype)initWithBeginColor:(UIColor *)beginColor endColor:(UIColor *)endColor {
    self = [super init];
    
    if (self) {
        _beginColor = beginColor;
        _endColor   = endColor;
    }
    
    return self;
}

- (UIColor *)colorWithProgress:(CGFloat)progress {
    
    if (CGColorEqualToColor(self.beginColor.CGColor, self.endColor.CGColor)) {
        return self.beginColor;
    }
    
    progress = MAX(0, MIN(1, progress));

    CGColorRef beginColor = CGColorCreateCopy(self.beginColor.CGColor);
    CGColorRef endColor = CGColorCreateCopy(self.endColor.CGColor);
    
    const CGFloat *begin = CGColorGetComponents(beginColor);
    const CGFloat *end = CGColorGetComponents(endColor);
    
    CGFloat middle[4] = {};
    
    int len = sizeof(middle)/sizeof(middle[0]);
    for (int i = 0; i < len; i++) {
        middle[i] = begin[i] - (begin[i] - end[i])*progress;
    }
    
    CGColorSpaceRef middleColorSpace = CGColorSpaceCreateDeviceRGB();
    CGColorRef middleColor = CGColorCreate(middleColorSpace, middle);
    
    UIColor *realColor = [UIColor colorWithCGColor:middleColor];
    
    //Release
    CGColorRelease(beginColor);
    CGColorRelease(endColor);
    CGColorRelease(middleColor);
    
    return realColor;
}
@end
