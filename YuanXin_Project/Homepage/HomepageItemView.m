//
//  FixedHomepageItem.m
//  YuanXin_Project
//
//  Created by Yuanin on 16/4/19.
//  Copyright © 2016年 yuanxin. All rights reserved.
//

#import "HomepageItemView.h"
#import "UserinfoManager.h"
#import "Userinfo.h"

@interface FixedHomepageItem()

@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *subheadingLabel;

@end

@implementation FixedHomepageItem

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    
    if (self) {
        [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:self options:nil];
        
        [self addSubview:self.view];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.view.frame = self.bounds;
}

- (void)setImageName:(NSString *)imageName {
    
    _imageName = imageName;
    self.imageView.image = [UIImage imageNamed:imageName];
}
- (void)setTitle:(NSString *)title {
    
    _title = title;
    self.titleLabel.text = title;
}
- (void)setSubheading:(NSString *)subheading {
    
    _subheading = subheading;
    self.subheadingLabel.text  = subheading;
}

@end


@interface HomepageItemView ()

@property (weak, nonatomic) IBOutlet UIView *announcementView;
@property (weak, nonatomic) IBOutlet UIButton *announcement;
@property (strong, nonatomic) CABasicAnimation *scrollAnimation;

@property (copy, nonatomic) void(^selectBlock)(NSInteger index);
@property (weak, nonatomic) IBOutlet UIButton *liketouziBtn;
//@property (weak, nonatomic) IBOutlet UILabel *accountAllMoneyLB;

@property (assign, nonatomic) BOOL needChangeAnimationState;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *viewHeight;



@property (nonatomic, strong) NSTimer *timer;//计时器
@property (nonatomic, assign) NSInteger count;//监听当前倒数的数字

@end

@implementation HomepageItemView

+ (instancetype)homepageItemViewWithIsLogin:(BOOL)islogin ProductInfo:(RecommendProductInfo *)aInfo  SelectBlock:(void(^)(NSInteger index)) selectBlock {
    
    HomepageItemView *result = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:nil options:nil] firstObject];
    
    NSMutableAttributedString *noteStr = [[NSMutableAttributedString alloc] initWithString:@"注册即送885元红包"];
    NSRange redRange = NSMakeRange([[noteStr string] rangeOfString:@"885元红包"].location, [[noteStr string] rangeOfString:@"885元红包"].length);
    [noteStr addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:redRange];
//    [noteStr addAttribute:NSFontAttributeName value:[UIFont boldSystemFontOfSize:5.0f] range:redRange];
    
    
    [result.zhuceLB setAttributedText:noteStr];
    [result.zhuceLB sizeToFit];
    
    
    NSMutableAttributedString *noteStr2 = [[NSMutableAttributedString alloc] initWithString:@"新手推荐｜新手专享"];
    NSRange redRange2 = NSMakeRange([[noteStr2 string] rangeOfString:@"新手推荐"].location, [[noteStr2 string] rangeOfString:@"新手推荐"].length);
    [noteStr2 addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:redRange2];
    
    
    [result.xinshouLB setAttributedText:noteStr2];
    [result.xinshouLB sizeToFit];
    
//    if (aInfo.canBuy) {
//        [result.liketouziBtn setBackgroundImage:[UIImage imageNamed:@"2xanniu"] forState:UIControlStateNormal] ;
//
//
//        result.liketouziBtn.enabled = YES;
//
//    }else{
//        [result.liketouziBtn setBackgroundImage:[UIImage imageNamed:@"2xanniu_gray"] forState:UIControlStateNormal] ;
//
//        result.liketouziBtn.enabled = NO;
//    }
//
//    [result.liketouziBtn setTitle:aInfo.productState forState:UIControlStateNormal];
//    NSLog(@"%@aInfo..",aInfo.productState);
    //    if ([UserinfoManager sharedUserinfo].logined) {
    //        result.accountAllMoneyLB.text =   [NSString stringWithFormat:@"%@元",[[UserinfoManager sharedUserinfo].userInfo amount]] ;
    //    }
    //    @weakify(self)
    //    [RACObserve([UserinfoManager sharedUserinfo], logined) subscribeNext:^(NSNumber *x) {
    //        @strongify(self)
    //        self.leftItem.hidden = !x.boolValue;
    //    }];
    
    //3.定时器
    result.count = 0;
    //    result.timer = [NSTimer scheduledTimerWithTimeInterval:4 target:result selector:@selector(timerAction:) userInfo:nil repeats:YES];
    //
    if (islogin) {
        result.zhuceView.hidden = YES;
        result.zhuceViewheigth.constant = 0;
        result.zichanView.hidden = NO;
        result.zichanviewHeight.constant = 80;
        result.viewHeight.constant = 475 - 74;
        
    }else{
        result.zhuceView.hidden = NO ;
        result.zhuceViewheigth.constant = 74;
        result.zichanView.hidden = YES;
        result.zichanviewHeight.constant = 0;
        result.viewHeight.constant = 475 - 80;
    }
    
    //    result.replyMethodLB.text     = aInfo.replyMethod;
    
