//
//  ProductDetailVC.m
//  YuanXin_Project
//
//  Created by Yuanin on 15/12/4.
//  Copyright © 2015年 yuanxin. All rights reserved.
//

#import "ProductDetailVC.h"

#import "LoginNavigationController.h"
#import "BuyFinanicalItemVC.h"
#import "IncomeCalculatorVC.h"
#import "PastProductsVC.h"
#import "CalculationOfInterest.h"

#import "ProductDetailView.h"
#import "WarmmingView.h"
#import "TheTimeCountDown.h"
#import "WebVC.h"
///////////////////////////**********************************************

@interface ProductDetailVC () <UIScrollViewDelegate, UIWebViewDelegate>

@property (strong, nonatomic) NSURLSessionTask *task;

@property (weak, nonatomic) IBOutlet UIView             *contentView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *scrollTopConstraint;
@property (strong, nonatomic) ProductDetailView  *productDetailView;
@property (assign, nonatomic) BOOL showFirstViewOrSecondView;   /**< YES show first NO show detail  */
@property (weak, nonatomic) IBOutlet UIImageView *topbackImageView;

@property (weak, nonatomic) IBOutlet UIView *shengyuTimeVIew;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *shengyuTimeVIewHeight;

@property (weak, nonatomic) IBOutlet UIImageView *stepImageView;
// 加息
@property (weak, nonatomic) IBOutlet UILabel *AddRateLB;
@property (assign, nonatomic) InterestCalculationPatternType type;
@property (strong, nonatomic) TheTimeCountDown *theTimeCountDown;
@property (strong, nonatomic) CalculationOfInterest *interestCalculation;
@property (weak, nonatomic) IBOutlet UILabel        *name;
//@property (weak, nonatomic) IBOutlet UILabel        *productStatus;
@property (weak, nonatomic) IBOutlet UILabel        *sumOfLimit;
@property (weak, nonatomic) IBOutlet UILabel        *yield;
@property (weak, nonatomic) IBOutlet UILabel        *timeLimit;
//@property (weak, nonatomic) IBOutlet UILabel        *unit;
//@property (weak, nonatomic) IBOutlet UILabel        *surplusMoney;
//@property (weak, nonatomic) IBOutlet UILabel        *percentage;
//@property (weak, nonatomic) IBOutlet UIProgressView *percentageView;
@property (weak, nonatomic) IBOutlet UILabel *yearRateLB;

@property (weak, nonatomic) IBOutlet UILabel *remainingTime;
//@property (weak, nonatomic) IBOutlet UILabel *remainingTimeDescription;
//@property (weak, nonatomic) IBOutlet UILabel *investmentConstraints;
//@property (weak, nonatomic) IBOutlet UILabel *investmentConstraintsDescription;
@property (weak, nonatomic) IBOutlet UILabel *replyMethod;
//@property (weak, nonatomic) IBOutlet UILabel *replyMethodDescription;
//@property (weak, nonatomic) IBOutlet UILabel *supportMethods;
//@property (weak, nonatomic) IBOutlet UILabel *supportMethodsDescription;
@property (weak, nonatomic) IBOutlet UILabel *amountLB;
//@property (weak, nonatomic) IBOutlet UILabel *wanyuanShouyiLB;

//@property (weak, nonatomic) IBOutlet UIButton *calculator;
@property (weak, nonatomic) IBOutlet UIButton *buy;

@property (weak, nonatomic) IBOutlet UILabel *BuyStartLB;
@property (weak, nonatomic) IBOutlet UILabel *manbiaoTimeLB;
@property (weak, nonatomic) IBOutlet UILabel *qixiTimeLB;

@property (weak, nonatomic) IBOutlet UILabel *finishTimeLB;
//@property (weak, nonatomic) IBOutlet NSLayoutConstraint *manbiaoLBX;
//@property (weak, nonatomic) IBOutlet NSLayoutConstraint *manbiaoTimeLBX;
//@property (weak, nonatomic) IBOutlet NSLayoutConstraint *qixiLBX;
//@property (weak, nonatomic) IBOutlet NSLayoutConstraint *qixiTImeLBX;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *manbiaoTimeLBLeft;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *manbiaoLBLeft;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *qixiLBLeft;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *qixiTimeLBLeft;
@property (weak, nonatomic) IBOutlet UILabel *MuJiTimeLB;

