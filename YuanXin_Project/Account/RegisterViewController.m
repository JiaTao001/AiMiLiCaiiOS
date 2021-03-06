//
//  RegisterViewController.m
//  YuanXin_Project
//
//  Created by Sword on 15/9/21.
//  Copyright © 2015年 yuanxin. All rights reserved.
//

#import "RegisterViewController.h"
#import "LoginNavigationController.h"
#import "AuthenticationVC.h"

#import "GesturePasswordVC.h"
#import "LoginViewController.h"
#import "UINavigationBar+BackgroundColor.h"
#import "VerifyCodeButton.h"
#import "LimitTextField.h"
#import "setSecretViewController.h"

#import "UserinfoManager.h"
#import <LocalAuthentication/LocalAuthentication.h>
#import "WebVC.h"

#define REGISTER_SMS_TYPE @"register"

@interface RegisterViewController ()<UITextFieldDelegate>

@property (strong, nonatomic) NSURLSessionTask *task;

@property (weak, nonatomic) IBOutlet UIButton *tongyiBtn;
@property (weak, nonatomic) IBOutlet LimitTextField *account;
//@property (weak, nonatomic) IBOutlet LimitTextField *verifyCode;
//@property (weak, nonatomic) IBOutlet LimitTextField *password;
@property (weak, nonatomic) IBOutlet UIButton *nextBtn;
@end


@implementation RegisterViewController

#pragma mark - life cycle
- (void)viewDidLoad
{
    [super viewDidLoad];
//    [self.navigationController.navigationBar setCustomBackgroundColor:Theme_Color];
    [self.navigationController.navigationBar setCustomBackgroundColor:[UIColor clearColor]];

    [self layoutNavigationLeftButtonWithImage:[UIImage imageNamed:@"返回"] block:^(UIViewController *viewController) {
        
        if ([viewController isEqual:[viewController.navigationController.viewControllers firstObject]]) {
            
            [(LoginNavigationController *)viewController.navigationController dismissLoginSuccess:NO completion:nil];
        } else {
            [viewController.navigationController popViewControllerAnimated:YES];
        }
    }];
    UIView *view1 = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 20, 20)];
    UIImageView *image1=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"shouji@2x"]];
    image1.frame=CGRectMake(5, 2, 15, 15);
    [view1 addSubview:image1];
    self.account.leftView=view1;
    self.account.leftViewMode=UITextFieldViewModeAlways;
    self.nextBtn.enabled = NO;
    [self.account becomeFirstResponder];
//    [self.navigationController.navigationBar setCustomBackgroundColor:[UIColor clearColor]];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFiledDidChange) name:UITextFieldTextDidChangeNotification object:nil];
  
    
}
- (void)textFiledDidChange{
    if (self.account.text.length==11 && self.tongyiBtn.selected ) {
        self.nextBtn.enabled = YES;
    }else{
        self.nextBtn.enabled = NO;
    }
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar setCustomBackgroundColor:[UIColor clearColor]];

}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
     [[NSNotificationCenter defaultCenter] removeObserver:self  name:UITextFieldTextDidChangeNotification object:nil];
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
    
    if (self.account.text.length==11 && self.tongyiBtn.selected) {
        self.nextBtn.enabled = YES;
    }else{
      self.nextBtn.enabled = NO;
    }
}



#pragma mark - action

- (IBAction)tongyiBtnClicked:(UIButton *)sender {
    sender.selected = !sender.selected;
    if (self.account.text.length==11 && self.tongyiBtn.selected) {
        self.nextBtn.enabled = YES;
    }else{
        self.nextBtn.enabled = NO;
    }
    
}
//- (IBAction)fetchAuthCode:(VerifyCodeButton *)sender
//{
//    if (self.account.success) {
//        
//        [self.view endEditing:YES];
//        
//        [BaseIndicatorView showInView:self.view maskType:kIndicatorMaskContent];
//        @weakify(self)
//        self.task = [NetworkContectManager sessionPOSTWithMothed:SMS_SEND params:@{KEY_MOBILE:[self.account.text RSAPublicEncryption], VERIFY_CODE_TYPE_KEY:REGISTER_SMS_TYPE} success:^(NSURLSessionTask *task, id result) {
//            @strongify(self)
//            
//            [SpringAlertView showInWindow:self.view.window message:result[RESULT_REMARK]];
//            [sender countDown:AUTHCODE_REPEAT_INTERVAL];
//            
//            [BaseIndicatorView hideWithAnimation:self.didShow];
//        } failure:^(NSURLSessionTask *task, id result, NSString *errorDescription) {
//            @strongify(self)
//            
//            [SpringAlertView showInWindow:self.view.window message:errorDescription];
//            [BaseIndicatorView hideWithAnimation:self.didShow];
//        }];
//        
//    } else {
//        [SpringAlertView showInWindow:self.view.window message:NSLocalizedString(@"err_phone", nil)];
//    }
//}

