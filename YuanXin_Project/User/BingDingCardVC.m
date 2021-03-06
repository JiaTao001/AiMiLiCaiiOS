//
//  BingDingCardVC.m
//  YuanXin_Project
//
//  Created by Yuanin on 2017/5/9.
//  Copyright © 2017年 yuanxin. All rights reserved.
//

#import "BingDingCardVC.h"
#import "UIViewController+NavigationItem.h"
#import "BaseIndicatorView.h"
#import <ReactiveCocoa/ReactiveCocoa.h>
#import "NetworkContectManager.h"
#import "UserinfoManager.h"
#import "SpringAlertView.h"
#import "LimitTextField.h"
#import "HKWebVC.h"
#import "NSString+ExtendMethod.h"

@interface BingDingCardVC ()
@property (strong, nonatomic) NSURLSessionTask *task;
@property (weak, nonatomic) IBOutlet UILabel *nameLB;
@property (weak, nonatomic) IBOutlet UILabel *idCardLB;

@property (weak, nonatomic) IBOutlet LimitTextField *bankCardNumTF;
@property (weak, nonatomic) IBOutlet LimitTextField *bankPhoneNumTF;
@property (weak, nonatomic) IBOutlet UIButton *bangdingBtn;

@end

@implementation BingDingCardVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self layoutNavigationLeftButtonWithImage:[UIImage imageNamed:Nav_Back_Image] block:^(__kindof UIViewController *viewController) {
        [viewController.navigationController popViewControllerAnimated:YES];
    }];
     [self fetchRealNameInfo];
    // Do any additional setup after loading the view.
}
- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    
    [self.task cancel];
}

- (void)fetchRealNameInfo {
    
    [BaseIndicatorView showInView:self.view maskType:kIndicatorNoMask];
    @weakify(self)
    self.task = [NetworkContectManager sessionPOSTWithMothed:@"getcertified" params:[[UserinfoManager sharedUserinfo] increaseUserParams:nil] success:^(NSURLSessionTask *task, id result) {
        @strongify(self)
        
//        self.showView.hidden = NO;
        self.nameLB.text = [result[RESULT_DATA] firstObject][KEY_CERIFIER];
        self.idCardLB.text = [result[RESULT_DATA] firstObject][KEY_IDCARD];
        [BaseIndicatorView hideWithAnimation:self.didShow];
    } failure:^(NSURLSessionTask *task, id result, NSString *errorDescription) {
        @strongify(self)
        
        [SpringAlertView showMessage:errorDescription];
        [BaseIndicatorView hideWithAnimation:self.didShow];
    }];
}
- (IBAction)bangdingBtnClicked:(id)sender {
    if (!self.bankCardNumTF.success) {
        [SpringAlertView showMessage:@"请输入正确的银行卡号"];
        return;
    }
    if (!self.bankPhoneNumTF.success) {
        [SpringAlertView showMessage:NSLocalizedString(@"err_phone", nil)];
        return;
    }
    
    [self.view endEditing:YES];
    
    NSMutableDictionary *params = [[NSMutableDictionary alloc] initWithDictionary:@{ @"card_no":[self.bankCardNumTF.text RSAPublicEncryption], @"card_mobile":[self.bankPhoneNumTF.text RSAPublicEncryption]}];
    
    
    [BaseIndicatorView showInView:self.view];
    @weakify(self)
    self.task = [[UserinfoManager sharedUserinfo] startRequest:kUserinfoOperationbangka params:params success:^(id result) {
        @strongify(self)
        [BaseIndicatorView hideWithAnimation:self.didShow];
        
        [SpringAlertView showInWindow:self.view.window message:result[RESULT_REMARK]];
        [self pushToNextItemWithUrl:[result[@"data"] firstObject][@"redirect_url"]];
    } failure:^( id result, NSString *errorDescription) {
        @strongify(self)
        
        [BaseIndicatorView hideWithAnimation:self.didShow];
        [SpringAlertView showInWindow:self.view.window message:errorDescription];
    }];
    
    //     [BaseIndicatorView showInView:self.view];
    //    @weakify(self)
    //    [NetworkContectManager sessionPOSTWithMothed:@"personal_register" params:[UserinfoManager sharedUserinfo] success:^(NSURLSessionTask *task, id result) {
    //        @strongify(self)
    //
    //         [BaseIndicatorView hideWithAnimation:self.didShow];
    //    } failure:^(NSURLSessionTask *task, id result, NSString *errorDescription) {
    //        [BaseIndicatorView hideWithAnimation:self.didShow];
    //        [SpringAlertView showMessage:errorDescription];
    //    }];
}
- (void)pushToNextItemWithUrl:(NSString *)url{
    HKWebVC *hkWeb = [HKWebVC webVCWithWebPath:url];
    hkWeb.FinishBlock = ^(){
        [self.navigationController popViewControllerAnimated:YES];
    };
    [self.navigationController pushViewController:hkWeb animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
