//
//  AlterPasswordVC.m
//  YuanXin_Project
//
//  Created by Yuanin on 15/10/12.
//  Copyright © 2015年 yuanxin. All rights reserved.
//

#import "AlterPasswordVC.h"

#import "UserinfoManager.h"
#import "LimitTextField.h"

#define OLD_PSD @"oldpassword"
#define NEW_PSD @"newpassword"

@interface AlterPasswordVC ()

@property (strong, nonatomic, readwrite) NSURLSessionTask *task;

@property (weak, nonatomic) IBOutlet LimitTextField *oldPassword;
@property (weak, nonatomic) IBOutlet LimitTextField *password;
@property (weak, nonatomic) IBOutlet LimitTextField *repeatPassword;
@end

@implementation AlterPasswordVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self layoutNavigationLeftButtonWithImage:[UIImage imageNamed:Nav_Back_Image] block:^(UIViewController *viewController) {
        [viewController.navigationController popViewControllerAnimated:YES];
    }];
}
- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    
    [self.task cancel];
}

- (IBAction)alterPassword:(UIButton *)sender
{
    if (!self.oldPassword.success || !self.password.success || !self.repeatPassword.success) {
        [SpringAlertView showMessage:NSLocalizedString(@"err_password", nil)];
        return;
    }
    [self.view endEditing:YES];
    
    if ([self.password.text isEqualToString:self.repeatPassword.text]) {
        [self.task cancel];
        
        NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
        [params setValue:[self.oldPassword.text RSAPublicEncryption] forKey:OLD_PSD];
        [params setValue:[self.password.text RSAPublicEncryption] forKey:NEW_PSD];
        
        [BaseIndicatorView showInView:self.view];
        @weakify(self)
        self.task = [[UserinfoManager sharedUserinfo] startRequest:kUserinfoOperationAlterPassword params:params success:^(id result) {
            @strongify(self)
            
            [SpringAlertView showInWindow:self.view.window message:result[RESULT_REMARK]];
            [self.navigationController popViewControllerAnimated:YES];
            [BaseIndicatorView hideWithAnimation:self.didShow];
        } failure:^(id result, NSString *errorDescription) {
            @strongify(self)
            
            [SpringAlertView showInWindow:self.view.window message:errorDescription];
            [BaseIndicatorView hideWithAnimation:self.didShow];
        }];
    } else {
        
        [SpringAlertView showInWindow:self.view.window message:NSLocalizedString(@"err_same", nil)];
    }
}
@end