- (IBAction)registerAccount:(UIButton *)sender
{
    
    
        if (self.account.success) {
    
            [self.view endEditing:YES];
    
            [BaseIndicatorView showInView:self.view maskType:kIndicatorMaskContent];
            @weakify(self)
            self.task = [NetworkContectManager sessionPOSTWithMothed:SMS_SEND params:@{KEY_MOBILE:[self.account.text RSAPublicEncryption], VERIFY_CODE_TYPE_KEY:REGISTER_SMS_TYPE} success:^(NSURLSessionTask *task, id result) {
                @strongify(self)
    
                [SpringAlertView showInWindow:self.view.window message:result[RESULT_REMARK]];
//                [sender countDown:AUTHCODE_REPEAT_INTERVAL];
                [self performSegueWithIdentifier:SET_SERTRET_SEGUE_IDENTIFIER2 sender:self];
                [BaseIndicatorView hideWithAnimation:self.didShow];
            } failure:^(NSURLSessionTask *task, id result, NSString *errorDescription) {
                @strongify(self)
    
                [SpringAlertView showInWindow:self.view.window message:errorDescription];
                [BaseIndicatorView hideWithAnimation:self.didShow];
            }];
    
        } else {
            [SpringAlertView showInWindow:self.view.window message:NSLocalizedString(@"err_phone", nil)];
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
//    @weakify(self)
//    self.task = [[UserinfoManager sharedUserinfo] startRequest:kUserinfoOperationRegister params:params success:^(id result) {
//        @strongify(self)
//        
//        [BaseIndicatorView hideWithAnimation:self.didShow];
//        [[UserinfoManager sharedUserinfo] saveLastAccount];
//        [self registerCompletion];
//        [SpringAlertView showInWindow:self.view.window message:result[RESULT_REMARK]];
//    } failure:^(id result, NSString *errorDescription) {
//        @strongify(self)
//        
//        [BaseIndicatorView hideWithAnimation:self.didShow];
//        [SpringAlertView showInWindow:self.view.window message:errorDescription];
//    }];
}
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    [super prepareForSegue:segue sender:sender];
    
    if ([SET_SERTRET_SEGUE_IDENTIFIER2 isEqual:segue.identifier] ) {
        setSecretViewController*vc = (setSecretViewController *)segue.destinationViewController;
        vc.preAccount = self.account.text;
        vc.type = kUserinfoOperationRegister;
    }
}

- (IBAction)checkUserAgreement:(UIButton *)sender
{
    [self.navigationController.navigationBar setCustomBackgroundColor:Theme_Color];
    [self.navigationController pushViewController:[[WebVC alloc] initWithWebPath:[CommonTools completeWebPathWithSubpath:Introduce_Protocol]] animated:YES];
}

#pragma mark - private method

//- (void)registerCompletion
//{
//    GesturePasswordVC *vc = [AiMiApplication obtainControllerForMainStoryboardWithID:GESTURE_PASSWORD_STORYBOARD_ID];
//    vc.type = kGesturePasswordSetting;
//    [self.navigationController pushViewController:vc animated:YES];
//    
//    @weakify(self)
//    [vc setCompletionBlock:^(GesturePasswordVC *vc, GesturePasswordOperationType type) {
//        @strongify(self)
//        //打开手势密码
//        if (kGesturePasswordOperationSuccess == type) {
//            NSUserDefaults *userDefaults = USERDEFAULTS;
//            [userDefaults setBool:YES forKey:DID_OPEN_GESTURE];
//            [userDefaults synchronize];
//            //打开TouchID
//            if ([[[LAContext alloc] init] canEvaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics error:nil]) {
//                
//                [AlertViewManager showInViewController:self title:nil message:@"是否开启 Touch ID" clickedButtonAtIndex:^(id alertView, NSInteger buttonIndex) {
//                    
//                    NSUserDefaults *userDefaults = USERDEFAULTS;
//                    [userDefaults setBool:buttonIndex forKey:DID_OPEN_TOUCHID];
//                    [userDefaults synchronize];
//                    
//                    [self showAuthUserInfo:YES];
//                } cancelButtonTitle:NSLocalizedString(@"cancel", nil) otherButtonTitles:NSLocalizedString(@"confirm", nil), nil];
//            } else {
//                [self showAuthUserInfo:YES];
//            }
//        } else {
//            [self showAuthUserInfo:NO];
//        }
//    }];
//}
//
//- (void)showAuthUserInfo:(BOOL)setupGesurePasswordSuccess
//{
//    [AlertViewManager showInViewController:self title:nil message:(setupGesurePasswordSuccess ? [[NSString alloc] initWithFormat:@"%@\n%@", @"设置手势成功", NSLocalizedString(@"alert_info_text", nil)] : NSLocalizedString(@"alert_info_text", nil) ) clickedButtonAtIndex:^(UIAlertView *alertView, NSInteger buttonIndex) {
//        
//        if (1 == buttonIndex) {
//            [self.navigationController pushViewController:[[AuthenticationVC alloc] initWithCancelCallBack:^{
//                [(LoginNavigationController *)self.navigationController dismissLoginSuccess:YES completion:nil];
//            }] animated:YES];
//        } else {
//            
//            [(LoginNavigationController *)self.navigationController dismissLoginSuccess:YES completion:nil];
//        }
//    } cancelButtonTitle:NSLocalizedString(@"not_set", nil) otherButtonTitles:NSLocalizedString(@"set", nil), nil];
//}

@end
