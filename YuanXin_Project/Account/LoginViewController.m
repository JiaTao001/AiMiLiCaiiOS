//
//  LoginViewController.m
//  YuanXin_Project
//
//  Created by Sword on 15/9/14.
//  Copyright (c) 2015年 yuanxin. All rights reserved.
//

#import "LoginViewController.h"
#import "VerifyCodeButton.h"
#import "LimitTextField.h"
#import "UINavigationBar+BackgroundColor.h"
#import "LoginNavigationController.h"
#import "GesturePasswordVC.h"
#import "FindPasswordVC.h"

#import <LocalAuthentication/LocalAuthentication.h>
#import "UserinfoManager.h"

@interface LoginViewController () <UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UIButton *loginBtn;
@property (weak, nonatomic) IBOutlet LimitTextField *account;
@property (weak, nonatomic) IBOutlet LimitTextField *password;
@property (weak, nonatomic) IBOutlet UIButton *secreatBtn;
@end

@implementation LoginViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.navigationController.navigationBar setCustomBackgroundColor:[UIColor clearColor]];
//    [self layoutNavigationLeftButtonWithImage:[UIImage imageNamed:Nav_Back_Image] block:^(UIViewController *viewController) {
//        
//        LoginViewController *vc = (LoginViewController *)viewController;
//        [vc dismiss:NO];
//    }];
    UIView *view1 = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 20, 20)];
    UIImageView *image1=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"shouji@2x"]];
    image1.frame=CGRectMake(5, 2, 15, 15);
    [view1 addSubview:image1];
    self.account.leftView=view1;
    self.account.leftViewMode=UITextFieldViewModeAlways;
      UIView *view2 = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 20, 20)];
    UIImageView *image2=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"2xmima"]];
    image2.frame=CGRectMake(5, 2, 15, 15);
    [view2 addSubview:image2];
    self.password.leftView=view2;
    self.password.leftViewMode=UITextFieldViewModeAlways;
    
    [self.account becomeFirstResponder];
    [[UIApplication sharedApplication]setStatusBarStyle:UIStatusBarStyleDefault];
        [self layoutNavigationLeftButtonWithImage:[UIImage imageNamed:@"返回"] block:^(UIViewController *viewController) {
    
            LoginViewController *vc = (LoginViewController *)viewController;
            [vc dismiss:NO];
        }];
    
     [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFiledDidChange) name:UITextFieldTextDidChangeNotification object:nil];
}
- (void)textFiledDidChange{
    if (self.account.text.length==11 &&self.password.text.length>=6 &&self.password.text.length<=16) {
        self.loginBtn.enabled = YES;
        self.loginBtn.selected = YES;
    }else{
        self.loginBtn.enabled = NO;
        self.loginBtn.selected = NO;
    }

}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [[UIApplication sharedApplication]setStatusBarStyle:UIStatusBarStyleDefault];
    [self.navigationController.navigationBar setCustomBackgroundColor:[UIColor clearColor]];
    
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [[UIApplication sharedApplication]setStatusBarStyle:UIStatusBarStyleLightContent];
    [[NSNotificationCenter defaultCenter] removeObserver:self  name:UITextFieldTextDidChangeNotification object:nil];
}
//- (UIStatusBarStyle)preferredStatusBarStyle {
//    
//    return UIStatusBarStyleLightContent ;
//}

