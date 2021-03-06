//
//  setSecretViewController.m
//  YuanXin_Project
//
//  Created by Yuanin on 17/3/28.
//  Copyright © 2017年 yuanxin. All rights reserved.
//

#import "setSecretViewController.h"
#import "FindPasswordVC.h"
#import "VerifyCodeButton.h"
#import "LimitTextField.h"
#import "UINavigationBar+BackgroundColor.h"
#import "UserinfoManager.h"

#import "RegisterViewController.h"
#import "LoginNavigationController.h"
#import "AuthenticationVC.h"

#import "GesturePasswordVC.h"
#import "LoginViewController.h"

#import "VerifyCodeButton.h"

#define REGISTER_SMS_TYPE @"register"


#import <LocalAuthentication/LocalAuthentication.h>
#import "WebVC.h"
#define FIND_PASSWORD_SMS_TYPE @"forgetpwd"
@interface setSecretViewController ()<UITextFieldDelegate>
@property (strong, nonatomic) NSURLSessionTask *task;
@property (weak, nonatomic) IBOutlet LimitTextField *secretCodeTF;
@property (weak, nonatomic) IBOutlet LimitTextField *passWordTF;
@property (weak, nonatomic) IBOutlet VerifyCodeButton *AuthCodeBtn;
@property (weak, nonatomic) IBOutlet UILabel *preCountLB;
@property (weak, nonatomic) IBOutlet UIButton *nextBtn;
@end