@property (strong, nonatomic) NSString *yearRate;
@property (strong, nonatomic) NSString *expires;
@property (strong, nonatomic) NSString *unit;
@property (strong,nonatomic)WarmmingView *warmmingView;
@end

@implementation ProductDetailVC

#pragma mark - life cycle

- (void)viewDidLoad
{
    [super viewDidLoad];
//    [self changeNavigationBarAlpha:0];
//    self.contentView.hidden = self.buy.hidden = self.calculator.hidden = YES;
     self.contentView.hidden = self.buy.hidden  = YES;
    _showFirstViewOrSecondView = YES;
    
     self.topbackImageView.image = [UIImage imageNamed:@"userCenter_backImage"];
    
    

    
    NSInteger lineWidth  = [UIScreen mainScreen].bounds.size.width - 60;
    self.manbiaoLBLeft.constant = lineWidth * 3/11.0 -75;
    
    self.manbiaoTimeLBLeft.constant = lineWidth *3/11.0 -3;
    
    self.qixiLBLeft.constant = lineWidth *3/11.0 - 50;
    
    self.qixiTimeLBLeft.constant = lineWidth *3/11.0 - 65;
    [self layoutNavigationLeftButtonWithImage:[UIImage imageNamed:Nav_Back_Image] block:^(__kindof UIViewController *viewController) {
        [viewController.navigationController popViewControllerAnimated:YES];
    }];
    
    if (self.productInfo.isRegular && self.needShowPastProject) {
        [self layoutNavigationRightButtonWithTitle:@"往期项目" color:nil block:^(ProductDetailVC *viewController) {
            
            PastProductsVC *vc = [AiMiApplication obtainControllerForMainStoryboardWithID:PAST_PROJUCTS_STORYBOARD_ID];
            
            vc.productID = viewController.productInfo.productID;
            [viewController.navigationController pushViewController:vc animated:YES];
        }];
    }
    
    @weakify(self)
    [[[NSNotificationCenter defaultCenter] rac_addObserverForName:kProductDidBuyNotification object:nil] subscribeNext:^(NSNotification *notification) {
        @strongify(self)
        
        NSDictionary *param = notification.object;
        if ([param[BUY_PRODUCTID_KEY] isEqualToString:self.productInfo.productID]) {
//            self.surplusMoney.text = [NSString stringWithFormat:@"%li", (long)(self.surplusMoney.text.integerValue - [param[BUY_MONEY_KEY] integerValue])];
            //计算完成了多少
//            self.percentage.text = [NSString stringWithFormat:@"%li", (long)(100*(self.sumOfLimit.text.integerValue - self.surplusMoney.text.integerValue)/self.sumOfLimit.text.integerValue)];
            //更改进度条
//            self.percentageView.progress = self.percentage.text.doubleValue/100;
        }
    }];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self contentViewAddProductDetailView];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    
    [self.task cancel];
}

#pragma mark - UIScrollView delegate
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if ( scrollView.contentOffset.y + scrollView.height > scrollView.contentSize.height + SHOULD_CHANGE_SHOW_VIEW_DISTANCE) {
        self.showFirstViewOrSecondView = NO;
    }
}

#pragma mark - action

- (IBAction)safeShuoming:(UIButton *)sender {
    
    @weakify(self)
    [self.warmmingView showInView:[UIApplication sharedApplication].keyWindow WithImageName:@"safeLevel" clickImage:^{
        @strongify(self)
        //            [self.bonusAnimationView removeFromSuperview];
        [self.warmmingView dissMiss];
        
    }];
    self.warmmingView.ShareBlock = ^(){
        @strongify(self)
        [self.warmmingView dissMiss];
        
        
        

        
        
        
    };
    
}

