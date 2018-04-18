//
//  CrossButton.m
//  YuanXin_Project
//
//  Created by Yuanin on 16/1/19.
//  Copyright © 2016年 yuanxin. All rights reserved.
//

#import "CrossButton.h"

static const CGFloat crossStartProgress = 0.35;
static const CGFloat crossEndProgress = 0.65;
static const CGFloat uncrossStartProgress = 0.3;
static const CGFloat uncrossEndProgress = 0.5;

@interface CrossButton()

@property (assign, nonatomic) BOOL willChangeState;
@property (strong, nonatomic) CAShapeLayer *crossLine1;
@property (strong, nonatomic) CAShapeLayer *crossLine2;
@end

@implementation CrossButton

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    
    if (self) {
        [self configureCrossButton];
    }
    return self;
}
- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    
    if (self) {
        [self configureCrossButton];
    }
    return self;
}
- (void)configureCrossButton {
    
    self.crossState = NO;
    self.willChangeState = NO;
    [self.layer addSublayer:self.crossLine1];
    [self.layer addSublayer:self.crossLine2];
}

- (void)layoutSublayersOfLayer:(CALayer *)layer {
    
    CGMutablePathRef path1 = CGPathCreateMutable();
    CGPathMoveToPoint(path1, nil, 0, 0);
    CGPathAddLineToPoint(path1, nil, layer.bounds.size.width, layer.bounds.size.height);
    self.crossLine1.path = path1;
    
    CGMutablePathRef path2 = CGPathCreateMutable();
    CGPathMoveToPoint(path2, nil, 0, layer.bounds.size.height);
    CGPathAddLineToPoint(path2, nil, layer.bounds.size.width, 0);
    self.crossLine2.path = path2;
    
    CGPathRelease(path1);
    CGPathRelease(path2);
}

- (void)tintColorDidChange {
    
    self.crossLine1.strokeColor = self.crossLine2.strokeColor = self.tintColor.CGColor;
}

- (void)setCrossState:(BOOL)crossState {
    _crossState = crossState;
    
    if (self.window) {
        [self changeStateAnimation];
    } else {
        self.willChangeState = YES;
        
        [self setNeedsDisplay];
    }
}

- (void)changeStateAnimation {
    
    [UIView animateWithDuration:NORMAL_ANIMATION_DURATION animations:^{
        
        self.crossLine1.strokeStart = self.crossLine2.strokeStart = _crossState ? crossStartProgress : uncrossStartProgress;
        self.crossLine1.strokeEnd   = self.crossLine2.strokeEnd   = _crossState ? crossEndProgress : uncrossEndProgress;
    }];
}

- (CAShapeLayer *)crossLine1 {
    
    if (!_crossLine1) {
        
        _crossLine1 = [self creatShapeLayer];
    }
    return _crossLine1;
}
- (CAShapeLayer *)crossLine2 {
    
    if (!_crossLine2) {
        
        _crossLine2 = [self creatShapeLayer];
    }
    return _crossLine2;
}

- (CAShapeLayer *)creatShapeLayer {
    CAShapeLayer *crossline = [[CAShapeLayer alloc] init];
    
    crossline.lineWidth = 1;
    crossline.lineCap = kCALineCapRound;
    crossline.strokeColor = self.tintColor.CGColor;
    crossline.strokeStart = uncrossStartProgress;
    crossline.strokeEnd = uncrossEndProgress;
    
    return crossline;
}

- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    
    if (self.willChangeState) {
        self.willChangeState = NO;
        [self changeStateAnimation];
    }
}

- (void)prepareForInterfaceBuilder {
    [super prepareForInterfaceBuilder];
}
@end
