//
//  JitterImageView.m
//  YuanXin_Project
//
//  Created by Yuanin on 16/7/14.
//  Copyright © 2016年 yuanxin. All rights reserved.
//

#import "JitterImageView.h"

@interface JitterImageView()

@property (copy, nonatomic) void(^click)();
@end

@implementation JitterImageView

- (void)showInView:(UIView *)view withAnimation:(BOOL)isAni  clickImage:(void(^)())click {
    if (self.superview) return;
    
    [self sizeToFit];
    if (isAni) {
        CGRect rect = self.frame;
        self.frame = CGRectMake([UIScreen mainScreen].bounds.size.width - 65, [UIScreen mainScreen].bounds.size.height - 50, 0, 0);
        [UIView animateWithDuration:0.5 animations:^{
            self.frame = CGRectMake( view.width - rect.size.width - MARGIN_DISTANCE, view.height - rect.size.height - MARGIN_DISTANCE - (1 == view.tag ? TABBAR_HEIGHT : 0),
                                    rect.size.width, rect.size.height);
            
        } completion:^(BOOL finished) {
            
        }];
    }else{
    self.frame = CGRectMake( view.width - self.width - MARGIN_DISTANCE, view.height - self.height - MARGIN_DISTANCE - (1 == view.tag ? TABBAR_HEIGHT : 0),
                            self.width, self.height);
    }
    self.click = click;
    
    [view addSubview:self];
    [view bringSubviewToFront:self];
    [self jitter];
}

- (instancetype)init {
    self = [super init];
    
    if (self) {
        self.image = [UIImage imageNamed:@"jitter_bonus"];
        self.userInteractionEnabled = YES;
        UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickImage)];
        [self addGestureRecognizer:gesture];
    }
    return self;
}

- (void)jitter {
    
    CGPoint position = self.layer.position;
    CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    animation.values = @[
                         [NSValue valueWithCGPoint:position],
                         [NSValue valueWithCGPoint:CGPointMake(position.x, position.y - BIG_MARGIN_DISTANCE)],
                         [NSValue valueWithCGPoint:CGPointMake(position.x, position.y + MARGIN_DISTANCE)],
                         [NSValue valueWithCGPoint:position]
                         ];
    
    animation.duration            = 5;
    animation.repeatCount         = NSIntegerMax;
    animation.timingFunction      = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    animation.removedOnCompletion = NO;
    animation.fillMode            = kCAFillModeForwards;

    [self.layer addAnimation:animation forKey:@"jitterAnimation"];
}

- (void)clickImage {
    
    PerformEmptyParameterBlock(self.click);
}
@end