- (void)fetchProductDetail
{
    [BaseIndicatorView showInView:self.view maskType:kIndicatorNoMask];
    @weakify(self)
    self.task = [NetworkContectManager sessionPOSTWithMothed:@"getproductdetailbytype" params:@{@"productid":self.productInfo.productID} success:^(NSURLSessionTask *task, id result) {
        @strongify(self)
        
        [self configureInterface:[result[RESULT_DATA] firstObject]];
        [BaseIndicatorView hideWithAnimation:self.didShow];
    } failure:^(NSURLSessionTask *task, id result, NSString *errorDescription) {
        @strongify(self)
        
        [BaseIndicatorView hideWithAnimation:self.didShow];
        [SpringAlertView showMessage:errorDescription];
    }];
}

- (void)configureInterface:(NSDictionary *)aDic
{
    self.name.text          = aDic[@"project_name"];
//    self.productStatus.text = aDic[@"repay_method"];
//    self.unit.text          = aDic[@"unit"];
//    self.surplusMoney.text  = [CommonTools convertToStringWithObject:aDic[@"buyamount"]];
//    self.percentage.text    = [CommonTools convertToStringWithObject:aDic[@"percentage"]];
//    self.timeLimit.text     = [CommonTools convertToStringWithObject:aDic[@"term"]];
//    self.sumOfLimit.text    = [CommonTools convertToStringWithObject:aDic[@"amount"]];
    self.timeLimit.text     = [CommonTools convertToStringWithObject:aDic[@"buyamount"]];
    self.sumOfLimit.text    = [CommonTools convertToStringWithObject:aDic[@"term"]];
    self.amountLB.text =[NSString stringWithFormat:@"%@元",[CommonTools convertToStringWithObject:aDic[@"amount"]]] ;
//    self.yield.text         = [CommonTools convertToStringWithObject:aDic[@"annual"]];
     self.yield.text         = [CommonTools convertToStringWithObject:aDic[@"eachamount"]];
    
    if ([aDic[@"extannual"] floatValue] != 0.00f) {
        NSString *rateString = [NSString stringWithFormat:@"%@%%+%@%%",[CommonTools convertToStringWithObject:aDic[@"organnual"]],[CommonTools convertToStringWithObject:aDic[@"extannual"]] ];
        NSString *addString = [NSString stringWithFormat:@"%%+%@%%",[CommonTools convertToStringWithObject:aDic[@"extannual"]] ];
        
        self.yearRateLB.text = rateString;
//        NSString
        
        
        NSMutableAttributedString *noteStr = [[NSMutableAttributedString alloc] initWithString:rateString];
        NSRange redRange = NSMakeRange([[noteStr string] rangeOfString:addString].location, [[noteStr string] rangeOfString:addString].length);
//        [noteStr addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:redRange];
        [noteStr addAttribute:NSFontAttributeName value:[UIFont boldSystemFontOfSize:15.0f] range:redRange];
        
        
        [self.yearRateLB setAttributedText:noteStr];
        [self.yearRateLB sizeToFit];
    }else{
        
        NSString *rateString = [NSString stringWithFormat:@"%@%%",[CommonTools convertToStringWithObject:aDic[@"organnual"]] ];
        NSString *addString = [NSString stringWithFormat:@"%%"];
        
        self.yearRateLB.text = rateString;
        //        NSString
        
        
        NSMutableAttributedString *noteStr = [[NSMutableAttributedString alloc] initWithString:rateString];
        NSRange redRange = NSMakeRange([[noteStr string] rangeOfString:addString].location, [[noteStr string] rangeOfString:addString].length);
        //        [noteStr addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:redRange];
        [noteStr addAttribute:NSFontAttributeName value:[UIFont boldSystemFontOfSize:15.0f] range:redRange];
        
        
        [self.yearRateLB setAttributedText:noteStr];
        [self.yearRateLB sizeToFit];
//        self.yearRateLB.text = [NSString stringWithFormat:@"%@%%",[CommonTools convertToStringWithObject:aDic[@"organnual"]]];
    }
    
    
//    self.yearRateLB.text = [CommonTools convertToStringWithObject:aDic[@"annual"]];
//    self.remainingTimeDescription.text = aDic[@"full_con"];
//    self.investmentConstraints.text = [NSString stringWithFormat:@"每份金额%@元", aDic[@"eachamount"]];
//    self.investmentConstraintsDescription.text = aDic[@"invest_con"];
    self.replyMethod.text = aDic[@"repay_method"];
//    self.replyMethodDescription.text = aDic[@"repay_con"];
//    self.supportMethods.text = aDic[@"guaranteecompany"];
//    self.supportMethodsDescription.text = aDic[@"guarantee_con"];
    
    self.BuyStartLB.text = aDic[@"buystarttime"];
    self.manbiaoTimeLB.text = aDic[@"manbiao_time"];
    self.qixiTimeLB.text = aDic[@"interestdate"];
    self.finishTimeLB.text = aDic[@"expire_time"];
    
    self.stepImageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"chanpingaiyao0%@",aDic[@"step"]]];
    
