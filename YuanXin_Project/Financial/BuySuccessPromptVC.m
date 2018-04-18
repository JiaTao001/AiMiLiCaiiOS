//
//  BuySuccessPromptVCViewController.m
//  YuanXin_Project
//
//  Created by Yuanin on 16/1/19.
//  Copyright © 2016年 yuanxin. All rights reserved.
//

#import "BuySuccessPromptVC.h"

#import "BonusEventVC.h"
#import "FeedbackVC.h"
#import "bonusAnimationView.h"
#import "JitterImageView.h"

#define USERDEFAULTS_DID_EVALUATE   @"Did_Evaluate"
#define USERDEFAULTS_BUY_COUNT      @"Buy_Count"


@interface BuySuccessPromptVC ()

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIImageView  *promptImageView;
@property (weak, nonatomic) IBOutlet UILabel      *productName;
@property (weak, nonatomic) IBOutlet UILabel      *indentMoney;
@property (weak, nonatomic) IBOutlet UILabel      *paymentMethod;
@property (weak, nonatomic) IBOutlet UILabel      *platformReward;

@property (strong, nonatomic) JitterImageView *jitterImageView;
@property (strong,nonatomic)bonusAnimationView *bonusAnimationView;


@end

@implementation BuySuccessPromptVC

- (void)viewDidLoad {
    [super viewDidLoad];
        
    [self layoutNavigationLeftButtonWithImage:[UIImage imageNamed:Nav_Back_Image] block:^(BuySuccessPromptVC *viewController) {
            [viewController.navigationController popViewControllerAnimated:YES];
    }];
    
   
    [self.promptImageView loadImageWithPath:self.buyProductInfo[@"banner"]];
    self.productName.text    = self.buyProductInfo[Product_Name];
    self.indentMoney.text    = [NSString stringWithFormat:@"%@元", self.buyProductInfo[Indent_Money]];
    self.platformReward.text = self.buyProductInfo[Platform_Reward];
    self.paymentMethod.text  = self.buyProductInfo[@"repay_method"];
    
    
    if ([self needUserEvaluate]) {
        [AlertViewManager showInViewController:self title:@"" message:@"您的评价是我们前进的动力" clickedButtonAtIndex:^(id alertView, NSInteger buttonIndex) {
            
            switch (buttonIndex) {
                    
                case 0:
                   
                    [self configureBuySuccessPromptVC];
                    break;
                    
                case 1:
                    [USERDEFAULTS setBool:YES forKey:USERDEFAULTS_DID_EVALUATE];
                    [USERDEFAULTS synchronize];
                    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"itms-apps://itunes.apple.com/app/id1055223837"]];
                     [self configureBuySuccessPromptVC];
                    break;
                    
                case 2: {
                    [self.navigationController pushViewController:[AiMiApplication obtainControllerForMainStoryboardWithID:NSStringFromClass([FeedbackVC class])] animated:YES];
                     [self configureBuySuccessPromptVC];
                } break;
                    
            }
        } cancelButtonTitle:@"残忍拒绝" otherButtonTitles:@"给个好评", @"我要吐槽", nil];
    }else{
        [self configureBuySuccessPromptVC];
    }
}
- (void)configureBuySuccessPromptVC {
    
  
    
    if ((1 == [self.buyProductInfo[Have_Red_Key] integerValue]) ) {
        
        @weakify(self)
        [self.bonusAnimationView showInView:[UIApplication sharedApplication].keyWindow clickImage:^{
            @strongify(self)
//            [self.bonusAnimationView removeFromSuperview];
            [self.bonusAnimationView dissMiss];
         
                 [self showJittImageWithAni:YES];
        
           
        }];
        self.bonusAnimationView.ShareBlock = ^(){
            @strongify(self)
            [self.bonusAnimationView removeFromSuperview];
            [self showJittImageWithAni:NO];
            BonusEventVC *vc = [[BonusEventVC alloc] init];
            vc.investID = self.buyProductInfo[@"invest_id"];
            vc.red_type = self.buyProductInfo[@"red_type"];
            [self.navigationController pushViewController:vc animated:YES];
       
        };
            
        

    }
}
- (void)showJittImageWithAni:(BOOL)isAni{
            @weakify(self)
            [self.jitterImageView showInView:self.view withAnimation:isAni  clickImage:^{
                @strongify(self)
                BonusEventVC *vc = [[BonusEventVC alloc] init];
                vc.investID = self.buyProductInfo[@"invest_id"];
                vc.red_type = self.buyProductInfo[@"red_type"];
                [self.navigationController pushViewController:vc animated:YES];
            }];
            self.scrollView.contentInset = UIEdgeInsetsMake(0, 0, self.jitterImageView.height + BIG_MARGIN_DISTANCE, 0);
}
- (BOOL)needUserEvaluate {
    
    BOOL result = NO;
    
    if (![USERDEFAULTS boolForKey:USERDEFAULTS_DID_EVALUATE]) {
        NSInteger buyCount = [USERDEFAULTS integerForKey:USERDEFAULTS_BUY_COUNT] + 1;
        if ( 2 == (buyCount%3) ) {
            result = YES;
        }
        [USERDEFAULTS setInteger:buyCount forKey:USERDEFAULTS_BUY_COUNT];
        [USERDEFAULTS synchronize];
    }
    
    return result;
}

- (IBAction)popToPreVC:(id)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)checkBannerDetail:(UITapGestureRecognizer *)sender {
    
    if (self.buyProductInfo[@"banner_url"]) {
        [self.navigationController pushViewController:[WebVC webVCWithWebPath:self.buyProductInfo[@"banner_url"]] animated:YES];
    }
}
- (IBAction)callServicePhone:(id)sender {
    
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[[NSString alloc] initWithFormat:@"telprompt://%@", SERVICE_PHONE]]];
}

- (JitterImageView *)jitterImageView {
    if (!_jitterImageView) {
        _jitterImageView = [[JitterImageView alloc] init];
    }
    return _jitterImageView;
}
- (bonusAnimationView *)bonusAnimationView{
    if (!_bonusAnimationView) {
        _bonusAnimationView = [[bonusAnimationView alloc]init];
    }
    return _bonusAnimationView;
}

@end
