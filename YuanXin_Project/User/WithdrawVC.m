//
//  WithdrawVC.m
//  YuanXin_Project
//
//  Created by Yuanin on 15/10/13.
//  Copyright © 2015年 yuanxin. All rights reserved.
//

#import "WithdrawVC.h"

#import "BuySuccessPromptVC.h"
#import "SinaWebVC.h"

#import "KeyboardScrollView.h"
#import "FloatTextField.h"
#import "UIImageView+WebCache.h"

#import "HKWebVC.h"
#define WITHDRAW_EACH_LIMIT 50000.00

@interface WithdrawVC () <UITextFieldDelegate>

@property (strong, nonatomic) NSURLSessionTask *task;
@property (weak, nonatomic) IBOutlet UIImageView *logo;
@property (weak, nonatomic) IBOutlet UILabel *upTitle;
@property (weak, nonatomic) IBOutlet UILabel *upDescription;

@property (weak, nonatomic) IBOutlet KeyboardScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UILabel            *money;
@property (weak, nonatomic) IBOutlet UILabel            *fee;
//@property (weak, nonatomic) IBOutlet UILabel            *number;
@property (weak, nonatomic) IBOutlet UILabel *number;

@property (weak, nonatomic) IBOutlet FloatTextField *withdrawNumber;
@property (strong, nonatomic) NSNumber *withdrawalAmount;
@property (weak, nonatomic) IBOutlet UILabel *moneyLB;
@property (weak, nonatomic) IBOutlet UILabel *cardNumLB;

@property (weak, nonatomic) IBOutlet UILabel *warmLB1;
@property (weak, nonatomic) IBOutlet UILabel *warmLB2;
@property (weak, nonatomic) IBOutlet UILabel *warmLB3;

@property (assign,nonatomic)float singlepay;

@end

@implementation WithdrawVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Do any additional setup after loading the view.
    [self.withdrawNumber becomeFirstResponder];
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
    
    [self fetchCashNeededInformation];
}
- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    
    [self.task cancel];
}

#pragma mark - delegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    [textField resignFirstResponder];
    return YES;
}

