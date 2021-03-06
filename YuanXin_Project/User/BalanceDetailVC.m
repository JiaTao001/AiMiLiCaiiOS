//
//  BalanceDetailVC.m
//  YuanXin_Project
//
//  Created by Yuanin on 16/1/6.
//  Copyright © 2016年 yuanxin. All rights reserved.
//

#import "BalanceDetailVC.h"

@interface BalanceDetailVC ()

@property (strong, nonatomic) NSURLSessionTask *task;
@property (weak, nonatomic) IBOutlet UIScrollView *contentView;

@property (weak, nonatomic) IBOutlet UILabel *balance;
@property (weak, nonatomic) IBOutlet UILabel *balanceInvalid;
@property (weak, nonatomic) IBOutlet UILabel *balanceInProgress;
@property (weak, nonatomic) IBOutlet UILabel *sumOfRecharge;
@property (weak, nonatomic) IBOutlet UILabel *sumOfWithdraw;
@end

@implementation BalanceDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self changeNavigationBarAlpha:0];
    if (@available(iOS 11.0, *)) {
        self.contentView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        //        self.superTableview.contentInset = UIEdgeInsetsMake(64, 0, 49, 0);
        //        self.superTableview.scrollIndicatorInsets = self.superTableview.contentInset;
    }
    
    [self layoutNavigationLeftButtonWithImage:[UIImage imageNamed:Nav_Back_Image] block:^(__kindof UIViewController *viewController) {
        
        [viewController.navigationController popViewControllerAnimated:YES];
    }];
    [self fetchBalanceDetail];
}
- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    
    [self.task cancel];
}

#pragma mark - action
- (void)fetchBalanceDetail {
    
    self.contentView.hidden = YES;
    
    [BaseIndicatorView showInView:self.view maskType:kIndicatorNoMask];
    
    @weakify(self)
    self.task = [NetworkContectManager sessionPOSTWithMothed:@"useraccountamount" params:[[UserinfoManager sharedUserinfo] increaseUserParams:nil] success:^(NSURLSessionTask *task, id result) {
        @strongify(self)
        
        [BaseIndicatorView hideWithAnimation:self.didShow];
        [self configureInterface:[result[RESULT_DATA] firstObject]];
    } failure:^(NSURLSessionTask *task, id result, NSString *errorDescription) {
        @strongify(self)
        
        [BaseIndicatorView hideWithAnimation:self.didShow];
        [SpringAlertView showMessage:errorDescription];
    }];
    
}

- (void)configureInterface:(NSDictionary *)aDic {
    
    //    返回值  balance（可用余额）、withdraw_amount（提现中金额）、appoint（冻结中金额）、all_recharge_amount（累计充值金额）、all_withdraw_amount（累计提现金额）
    NSParameterAssert(aDic);
    
    self.balance.text           = [CommonTools convertToStringWithObject:aDic[@"balance"]];
    self.balanceInvalid.text    = [CommonTools convertToStringWithObject:aDic[@"appoint"]];
    self.balanceInProgress.text = [CommonTools convertToStringWithObject:aDic[@"withdraw_amount"]];
    self.sumOfRecharge.text     = [CommonTools convertToStringWithObject:aDic[@"all_recharge_amount"]];
    self.sumOfWithdraw.text     = [CommonTools convertToStringWithObject:aDic[@"all_withdraw_amount"]];
    
    self.contentView.hidden = NO;
}


/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end