//    result.reteLB.text  =[NSString stringWithFormat:@"%.2f",[aInfo.annualInterest floatValue]] ;
//    result.timeLB.text      = [aInfo theTermOfProduct];
//    result.moneyLB.text     = [NSString stringWithFormat:@"%@元", aInfo.restOfShare];
    
    if (![result isKindOfClass:[self class]]) return nil;
    result.selectBlock = selectBlock;
    result.needChangeAnimationState = NO;
    result.translatesAutoresizingMaskIntoConstraints = YES;
    return result;
}

- (void)referceUIWithIslog:(BOOL)isLog{
    if (isLog) {
        self.zhuceView.hidden = YES;
        self.zhuceViewheigth.constant = 0;
        self.zichanView.hidden = NO;
        self.zichanviewHeight.constant = 80;
        self.viewHeight.constant = 475 - 74;
        if ([UserinfoManager sharedUserinfo].logined) {
            //            self.accountAllMoneyLB.text =   [NSString stringWithFormat:@"%@元",[[UserinfoManager sharedUserinfo].userInfo amount]] ;
        }
        
    }else{
        self.zhuceView.hidden = NO ;
        self.zhuceViewheigth.constant = 74;
        self.zichanView.hidden = YES;
        self.zichanviewHeight.constant = 0;
        self.viewHeight.constant = 475 - 80;
    }
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    //    if (self.needChangeAnimationState) {
    //        [self changeAnimationState];
    //    }
}
- (void)setAInfo:(RecommendProductInfo *)aInfo{
    _aInfo = aInfo;
    
//    self.reteLB.text  =[NSString stringWithFormat:@"%.2f",[aInfo.annualInterest floatValue]] ;
    
    
    if ([aInfo.extannual floatValue] != 0.00f) {
        NSString *rateString = [NSString stringWithFormat:@"%@%%+%@%%",[CommonTools convertToStringWithObject:aInfo.organnual],[CommonTools convertToStringWithObject:aInfo.extannual] ];
        NSString *addString = [NSString stringWithFormat:@"%%+%@%%",[CommonTools convertToStringWithObject:aInfo.extannual] ];
        
        self.reteLB.text = rateString;
    
        
        
        NSMutableAttributedString *noteStr = [[NSMutableAttributedString alloc] initWithString:rateString];
        NSRange redRange = NSMakeRange([[noteStr string] rangeOfString:addString].location, [[noteStr string] rangeOfString:addString].length);
       
        [noteStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:15.0f] range:redRange];
        
        
        [self.reteLB setAttributedText:noteStr];
//        [self.reteLB sizeToFit];
    }else{
        
        NSString *rateString = [NSString stringWithFormat:@"%@%%",[CommonTools convertToStringWithObject:aInfo.organnual] ];
        NSString *addString = [NSString stringWithFormat:@"%%"];
        
        self.reteLB.text = rateString;
        //        NSString
        
        
        NSMutableAttributedString *noteStr = [[NSMutableAttributedString alloc] initWithString:rateString];
        NSRange redRange = NSMakeRange([[noteStr string] rangeOfString:addString].location, [[noteStr string] rangeOfString:addString].length);
        //        [noteStr addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:redRange];
        [noteStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:15.0f] range:redRange];
        
        
        [self.reteLB setAttributedText:noteStr];