- (void)textDidChange:(NSNotification *)notification {
    
    if (notification.object == self.withdrawNumber) {
        
        CGFloat moneyLimit = self.singlepay > [self.withdrawalAmount doubleValue] ? [self.withdrawalAmount doubleValue] : self.singlepay;

        if ([self.withdrawNumber.text doubleValue] > moneyLimit) {
            self.withdrawNumber.text = [NSString stringWithFormat:@"%.2lf", moneyLimit];
        }
        
        CGFloat money   = [self.withdrawNumber.text doubleValue] - [self.fee.text doubleValue];
        self.money.text = [NSString stringWithFormat:@"%.2lf", ( money >= 0 ? money : 0.00)];
    }
}
- (IBAction)allWithdrawClicked:(UIButton *)sender {
    if ([self.moneyLB.text floatValue] > self.singlepay) {
        self.withdrawNumber.text = [NSString stringWithFormat:@"%.2f",self.singlepay];
    }else{
        self.withdrawNumber.text = self.moneyLB.text;
    }
    CGFloat money   = [self.withdrawNumber.text doubleValue] - [self.fee.text doubleValue];
    self.money.text = [NSString stringWithFormat:@"%.2lf", ( money >= 0 ? money : 0.00)];
  
}
- (void)fetchCashNeededInformation {
    
    [BaseIndicatorView showInView:self.view maskType:kIndicatorNoMask];
    @weakify(self)
    self.task = [NetworkContectManager sessionPOSTWithMothed:@"aimi_cash_fee" params:[[UserinfoManager sharedUserinfo] increaseUserParams:nil] success:^(NSURLSessionTask *task, id result) {
        @strongify(self)

        [BaseIndicatorView hideWithAnimation:self.didShow];
        [self configureWithdrawView:[result[RESULT_DATA] firstObject]];
    } failure:^(NSURLSessionTask *task, id result, NSString *errorDescription) {
        @strongify(self)
        
        [BaseIndicatorView hideWithAnimation:self.didShow];
        [SpringAlertView showInWindow:self.view.window message:errorDescription];
    }];
}
- (void)configureWithdrawView:(NSDictionary *)info {
    if (!info.count) return;
    self.withdrawNumber.text = nil;
    self.fee.text           = [CommonTools convertToStringWithObject:info[@"fee"]];
    self.number.text        = [NSString stringWithFormat:@"   本月还有%@次免费提现机会", info[@"qty"]];
    self.withdrawalAmount   = info[@"balance"];
    self.moneyLB.text =  info[@"balance"];
    self.upDescription.text = [NSString stringWithFormat:@"单笔最大限额：%@ 单日限额：%@" ,[info[@"bank"] firstObject][@"singlepay"], [info[@"bank"] firstObject][@"daymaxpay"]];
    self.singlepay =[[info[@"bank"] firstObject][@"singlepay"] floatValue];

    [self.logo loadImageWithPath:[info[@"bank"] firstObject][@"logo"]];
    self.upTitle.text = [NSString stringWithFormat:@"%@ %@", [info[@"bank"] firstObject][@"full_name"], [info[@"bank"] firstObject][@"card_no"]];
    for (int i = 0; i < [info[@"cue"] count]; i++) {
        if (i == 0) {
            self.warmLB1.text = [info[@"cue"] objectAtIndex:0][@"str"];
        }
        if (i == 1) {
            self.warmLB2.text = [info[@"cue"] objectAtIndex:1][@"str"];
        }
        if (i == 2) {
            self.warmLB3.text = [info[@"cue"] objectAtIndex:2][@"str"];
        }
    }

    
    self.scrollView.hidden = NO;
    [self textDidChange:[NSNotification notificationWithName:UITextFieldTextDidChangeNotification object:self.withdrawNumber]];
}


#pragma mark - Action
- (IBAction)sureWithdraw:(UIButton *)sender {
    if ([self.withdrawNumber.text doubleValue] < [self.fee.text doubleValue]) {
        [SpringAlertView showMessage:NSLocalizedString(@"err_money", nil)];
        return;
    }
    if (!self.withdrawNumber.success || ![self.withdrawNumber.text doubleValue]) {
        [SpringAlertView showMessage:NSLocalizedString(@"err_money", nil)];
        return;
    }
    if (0 == [self.money.text doubleValue]) {
        [SpringAlertView showMessage:NSLocalizedString(@"no_enough_money", nil)];
        return;
    }
    NSDictionary *dict = [NSDictionary dictionaryWithObject:self.withdrawNumber.text forKey:@"amount"];
    
    [BaseIndicatorView showInView:self.view maskType:kIndicatorNoMask];
    
    @weakify(self)
    self.task = [NetworkContectManager sessionPOSTWithMothed:@"haikou_cash" params:[[UserinfoManager sharedUserinfo] increaseUserParams:dict] success:^(NSURLSessionTask *task, id result) {
        @strongify(self)
        
        [BaseIndicatorView hideWithAnimation:self.didShow];
        [self pushToNextItemWithUrl:[result[@"data"] firstObject][@"redirect_url"]];
    } failure:^(NSURLSessionTask *task, id result, NSString *errorDescription) {
        @strongify(self)
        
        [BaseIndicatorView hideWithAnimation:self.didShow];
        [SpringAlertView showInWindow:self.view.window message:errorDescription];
    }];
//    [self presentViewController:[SinaWebVC sinaWebWithServerPath:@"sina_cash" params:@{@"amount":self.withdrawNumber.text}] animated:YES completion:nil];
}
- (void)pushToNextItemWithUrl:(NSString *)url{
    HKWebVC *hkWeb = [HKWebVC webVCWithWebPath:url];
    hkWeb.isbackRoot = YES;
    [self.navigationController pushViewController:hkWeb animated:YES];
}

@end