//    [self.percentageView setProgress:self.percentage.text.doubleValue/100 animated:YES];
    self.buy.enabled = 1 == [aDic[@"isbuy"] intValue];
    [self.buy setTitle:aDic[@"statusname"] forState:UIControlStateNormal];
    if (self.buy .enabled) {
        self.theTimeCountDown.seconds = [aDic[@"buylasttime"] integerValue];
        self.shengyuTimeVIew.hidden = NO;
        self.shengyuTimeVIewHeight.constant = 38;
    } else {
        [self.theTimeCountDown.theCountDown stopCountDown];
        self.remainingTime.text = aDic[@"statusname"];
        self.MuJiTimeLB.text = aDic[@"recruitmentperiod"];
        self.shengyuTimeVIew.hidden = YES;
        self.shengyuTimeVIewHeight.constant = 0;
    }
    
    self.productDetailView.projectInfo = aDic;
    
//    self.contentView.hidden = self.buy.hidden = self.calculator.hidden = NO;
     self.contentView.hidden = self.buy.hidden =  NO;
    
    NSString *repayMethod = aDic[@"repay_method"];
    if ([@"先息后本" isEqualToString:repayMethod]) {
        self.type = kInterestCalculationPatternFirstInterest;
    } else if ([@"等额本息" isEqualToString:repayMethod]) {
        self.type = kInterestCalculationPatternAverageCapitalPlusInterest;
    } else if ([@"到期还本付息" isEqualToString:repayMethod]) {
        self.type = kInterestCalculationPatternOnce;
    } else if ([@"等额本金" isEqualToString:repayMethod]) {
        self.type = kInterestCalculationPatternAverageCapital;
    }
//    self.wanyuanShouyiLB.text = [CalculationOfInterest calculationOfInterestWithCalculationPattern:self.type yield:[aDic[@"annual"] floatValue] expires:@(10000)];
    
        self.yearRate = [CommonTools convertToStringWithObject:aDic[@"annual"]];
        self.expires = [CommonTools convertToStringWithObject:aDic[@"term"]];
        self.unit = aDic[@"unit"];
    
    self.interestCalculation.money = 10000;
//    self.wanyuanShouyiLB.text   = [NSString stringWithFormat:@"%.2f元", self.interestCalculation.sumOfInterest];

}
- (IBAction)hetongFanben:(UIButton *)sender {
    
    WebVC *vc = [[WebVC alloc] initWithWebPath:@"https://shres.aimilicai.com/contract/template/MI20180312002N.pdf"];
    [self.navigationController pushViewController:vc animated:YES];
}
//收益计算器
//- (IBAction)pushToCalculator
//{
//    IncomeCalculatorVC *vc = [AiMiApplication obtainControllerForMainStoryboardWithID:INCOME_CALCULATOR_STORYBOARD_ID];
//    
//    vc.yield = self.yield.text;
//    vc.expires = self.timeLimit.text;
//    vc.unit = self.unit.text;
//    vc.type = self.type;
//    
//    [self.navigationController pushViewController:vc animated:YES];
//}

