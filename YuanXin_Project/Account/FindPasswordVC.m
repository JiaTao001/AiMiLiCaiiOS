//
//  FindPasswordViewController.m
//  YuanXin_Project
//
//  Created by Sword on 15/9/21.
//  Copyright © 2015年 yuanxin. All rights reserved.
//

#import "FindPasswordVC.h"
#import "VerifyCodeButton.h"
#import "LimitTextField.h"
#import "UINavigationBar+BackgroundColor.h"
#import "UserinfoManager.h"
#import "setSecretViewController.h"
#import "KeyboardScrollView.h"
#define FIND_PASSWORD_SMS_TYPE @"forgetpwd"

@interface FindPasswordVC ()<UITextFieldDelegate>

@property (strong, nonatomic) NSURLSessionTask *task;

@property (weak, nonatomic) IBOutlet UIButton *nextBtn;
@property (weak, nonatomic) IBOutlet LimitTextField *account;
//@property (weak, nonatomic) IBOutlet LimitTextField *verifyCode;
//@property (weak, nonatomic) IBOutlet LimitTextField *password;
@property (weak, nonatomic) IBOutlet KeyboardScrollView *scrollView;
@end

@implementation FindPasswordVC

- (void)viewDidLoad
{
    [super viewDidLoad];
//     [self.navigationController.navigationBar setCustomBackgroundColor:Theme_Color];
    [self.navigationController.navigationBar setCustomBackgroundColor:[UIColor clearColor]];
//    [self layoutNavigationLeftButtonWithImage:[UIImage imageNamed:Nav_Back_Image] block:^(UIViewController *viewController) {
//        [viewController.navigationController popViewControllerAnimated:YES];
//    }];
    [self layoutNavigationLeftButtonWithImage:[UIImage imageNamed:@"返回"] block:^(UIViewController *viewController) {
        
        [self.navigationController popViewControllerAnimated:YES];
    }];
    self.scrollView.alwaysBounceHorizontal = NO;
    
    UIView *view1 = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 20, 20)];
    UIImageView *image1=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"shouji@2x"]];
    image1.frame=CGRectMake(5, 2, 15, 15);
    [view1 addSubview:image1];
    self.account.leftView=view1;
    self.account.leftViewMode=UITextFieldViewModeAlways;
//    self.nextBtn.enabled = NO;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFiledDidChange) name:UITextFieldTextDidChangeNotification object:nil];
    
    
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self  name:UITextFieldTextDidChangeNotification object:nil];
}
- (void)textFiledDidChange{
    if (self.account.text.length==11 ) {
        self.nextBtn.enabled = YES;
    }else{
        self.nextBtn.enabled = NO;
    }
}
- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    
    [self.task cancel];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}
- (void)textFieldDidEndEditing:(UITextField *)textField{
    
    if (self.account.text.length==11 ) {
        self.nextBtn.enabled = YES;
    }else{
        self.nextBtn.enabled = NO;
    }
}
//- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
//    if (self.account.text.length>=11 ) {
//        self.nextBtn.enabled = YES;
//    }else{
//        self.nextBtn.enabled = NO;
//    }
//    return YES;
//}

#pragma mark - action
//- (IBAction)fetchAuthCode:(VerifyCodeButton *)sender
//{
//    if (self.account.success) {
//        
//        [self.view endEditing:YES];
//        [BaseIndicatorView showInView:self.view maskType:kIndicatorMaskContent];
//        @weakify(self)
//        self.task = [NetworkContectManager sessionPOSTWithMothed:SMS_SEND params:@{KEY_MOBILE:[self.account.text RSAPublicEncryption], VERIFY_CODE_TYPE_KEY:FIND_PASSWORD_SMS_TYPE} success:^(NSURLSessionTask *task, id result) {
//            @strongify(self)
//            
//            [SpringAlertView showInWindow:self.view.window message:result[RESULT_REMARK]];
//            [sender countDown:AUTHCODE_REPEAT_INTERVAL];
//            [BaseIndicatorView hideWithAnimation:self.didShow];
//        } failure:^(NSURLSessionTask *task, id result, NSString *errorDescription) {
//            @strongify(self)
//            
//            [SpringAlertView showInWindow:self.view.window message:errorDescription];
//            [BaseIndicatorView hideWithAnimation:self.didShow];
//        }];
//        
//    } else {
//        [SpringAlertView showMessage:NSLocalizedString(@"err_phone", nil)];
//    }
//}

