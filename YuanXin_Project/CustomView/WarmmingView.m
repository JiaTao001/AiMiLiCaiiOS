//
//  WarmmingView.m
//  YuanXin_Project
//
//  Created by Yuanin on 2017/5/8.
//  Copyright © 2017年 yuanxin. All rights reserved.
//

#import "WarmmingView.h"
@interface WarmmingView()

@property (copy, nonatomic) void(^click)();
@end

@implementation WarmmingView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (void)showInView:(UIView *)view WithImageName:(NSString *)imageName  clickImage:(void(^)())click {
    if (self.superview) return;
//    self.image = [UIImage imageNamed:imageName];
    [self sizeToFit];
    self.frame = [UIScreen mainScreen].bounds;
    self.click = click;
    [self addSubview:self.bonusBtn];
    self.bonusBtn.center = CGPointMake(self.center.x, self.center.y- 40);
    [self addSubview:self.cancleBtn];
    [_bonusBtn setBackgroundImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];

    
    [self addSubview:self.shareBtn];
    [view addSubview:self];
    [view bringSubviewToFront:self];
    //    [self jitter];
}
- (void)dissMiss{
    [self.shareBtn removeFromSuperview];
//    [self.cancleBtn removeFromSuperview];
//    [UIView animateWithDuration:0.5 animations:^{
//        [self.bonusBtn setFrame: CGRectMake(self.width - 65, self.height - 50, 0, 0)];
//    } completion:^(BOOL finished) {
        [self removeFromSuperview];
//    }];
}
- (instancetype)init {
    self = [super init];
    
    if (self) {
        
        self.userInteractionEnabled = YES;
        //        self.backgroundColor = [UIColor blackColor];
        //        self.alpha = 0.8;
           self.image = [UIImage imageNamed:@"touzi_back"];
        UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickImage)];
        [self addGestureRecognizer:gesture];
    }
    return self;
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
//        [_bonusBtn setBackgroundImage:[UIImage imageNamed:@"touzi_success"] forState:UIControlStateNormal];
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
