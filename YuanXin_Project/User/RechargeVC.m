//
//  RechargeVC.m
//  YuanXin_Project
//
//  Created by Yuanin on 15/10/13.
//  Copyright © 2015年 yuanxin. All rights reserved.
//

#import "RechargeVC.h"
#import "BuySuccessPromptVC.h"
#import "SinaWebVC.h"

#import "KeyboardScrollView.h"
#import "FloatTextField.h"
#import "UIImageView+WebCache.h"
#import "HKWebVC.h"

#define BANKCARD_LOGO      @"logo"
#define BANKCARD_NAME      @"full_name"
#define BANKCARD_NUM       @"card_no"
#define BANKCARD_LIMIT     @"singlepay"
#define BANKCARD_LIMIT_DAY @"daymaxpay"

@interface RechargeVC ()

@property (strong, nonatomic) NSURLSessionTask *task;

@property (weak, nonatomic) IBOutlet KeyboardScrollView *scrollView;
@property (weak, nonatomic) IBOutlet FloatTextField *money;
@property (weak, nonatomic) IBOutlet UIImageView *logo;
@property (weak, nonatomic) IBOutlet UILabel *upTitle;
@property (weak, nonatomic) IBOutlet UILabel *upDescription;
@property (strong, nonatomic) NSDictionary *bankcardInfo;
@property (weak, nonatomic) IBOutlet UILabel *accountMoneyLB;

@property (weak, nonatomic) IBOutlet UILabel *allMoneyLB;
@end

@implementation RechargeVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    [self.money becomeFirstResponder];
    
    [self layoutNavigationLeftButtonWithImage:[UIImage imageNamed:Nav_Back_Image] block:^(UIViewController *viewController) {
        [viewController.navigationController popViewControllerAnimated:YES];
    }];
    @weakify(self)
    [[[NSNotificationCenter defaultCenter] rac_addObserverForName:UITextFieldTextDidChangeNotification object:nil] subscribeNext:^(id x) {
        @strongify(self)
        [self textDidChange:x];
        
    }];
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.money.text = nil;
    [self fetchBankCardInfo];
}
- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    
    [self.task cancel];
}

- (void)textDidChange:(NSNotification *)notification {
    
    if (notification.object == self.money && self.bankcardInfo) {//点不能是第一个
       
        
        if ([self.money.text doubleValue] > [self.bankcardInfo[@"singlepay"] doubleValue]) {
            self.money.text = [CommonTools convertToStringWithObject:self.bankcardInfo[@"singlepay"]];
        }
    }
    self.allMoneyLB.text = [NSString stringWithFormat:@"%.2f",([self.money.text floatValue] + [self.accountMoneyLB.text floatValue])];
}

- (IBAction)recharge:(UIButton *)sender {
    if ([self.money.text doubleValue] < [self.bankcardInfo[@"min_recharge"] doubleValue]) {
//        self.money.text = [CommonTools convertToStringWithObject:self.bankcardInfo[@"min_recharge"]];
        [SpringAlertView showMessage:NSLocalizedString(@"err_money", nil)];
        return;
    }
    if (!self.money.success) {
        [SpringAlertView showMessage:NSLocalizedString(@"err_money", nil)];
        return;
    }
//    if (self.money.text.doubleValue < [UserinfoManager sharedUserinfo].userInfo.minRechargeMoney.doubleValue) {
//        [SpringAlertView showMessage:[NSString stringWithFormat:@"请至少充值%@元", [UserinfoManager sharedUserinfo].userInfo.minRechargeMoney]];
//        return;
//    }
    
    NSDictionary *dict = [NSDictionary dictionaryWithObject:self.money.text forKey:@"amount"];
    
    [BaseIndicatorView showInView:self.view maskType:kIndicatorNoMask];
    
    @weakify(self)
    self.task = [NetworkContectManager sessionPOSTWithMothed:@"haikou_recharge" params:[[UserinfoManager sharedUserinfo] increaseUserParams:dict] success:^(NSURLSessionTask *task, id result) {
        @strongify(self)
        
        [BaseIndicatorView hideWithAnimation:self.didShow];
        [self pushToNextItemWithUrl:[result[@"data"] firstObject][@"redirect_url"]];
    } failure:^(NSURLSessionTask *task, id result, NSString *errorDescription) {
        @strongify(self)
        
        [BaseIndicatorView hideWithAnimation:self.didShow];
        [SpringAlertView showInWindow:self.view.window message:errorDescription];
    }];
}
- (void)pushToNextItemWithUrl:(NSString *)url{
    HKWebVC *hkWeb = [HKWebVC webVCWithWebPath:url];
    hkWeb.isbackRoot = YES;
    [self.navigationController pushViewController:hkWeb animated:YES];
}

- (void)fetchBankCardInfo {
    
    [BaseIndicatorView showInView:self.view maskType:kIndicatorNoMask];
    
    @weakify(self)
    self.task = [NetworkContectManager sessionPOSTWithMothed:@"haikou_bank_amount" params:[[UserinfoManager sharedUserinfo] increaseUserParams:nil] success:^(NSURLSessionTask *task, id result) {
        @strongify(self)
        
        [BaseIndicatorView hideWithAnimation:self.didShow];
        [self configureBankcardInfo:[result[RESULT_DATA] firstObject]];
    } failure:^(NSURLSessionTask *task, id result, NSString *errorDescription) {
        @strongify(self)
        
        [BaseIndicatorView hideWithAnimation:self.didShow];
        [SpringAlertView showInWindow:self.view.window message:errorDescription];
    }];
}
- (void)configureBankcardInfo:(NSDictionary *)aDic {
    self.accountMoneyLB.text = aDic[@"balance"];
    
    self.allMoneyLB.text = aDic[@"balance"];
        
    self.bankcardInfo = [aDic[@"bank"] firstObject];
   
    self.scrollView.hidden = NO;
}

- (void)setBankcardInfo:(NSDictionary *)bankcardInfo {
    _bankcardInfo = bankcardInfo;
    self.money.placeholder = [NSString stringWithFormat:@"单笔最小限额%@", bankcardInfo[@"min_recharge"]];
    [self.logo loadImageWithPath:bankcardInfo[@"logo"]];
    self.upTitle.text = [NSString stringWithFormat:@"%@   %@", bankcardInfo[@"full_name"], bankcardInfo[@"card_no"]];
    self.upDescription.text = [NSString stringWithFormat:@"单笔最大限额：%@ 单日限额：%@" ,bankcardInfo[@"singlepay"], bankcardInfo[@"daymaxpay"]];
}


@end