//        [self.reteLB sizeToFit];
        //        self.yearRateLB.text = [NSString stringWithFormat:@"%@%%",[CommonTools convertToStringWithObject:aDic[@"organnual"]]];
    }
    self.timeLB.text      = [aInfo theTermOfProduct];
    self.moneyLB.text     = [NSString stringWithFormat:@"%@元", aInfo.restOfShare];
    [self.liketouziBtn setTitle:aInfo.productState forState:UIControlStateNormal];
    NSLog(@"%@ainfo2...",aInfo.productState);
    if (aInfo.canBuy) {
        [self.liketouziBtn setBackgroundImage:[UIImage imageNamed:@"2xanniu"] forState:UIControlStateNormal] ;
        
        
        self.liketouziBtn.enabled = YES;
        
    }else{
        [self.liketouziBtn setBackgroundImage:[UIImage imageNamed:@"2xanniu_gray"] forState:UIControlStateNormal] ;
        
        self.liketouziBtn.enabled = NO;
    }
    
}
//- (void)setAnnouncementInfo:(AnnouncementInfo *)announcementInfo {
//    _announcementInfo = announcementInfo;
//    [self.announcement setTitle:announcementInfo.title forState:UIControlStateNormal];
//    self.announcement.titleLabel.textAlignment = 0;
////    if (self.window) {
////        [self changeAnimationState];
////    } else {
////        self.needChangeAnimationState = YES;
////    }
//}
- (void)setAnnouncementInfos:(NSMutableArray *)announcementInfos{
    _announcementInfos = announcementInfos;
    
    [self.announcement setTitle:_announcementInfos[0][@"src"] forState:UIControlStateNormal];
}
// 以下代码为2.0 上下滚动 动画
#pragma mark - 计时器事件
- (void)timerAction:(NSTimer *)timer{
    
    _count++;
    if (_count == self.announcementInfos.count) {
        _count = 0;
    }
    CGRect rect = self.announcement.frame;
    [UIView animateKeyframesWithDuration:0 delay:0 options:UIViewKeyframeAnimationOptionCalculationModeLinear animations:^{
        if (self.announcementInfos[_count][@"src"] &&[self.announcementInfos[_count][@"src"] length] > 0) {
            [self.announcement setTitle:[NSString stringWithFormat:@"%@",self.announcementInfos[_count][@"src"]] forState:UIControlStateNormal];
        }
        
        [self.announcement setFrame:CGRectMake(rect.origin.x, -35, rect.size.width, rect.size.height)];
    } completion:^(BOOL finished) {
        [self.announcement setFrame:CGRectMake(0, 35, rect.size.width,  rect.size.height)];
        [UIView animateWithDuration:1 animations:^{
            [self.announcement setFrame:rect];
        }];
    }];
    
    if(_count == 0){
        //        self.count == 5;
        //计时器失效, 页面退下
        //        if (self.completionBlock) {
        //            self.completionBlock(NO);
        //        }
    }
}

- (void)changeAnimationState {
    
    if ([self shouldUseScrollAnimation]) {
        [self startAnimation];
    } else {
        [self.announcementView.layer removeAllAnimations];
    }
    self.needChangeAnimationState = NO;
}

//- (IBAction)selectItem:(UITapGestureRecognizer *)sender {
//
//    if (self.selectBlock) {
//        self.selectBlock(sender.view.tag);
//    }
//}

- (IBAction)checkAnnoucement {
    AnnouncementInfo *info = [[AnnouncementInfo alloc] init];
    info.announcementId = self.announcementInfos[_count][@"href"];
    info.title = self.announcementInfos[_count][@"src"];
    if (self.checkSpecificAnnoucement) {
        self.checkSpecificAnnoucement(info);
    }
}
- (IBAction)checkAllAnnoucements {
    
    if (self.checkAllAnnoucemtes) {
        self.checkAllAnnoucemtes();
    }
}
- (IBAction)selectSafeGuard:(UITapGestureRecognizer *)sender {
    if (self.selectBlock) {
        self.selectBlock(sender.view.tag);
    }
    
}
- (IBAction)zhuce:(id)sender {
    if (self.selectBlock) {
        self.selectBlock(4);
    }
}

- (IBAction)TouziBtnClicked:(UIButton *)sender {
    if (self.selectBlock) {
        self.selectBlock(sender.tag);
    }
    
    
}
- (IBAction)zhuceBtnClicked:(UIButton *)sender {
    if (self.selectBlock) {
        self.selectBlock(sender.tag);
    }
    
}
// 以下代码为1.0 左右滚动 动画
- (BOOL)shouldUseScrollAnimation {
    
    return [self textWidth] > self.announcementView.width;
}
- (CGFloat)textWidth {
    
    return [self.announcementInfo.title boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, self.announcementView.height) options:NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:self.announcement.titleLabel.font} context:nil].size.width;
}

- (void)startAnimation {
    
    //    self.scrollAnimation.fromValue = [NSValue valueWithCGRect:CGRectMake(-self.announcementView.width, 0, [self textWidth], self.announcement.height)];
    //    self.scrollAnimation.toValue   = [NSValue valueWithCGRect:CGRectMake([self textWidth], 0, [self textWidth], self.announcement.height)];
    
    //    self.scrollAnimation.fromValue = [NSValue valueWithCGRect:CGRectMake(0, -35, [self textWidth], self.announcement.height)];
    //    self.scrollAnimation.toValue   = [NSValue valueWithCGRect:CGRectMake(0, 35, [self textWidth], self.announcement.height)];
    
    [self.announcementView.layer removeAllAnimations];
    //    [self.announcement.layer addAnimation:self.scrollAnimation forKey:@"scrollAnimation"];
    
    self.needChangeAnimationState = NO;
}

- (CABasicAnimation *)scrollAnimation {
    
    if (!_scrollAnimation) {
        
        CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"bounds"];
        animation.duration = 3;
        animation.removedOnCompletion = NO;
        animation.repeatCount = NSIntegerMax;
        _scrollAnimation = animation;
    }
    return _scrollAnimation;
}


@end

