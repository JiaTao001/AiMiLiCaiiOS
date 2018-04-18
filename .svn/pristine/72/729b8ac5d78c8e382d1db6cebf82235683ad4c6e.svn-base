//
//  AlterPhoneVC.m
//  YuanXin_Project
//
//  Created by Yuanin on 16/1/18.
//  Copyright © 2016年 yuanxin. All rights reserved.
//

#import "AlterPhoneVC.h"
#import "IntersectedTextField.h"

#import "VerifyCodeButton.h"

#define ALTER_PHONE_SMS_TYPE @"change_mobile"

@interface AlterPhoneVC () <UITextFieldDelegate>

@property (strong, nonatomic) NSURLSessionTask *task;

@property (weak, nonatomic) IBOutlet LimitTextField *name;
@property (weak, nonatomic) IBOutlet IntersectedTextField *idCardNo;
@property (weak, nonatomic) IBOutlet LimitTextField *mobile;
@property (weak, nonatomic) IBOutlet LimitTextField *verifyCode;

@property (strong, nonatomic) UITextField *currentTextField;
@property (strong, nonatomic) UIButton *idCardX;
@end

@implementation AlterPhoneVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self layoutNavigationLeftButtonWithImage:[UIImage imageNamed:Nav_Back_Image] block:^(__kindof UIViewController *viewController) {
        [viewController.navigationController popViewControllerAnimated:YES];
    }];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidShow:) name:UIKeyboardDidShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardDidShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
    [self.task cancel];
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField endEditing:YES];
    return YES;
}
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    self.currentTextField = textField;
    return YES;
}

- (IBAction)fetchAuthCode:(VerifyCodeButton *)sender
{
    if (self.mobile.success) {
        [self.view endEditing:YES];
        
        [BaseIndicatorView showInView:self.view maskType:kIndicatorMaskContent];
        @weakify(self)
        self.task = [NetworkContectManager sessionPOSTWithMothed:SMS_SEND params:@{KEY_MOBILE:[self.mobile.text RSAPublicEncryption], VERIFY_CODE_TYPE_KEY:ALTER_PHONE_SMS_TYPE} success:^(NSURLSessionTask *task, id result) {
            @strongify(self)
            
            [BaseIndicatorView hideWithAnimation:self.didShow];
            [SpringAlertView showInWindow:self.view.window message:result[RESULT_REMARK]];
            [sender countDown:AUTHCODE_REPEAT_INTERVAL];
        } failure:^(NSURLSessionTask *task, id result, NSString *errorDescription) {
            @strongify(self)
            
            [BaseIndicatorView hideWithAnimation:self.didShow];
            [SpringAlertView showInWindow:self.view.window message:errorDescription];
        }];
    } else {
        [SpringAlertView showMessage:NSLocalizedString(@"err_phone", nil)];
    }
}

- (IBAction)confim:(UIButton *)sender
{
    if (!self.name.success) {
        [SpringAlertView showMessage:NSLocalizedString(@"err_name", nil)];
        return;
    }
    if (!self.idCardNo.success) {
        [SpringAlertView showMessage:NSLocalizedString(@"err_idCard", nil)];
        return;
    }
    if (!self.mobile.success) {
        [SpringAlertView showMessage:NSLocalizedString(@"err_phone", nil)];
        return;
    }
    if (!self.verifyCode.success) {
        [SpringAlertView showMessage:NSLocalizedString(@"err_verify", nil)];
        return;
    }
    [self.view endEditing:YES];
    [BaseIndicatorView showInView:self.view];
        
    @weakify(self)
    self.task = [[UserinfoManager sharedUserinfo] startRequest:kUserinfoOperationAlterPhone params:@{KEY_REALNAME:[self.name.text RSAPublicEncryption],KEY_IDNUMBER:[[self.idCardNo.text stringByReplacingOccurrencesOfString:@" " withString:@""] RSAPublicEncryption], KEY_NEWMOBILE:[self.mobile.text RSAPublicEncryption], KEY_VERIFYCODE:self.verifyCode.text} success:^(id result) {
        @strongify(self)
        
        [BaseIndicatorView hideWithAnimation:self.didShow];
        [[UserinfoManager sharedUserinfo] alterPhone:self.mobile.text];
        [SpringAlertView showInWindow:self.view.window message:result[RESULT_REMARK]];
        [self.navigationController popViewControllerAnimated:YES];
    } failure:^(id result, NSString *errorDescription) {
        @strongify(self)
        
        [BaseIndicatorView hideWithAnimation:self.didShow];
        [SpringAlertView showInWindow:self.view.window message:errorDescription];
    }];
}

- (void)keyboardDidShow:(NSNotification *)notification
{
    [self changeIdCardX:YES notification:notification];
}
- (void)keyboardWillHide:(NSNotification *)notification
{
    [self changeIdCardX:NO notification:notification];
}

- (void)changeIdCardX:(BOOL)isShow notification:(NSNotification *)notification
{
    self.idCardX.hidden = (self.idCardNo != self.currentTextField) | !isShow;//notification.object ==  self.currentTextField ? : !isShow;
    
    if (!self.idCardX.superview && notification) {
        
        CGRect keyboardEndFrame = [[notification.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
        CGRect buttonEndFrame = CGRectMake(keyboardEndFrame.origin.x, (NSInteger)( UISCREEN_HEIGHT - keyboardEndFrame.size.height/4), (NSInteger)(keyboardEndFrame.size.width/3), (NSInteger)(keyboardEndFrame.size.height/4));
        
        UIWindow *window = [[UIApplication sharedApplication].windows lastObject];
        [window addSubview:self.idCardX];
        
        self.idCardX.frame = buttonEndFrame;
    }
}


- (void)setIdCardNo:(IntersectedTextField *)idCardNo
{
    _idCardNo = idCardNo;
    
    idCardNo.filter = @"[0-9Xx]*";
}

- (UIButton *)idCardX
{
    if (!_idCardX) {
        _idCardX = [[UIButton alloc] init];
        
        _idCardX.titleLabel.textAlignment = NSTextAlignmentCenter;
        _idCardX.titleLabel.font = [UIFont systemFontOfSize:20.0];
        [_idCardX setTitle:@"X" forState:UIControlStateNormal];
        [_idCardX setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_idCardX addTarget:self action:@selector(addX:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _idCardX;
}
- (void)addX:(UIButton *)sender
{
    if (sender.superview && !sender.hidden) {
        
        self.idCardNo.text = [self.idCardNo.text stringByAppendingString:sender.currentTitle];
        [self.idCardNo textDidChange];
    }
}


- (void)dealloc
{
    if (_idCardNo.superview) {
        [_idCardNo removeFromSuperview];
    }
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