- (IBAction)findPassword:(UIButton *)sender
{
   
    
    
        if (self.account.success) {
    
            [self.view endEditing:YES];
            [BaseIndicatorView showInView:self.view maskType:kIndicatorMaskContent];
            @weakify(self)
            self.task = [NetworkContectManager sessionPOSTWithMothed:SMS_SEND params:@{KEY_MOBILE:[self.account.text RSAPublicEncryption], VERIFY_CODE_TYPE_KEY:FIND_PASSWORD_SMS_TYPE} success:^(NSURLSessionTask *task, id result) {
                @strongify(self)
    
                [SpringAlertView showInWindow:self.view.window message:result[RESULT_REMARK]];
//                [sender countDown:AUTHCODE_REPEAT_INTERVAL];
                [BaseIndicatorView hideWithAnimation:self.didShow];
                [self performSegueWithIdentifier:SET_SERTRET_SEGUE_IDENTIFIER sender:self];
              
                
            } failure:^(NSURLSessionTask *task, id result, NSString *errorDescription) {
                @strongify(self)
    
                [SpringAlertView showInWindow:self.view.window message:errorDescription];
                [BaseIndicatorView hideWithAnimation:self.didShow];
            }];
    
        } else {
            [SpringAlertView showMessage:NSLocalizedString(@"err_phone", nil)];
        }

  
//    if (!self.account.success) {
//        [SpringAlertView showMessage:NSLocalizedString(@"err_phone", nil)];
//        return;
//    }
//    if (!self.password.success) {
//        [SpringAlertView showMessage:NSLocalizedString(@"err_password", nil)];
//        return;
//    }
//    if (!self.verifyCode.success) {
//        [SpringAlertView showMessage:NSLocalizedString(@"err_verify", nil)];
//        return;
//    }
//    [self.view endEditing:YES];
//
//    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
//    [params setValue:[self.account.text RSAPublicEncryption] forKey:KEY_MOBILE];
//    [params setValue:[self.password.text RSAPublicEncryption] forKey:KEY_PASSWORD];
//    [params setValue:self.verifyCode.text forKey:KEY_VERIFYCODE];
//    
//    [BaseIndicatorView showInView:self.view];
//    
//    @weakify(self)
//    self.task = [[UserinfoManager sharedUserinfo] startRequest:kUserinfoOperationFindPassword   params:params success:^(id result) {
//        @strongify(self)
//        
//        [SpringAlertView showInWindow:self.view.window message:result[RESULT_REMARK]];
//        [BaseIndicatorView hideWithAnimation:self.didShow];
//        [self.navigationController popViewControllerAnimated:YES];
//    } failure:^(id result, NSString *errorDescription) {
//        @strongify(self)
//        
//        [SpringAlertView showInWindow:self.view.window message:errorDescription];
//        [BaseIndicatorView hideWithAnimation:self.didShow];
//    }];
}

#pragma mark - setter & getter
- (void)setAccount:(LimitTextField *)account
{
    _account = account;
    
    account.text = self.preAccount;
}
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    [super prepareForSegue:segue sender:sender];
    
    if ([SET_SERTRET_SEGUE_IDENTIFIER isEqual:segue.identifier]) {
        setSecretViewController*vc = (setSecretViewController *)segue.destinationViewController;
        vc.preAccount = self.account.text;
        vc.type = kUserinfoOperationFindPassword;
  

    }
}

@end