@implementation setSecretViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //     [self.navigationController.navigationBar setCustomBackgroundColor:Theme_Color];
    [self.navigationController.navigationBar setCustomBackgroundColor:[UIColor clearColor]];
    [self layoutNavigationLeftButtonWithImage:[UIImage imageNamed:Nav_Back_Image] block:^(UIViewController *viewController) {
        [viewController.navigationController popViewControllerAnimated:YES];
    }];
    [self.secretCodeTF becomeFirstResponder];
    [self layoutNavigationLeftButtonWithImage:[UIImage imageNamed:@"返回"] block:^(UIViewController *viewController) {
        [AlertViewManager showInViewController:self title:nil message:@"验证码信息可能略有延迟，确定返回并重新开始？"
                          clickedButtonAtIndex:^(UIAlertView *alertView, NSInteger buttonIndex) {
                              
                              if (1 == buttonIndex) {
                                 
                                          [self.navigationController popViewControllerAnimated:YES];
                              } else {
                                  
                                 
                                  
                              }
                          } cancelButtonTitle:NSLocalizedString(@"取消", nil) otherButtonTitles:NSLocalizedString(@"返回", nil), nil];

    }];
    
    
    UIView *view1 = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 20, 20)];
    UIImageView *image1=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"2xyanzm"]];
    image1.frame=CGRectMake(5, 2, 15, 15);
    [view1 addSubview:image1];
    self.secretCodeTF.leftView=view1;
    self.secretCodeTF.leftViewMode=UITextFieldViewModeAlways;
    
    UIView *view2 = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 20, 20)];
    UIImageView *image2 =[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"2xmima"]];
    image2.frame=CGRectMake(5, 2, 15, 15);
    [view2 addSubview:image2];
    self.passWordTF.leftView=view2;
    self.passWordTF.leftViewMode=UITextFieldViewModeAlways;
    

    
    NSMutableAttributedString *noteStr = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"已向 %@ 发送短信验证码",self.preAccount]];
    NSRange redRange = NSMakeRange([[noteStr string] rangeOfString:self.preAccount].location, [[noteStr string] rangeOfString:self.preAccount].length);
    [noteStr addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:redRange];
    
    [self.AuthCodeBtn countDown:AUTHCODE_REPEAT_INTERVAL];
    self.nextBtn.enabled = NO;
    [self.preCountLB setAttributedText:noteStr];
    [self.preCountLB sizeToFit];
   
    
   
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFiledDidChange) name:UITextFieldTextDidChangeNotification object:nil];
    
    
}
- (void)textFiledDidChange{
    if (self.secretCodeTF.text.length ==6 && self.passWordTF.text.length >= 6  && self.passWordTF.text.length <= 16  ) {
        self.nextBtn.enabled = YES;
    }else{
        self.nextBtn.enabled = NO;
    }
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self  name:UITextFieldTextDidChangeNotification object:nil];
}
- (IBAction)fetchAuthCode:(VerifyCodeButton *)sender {
    
        if (self.preAccount && self.preAccount.length == 11) {
            NSString *str;
            if (self.type == kUserinfoOperationRegister ) {
                str = REGISTER_SMS_TYPE;
            }
            if (self.type == kUserinfoOperationFindPassword) {
                str = FIND_PASSWORD_SMS_TYPE;
            }
            
            
            [self.view endEditing:YES];
            [BaseIndicatorView showInView:self.view maskType:kIndicatorMaskContent];
            @weakify(self)
            self.task = [NetworkContectManager sessionPOSTWithMothed:SMS_SEND params:@{KEY_MOBILE:[self.preAccount RSAPublicEncryption], VERIFY_CODE_TYPE_KEY:str} success:^(NSURLSessionTask *task, id result) {
                @strongify(self)
    
                [SpringAlertView showInWindow:self.view.window message:result[RESULT_REMARK]];
                [sender countDown:AUTHCODE_REPEAT_INTERVAL];
                [BaseIndicatorView hideWithAnimation:self.didShow];
            } failure:^(NSURLSessionTask *task, id result, NSString *errorDescription) {
                @strongify(self)
    
                [SpringAlertView showInWindow:self.view.window message:errorDescription];
                [BaseIndicatorView hideWithAnimation:self.didShow];
            }];
    
        } else {
            [SpringAlertView showMessage:NSLocalizedString(@"err_phone", nil)];
        }
    
    
    
    
    
    

}
- (void)textFieldDidEndEditing:(UITextField *)textField{
    
    if (self.secretCodeTF.text.length ==6 && self.passWordTF.text.length >= 6  && self.passWordTF.text.length <= 16  ) {
        self.nextBtn.enabled = YES;
    }else{
        self.nextBtn.enabled = NO;
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)submitBtn:(UIButton *)sender {
        if (!self.preAccount || self.preAccount.length != 11) {
            [SpringAlertView showMessage:NSLocalizedString(@"err_phone", nil)];
             return;
        }
        if (!self.secretCodeTF.success) {
            [SpringAlertView showMessage:NSLocalizedString(@"err_verify", nil)];
              return;
         }
        if (!self.passWordTF.success) {
            [SpringAlertView showMessage:NSLocalizedString(@"err_password", nil)];
             return;
        }
    
        [self.view endEditing:YES];
    
        NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
        [params setValue:[self.preAccount RSAPublicEncryption] forKey:KEY_MOBILE];
        [params setValue:[self.passWordTF.text RSAPublicEncryption] forKey:KEY_PASSWORD];
        [params setValue:self.secretCodeTF.text forKey:KEY_VERIFYCODE];
    
        [BaseIndicatorView showInView:self.view];
    
        @weakify(self)
        self.task = [[UserinfoManager sharedUserinfo] startRequest:self.type   params:params success:^(id result) {
            @strongify(self)
    
            [SpringAlertView showInWindow:self.view.window message:result[RESULT_REMARK]];
            [BaseIndicatorView hideWithAnimation:self.didShow];
            if (self.type == kUserinfoOperationRegister) {
                [[UserinfoManager sharedUserinfo] saveLastAccount];
                [self registerCompletion];
            }else{
           
            [self dismissViewControllerAnimated:YES completion:nil];
            }
        } failure:^(id result, NSString *errorDescription) {
            @strongify(self)
    
            [SpringAlertView showInWindow:self.view.window message:errorDescription];
            [BaseIndicatorView hideWithAnimation:self.didShow];
        }];

}
#pragma mark - private method

- (void)registerCompletion
{
    GesturePasswordVC *vc = [AiMiApplication obtainControllerForMainStoryboardWithID:GESTURE_PASSWORD_STORYBOARD_ID];
    vc.type = kGesturePasswordSetting;
    [self.navigationController pushViewController:vc animated:YES];
    
    @weakify(self)
    [vc setCompletionBlock:^(GesturePasswordVC *vc, GesturePasswordOperationType type) {
        @strongify(self)
        //打开手势密码
        if (kGesturePasswordOperationSuccess == type) {
            NSUserDefaults *userDefaults = USERDEFAULTS;
            [userDefaults setBool:YES forKey:DID_OPEN_GESTURE];
            [userDefaults synchronize];
           // 打开TouchID
            if ([[[LAContext alloc] init] canEvaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics error:nil]) {
                
                [AlertViewManager showInViewController:self title:nil message:@"是否开启 Touch ID" clickedButtonAtIndex:^(id alertView, NSInteger buttonIndex) {
                    LAContext *context = [[LAContext alloc] init];
                    if ( [context canEvaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics error:nil]) {

                        [context evaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics localizedReason:@"需要验证您的指纹来确认您的身份信息" reply:^(BOOL success, NSError * _Nullable error) {
                            if (success) {
                                
                                NSUserDefaults *userDefaults = USERDEFAULTS;
                                [userDefaults setBool:buttonIndex forKey:DID_OPEN_TOUCHID];
                                [userDefaults synchronize];
                              
                            }else{
                                
//                                [self.navigationController popToRootViewControllerAnimated:YES];
                                 [(LoginNavigationController *)self.navigationController dismissLoginSuccess:YES completion:nil];

                                
                            }
                            
                            
                        }];
                    }
                    
//                    [self showAuthUserInfo:YES];
//                     [self.navigationController popToRootViewControllerAnimated:YES];
                     [(LoginNavigationController *)self.navigationController dismissLoginSuccess:YES completion:nil];
                } cancelButtonTitle:NSLocalizedString(@"cancel", nil) otherButtonTitles:NSLocalizedString(@"confirm", nil), nil];
            } else {
//                [self showAuthUserInfo:YES];
//                 [self.navigationController popToRootViewControllerAnimated:YES];
                 [(LoginNavigationController *)self.navigationController dismissLoginSuccess:YES completion:nil];
            }
        } else {
//            [self showAuthUserInfo:NO];
//            [self.navigationController popToRootViewControllerAnimated:YES];
                [(LoginNavigationController *)self.navigationController dismissLoginSuccess:YES completion:nil];
            

        }
    }];
}

//- (void)showAuthUserInfo:(BOOL)setupGesurePasswordSuccess
//{
////    [AlertViewManager showInViewController:self title:nil message:(setupGesurePasswordSuccess ? [[NSString alloc] initWithFormat:@"%@\n%@", @"设置手势成功", NSLocalizedString(@"alert_info_text", nil)] : NSLocalizedString(@"alert_info_text", nil) ) clickedButtonAtIndex:^(UIAlertView *alertView, NSInteger buttonIndex) {
////        
////        if (1 == buttonIndex) {
////            [self.navigationController pushViewController:[[AuthenticationVC alloc] initWithCancelCallBack:^{
////                [(LoginNavigationController *)self.navigationController dismissLoginSuccess:YES completion:nil];
////            }] animated:YES];
////        } else {
////            
////            [(LoginNavigationController *)self.navigationController dismissLoginSuccess:YES completion:nil];
////        }
////    } cancelButtonTitle:NSLocalizedString(@"not_set", nil) otherButtonTitles:NSLocalizedString(@"set", nil), nil];
//}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