- (IBAction)problemBtnClicked:(id)sender {
    [AlertViewManager showInViewController:self title:nil message:@"您的手机能否接收短信？"
                      clickedButtonAtIndex:^(UIAlertView *alertView, NSInteger buttonIndex) {
                          
                          if (1 == buttonIndex) {
                              NSMutableString * str=[[NSMutableString alloc] initWithFormat:@"telprompt://%@",@"4006662082"];
                             
                              [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
                             
                          } else {

                              [self performSegueWithIdentifier:FIND_PASSWORD_SEGUE_IDENTIFIER sender:self];
                             
                          }
                      } cancelButtonTitle:NSLocalizedString(@"能", nil) otherButtonTitles:NSLocalizedString(@"不能", nil), nil];
}

- (IBAction)secreatBtnClicked:(id)sender {
    UIButton *btn = sender;
    btn.selected = !btn.selected;
    self.password.secureTextEntry = !self.password.secureTextEntry;
}

#pragma mark - delegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    
    [textField resignFirstResponder];
    return YES;
}
- (void)textFieldDidEndEditing:(UITextField *)textField{
    self.secreatBtn.hidden = YES;
      if (self.account.text.length==11 &&self.password.text.length>=6 &&self.password.text.length<=16) {
        self.loginBtn.enabled = YES;
        self.loginBtn.selected = YES;
    }else{
        self.loginBtn.enabled = NO;
        self.loginBtn.selected = NO;
    }
}
-(void)textFieldDidBeginEditing:(UITextField *)textField{
    self.secreatBtn.hidden = NO;

}
//- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
//    if (self.account.text.length>=10 &&self.password.text.length>=5) {
//        self.loginBtn.enabled = YES;
//        self.loginBtn.selected = YES;
//    }else{
//        self.loginBtn.enabled = NO;
//        self.loginBtn.selected = NO;
//    }
//    return YES;
//}


- (IBAction)login:(UIButton *)sender
{
    if (!self.account.isSuccess) {
        [SpringAlertView showMessage:NSLocalizedString(@"err_phone", nil)];
        return;
    }
    if (!self.password.isSuccess) {
        [SpringAlertView showMessage:NSLocalizedString(@"err_password", nil)];
        return;
    }
    [self.view endEditing:YES];

    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setValue:[self.account.text RSAPublicEncryption] forKey:KEY_MOBILE];
    [params setValue:[self.password.text RSAPublicEncryption] forKey:KEY_PASSWORD];
    
    [BaseIndicatorView showInView:self.view];
    @weakify(self)
    [[UserinfoManager sharedUserinfo] startRequest:kUserinfoOperationLogin params:params success:^(id result) {
        @strongify(self)
       

        
      
        
        [BaseIndicatorView hideWithAnimation:self.didShow];
        [self didLoginSuccess];
        [SpringAlertView showInWindow:self.view.window message:result[RESULT_REMARK]];
    } failure:^(id result, NSString *errorDescription) {
        @strongify(self)
        NSLog(@"f -- %@", result);
        [BaseIndicatorView hideWithAnimation:self.didShow];
        [SpringAlertView showInWindow:self.view.window message:errorDescription];
    }];
}

- (void)didLoginSuccess
{
    [[UserinfoManager sharedUserinfo] saveLastAccount];
    
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
            
            if ([[[LAContext alloc] init] canEvaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics error:nil]) {
                [AlertViewManager showInViewController:vc title:nil message:@"是否开启 Touch ID" clickedButtonAtIndex:^(id alertView, NSInteger buttonIndex) {
                    LAContext *context = [[LAContext alloc] init];
                    if ( [context canEvaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics error:nil]) {
                        
                        [context evaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics localizedReason:@"需要验证您的指纹来确认您的身份信息" reply:^(BOOL success, NSError * _Nullable error) {
                            if (success) {
                                
                                NSUserDefaults *userDefaults = USERDEFAULTS;
                                [userDefaults setBool:buttonIndex forKey:DID_OPEN_TOUCHID];
                                [userDefaults synchronize];
                                [self dismiss:YES];
                            }else{
                                
                                [self dismiss:YES];
                             
                            }
                            
                            
                        }];
                    }
                    
                    
                    
                } cancelButtonTitle:NSLocalizedString(@"cancel", nil) otherButtonTitles:NSLocalizedString(@"confirm", nil), nil];
            } else {
                [self dismiss:YES];
            }
        } else {
            [self dismiss:YES];
        }
    }];
}


#pragma mark - private method
- (void)dismiss:(BOOL)success
{
    LoginNavigationController *loginNV = (LoginNavigationController *)self.navigationController;
    [loginNV dismissLoginSuccess:success completion:nil];
}

- (void)setAccount:(LimitTextField *)account
{
    _account = account;
    
    account.text = [[UserinfoManager sharedUserinfo] lastAccount];
}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    [super prepareForSegue:segue sender:sender];
    
    if ([FIND_PASSWORD_SEGUE_IDENTIFIER isEqual:segue.identifier]) {
        FindPasswordVC *vc = (FindPasswordVC *)segue.destinationViewController;
        vc.preAccount = self.account.text;
    }
}
@end
