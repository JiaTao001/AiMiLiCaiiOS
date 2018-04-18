//
//  bonusAnimationView.m
//  YuanXin_Project
//
//  Created by Yuanin on 2017/4/25.
//  Copyright © 2017年 yuanxin. All rights reserved.
//

#import "bonusAnimationView.h"
@interface bonusAnimationView()

@property (copy, nonatomic) void(^click)();
@end

@implementation bonusAnimationView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (void)showInView:(UIView *)view clickImage:(void(^)())click {
    if (self.superview) return;
    
    [self sizeToFit];
    self.frame = [UIScreen mainScreen].bounds;
    self.click = click;
    [self addSubview:self.bonusBtn];
   self.bonusBtn.center = CGPointMake(self.center.x, self.center.y- 80);
    [self addSubview:self.cancleBtn];
 
   
    [self addSubview:self.shareBtn];
    [view addSubview:self];
    [view bringSubviewToFront:self];
//    [self jitter];
}
- (void)dissMiss{
    [self.shareBtn removeFromSuperview];
    [self.cancleBtn removeFromSuperview];
    [UIView animateWithDuration:0.5 animations:^{
        [self.bonusBtn setFrame: CGRectMake(self.width - 65, self.height - 50, 0, 0)];
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}
- (instancetype)init {
    self = [super init];
    
    if (self) {
        self.image = [UIImage imageNamed:@"touzi_back"];
        self.userInteractionEnabled = YES;
//        self.backgroundColor = [UIColor blackColor];
//        self.alpha = 0.8;
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
- (void)btnclicked{
    if (self.ShareBlock) {
        self.ShareBlock();
    }
}
- (void)btnclicked2{
   
}


- (void)clickImage {
    
    PerformEmptyParameterBlock(self.click);
}
- (UIButton *)bonusBtn{
    if (!_bonusBtn) {
        _bonusBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, self.width-40,self.width-40 )];
        [_bonusBtn setBackgroundImage:[UIImage imageNamed:@"touzi_success"] forState:UIControlStateNormal];
//        _bonusBtn.showsTouchWhenHighlighted = NO;
        _bonusBtn.adjustsImageWhenHighlighted = NO;
        [_bonusBtn addTarget:self action:@selector(btnclicked2) forControlEvents:UIControlEventTouchUpInside];
        _bonusBtn.contentMode = UIViewContentModeScaleAspectFit;
    }
    return _bonusBtn;
}
- (UIButton *)cancleBtn{
    if (!_cancleBtn) {
        _cancleBtn = [[UIButton alloc]initWithFrame:CGRectMake( self.bounds.size.width /2 -20, self.bonusBtn.frame.origin.y +self.bonusBtn.frame.size.height +10 ,40 ,40)];
//        _cancleBtn.backgroundColor = [UIColor blueColor];
        [_cancleBtn setBackgroundImage:[UIImage imageNamed:@"touzi_fail"] forState:UIControlStateNormal];
        [_cancleBtn addTarget:self action:@selector(clickImage) forControlEvents:UIControlEventTouchUpInside];
        _cancleBtn.contentMode = UIViewContentModeScaleAspectFit;
    }
    return _cancleBtn;
}
- (UIButton *)shareBtn{
    if (!_shareBtn) {
        _shareBtn = [[UIButton alloc]initWithFrame:CGRectMake( self.bounds.size.width /2 -80, self.bonusBtn.frame.origin.y +self.bonusBtn.frame.size.height - 70 ,160 ,55)];
//        _shareBtn.backgroundColor = [UIColor redColor];
        [_shareBtn addTarget:self action:@selector(btnclicked) forControlEvents:UIControlEventTouchUpInside];
        
//        [_shareBtn setBackgroundImage:[UIImage imageNamed:@"touzi_fail"] forState:UIControlStateNormal];
        _shareBtn.contentMode = UIViewContentModeScaleAspectFit;
    }
    return _shareBtn;
}

@end