- (IBAction)snapUp:(UIButton *)sender
{
    if ([UserinfoManager sharedUserinfo].logined) {
        BuyFinanicalItemVC *vc = [AiMiApplication obtainControllerForMainStoryboardWithID:BUY_FINANICAL_STORYBOARD_ID];
        
        vc.productInfo = self.productInfo;
        vc.canIntoProductDetail = NO;
        [self.navigationController pushViewController:vc animated:YES];
    } else {
        
        [self.tabBarController presentViewController:[AiMiApplication obtainControllerForStoryboard:LOGIN_STORYBOARD_NAME controller:LOGIN_NAVIGARION_STORYBOARD_ID] animated:YES completion:nil];
    }
}

- (void)contentViewAddProductDetailView
{
    if (nil == self.productDetailView.superview) {
        self.productDetailView.frame = CGRectMake(0, CGRectGetMaxY(self.contentView.frame), self.contentView.width, self.contentView.height);
        [self.contentView addSubview:self.productDetailView];
        [self.contentView sendSubviewToBack:self.productDetailView];
        
        [self.contentView layoutIfNeeded];
    }
}

#pragma mark - Getter
- (ProductDetailView *)productDetailView
{
    if (!_productDetailView) {
        _productDetailView = [ProductDetailView productDetailView];
        @weakify(self)
        _productDetailView.shouldChangeShowView = ^{
            @strongify(self)
            self.showFirstViewOrSecondView = YES;
        };
    }
    return _productDetailView;
}

- (TheTimeCountDown *)theTimeCountDown
{
    if (!_theTimeCountDown) {
        @weakify(self)
        _theTimeCountDown = [TheTimeCountDown theTimeCountDownWithSecond:0 countDown:^(TheTimeCountDown *countDown) {
            @strongify(self)
            
            if (countDown.theCountDown.numberOfAfterCountDown <= 0) {
                
                self.remainingTime.text = @"募集已结束";
                self.buy.enabled = NO;
                [self fetchProductDetail];
            } else if (self.buy.enabled) {
                self.remainingTime.text = [NSString stringWithFormat:@"%@天%@时%@分%@秒", countDown.secondsConversionTime.day,countDown.secondsConversionTime.hour,countDown.secondsConversionTime.min,countDown.secondsConversionTime.sec];
            }
        }];
    }
    return _theTimeCountDown;
}

#pragma mark - Setter
- (void)setProductInfo:(SingleProductInfo *)productInfo
{
    _productInfo = productInfo;
    
    self.productDetailView.productID = productInfo.productID;
    
    [self fetchProductDetail];
}

- (void)setShowFirstViewOrSecondView:(BOOL)showFirstViewOrSecondView
{
    if (_showFirstViewOrSecondView == showFirstViewOrSecondView) {
        return;
    }
    [self contentViewAddProductDetailView];

    _showFirstViewOrSecondView = showFirstViewOrSecondView;
    
    self.scrollTopConstraint.constant = showFirstViewOrSecondView ? 0 : -CGRectGetHeight(self.contentView.frame);
    [UIView animateWithDuration:0.5f delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        
        self.productDetailView.frame = CGRectMake(0, showFirstViewOrSecondView ? CGRectGetHeight(self.contentView.frame) : 0, CGRectGetWidth(self.contentView.frame), CGRectGetHeight(self.contentView.frame));
        [self.contentView layoutIfNeeded];
    } completion:nil];
}
- (CalculationOfInterest *)interestCalculation {
    
    if (!_interestCalculation) {
        
        NSInteger expires = self.expires.integerValue;
        CGFloat yield = self.yearRate.doubleValue/100;
        if ([@"天" isEqualToString:self.unit]) {
            yield = yield*expires/30; //将天的利率转为一个月的利率额度
            expires = 1;
        }
        _interestCalculation = [[CalculationOfInterest alloc] initWithCalculationPattern:self.type yield:yield expires:expires];
    }
    return _interestCalculation;
}

- (WarmmingView *)warmmingView{
    if (!_warmmingView) {
        _warmmingView = [[WarmmingView alloc]init];
    }
    return _warmmingView;
}


@end
