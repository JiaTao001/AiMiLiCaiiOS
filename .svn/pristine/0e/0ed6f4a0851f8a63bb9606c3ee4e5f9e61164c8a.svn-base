//
//  CertificationVC.m
//  YuanXin_Project
//
//  Created by Yuanin on 15/10/9.
//  Copyright © 2015年 yuanxin. All rights reserved.
//

#import "CertificationVC.h"
#import "LoginNavigationController.h"

#import "TradePasswordVC.h"
#import "AuthenticationVC.h"

#import "IntersectedTextField.h"

@interface CertificationVC () <UITextFieldDelegate>

@property(strong, nonatomic) NSURLSessionTask *task;

@property (weak, nonatomic) IBOutlet LimitTextField *name;
@property (weak, nonatomic) IBOutlet IntersectedTextField *idCardNo;

@property (strong, nonatomic) UITextField *currentTextField;
@property (strong, nonatomic) UIButton *idCardX;
@end

@implementation CertificationVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self layoutNavigationLeftButtonWithImage:[UIImage imageNamed:Nav_Back_Image] block:^(CertificationVC *viewController) {
        
        [viewController.navigationController popViewControllerAnimated:YES];
    }];
}
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidShow:) name:UIKeyboardDidShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}
- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardDidShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];

    [self.task cancel];
}

#pragma mark - delegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    [textField endEditing:YES];
    return YES;
}
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    
    self.currentTextField = textField;
    return YES;
}

#pragma mark - action
- (IBAction)authentication:(UIButton *)sender {
        
    if (!self.name.success) {
        [SpringAlertView showMessage:NSLocalizedString(@"err_name", nil)];
        return;
    }
    if (!self.idCardNo.success) {
        [SpringAlertView showMessage:NSLocalizedString(@"err_idCard", nil)];
        return;
    }
    [self.view endEditing:YES];
    
    NSMutableDictionary *params = [[NSMutableDictionary alloc] initWithDictionary:@{KEY_REALNAME:[self.name.text RSAPublicEncryption], KEY_IDNUMBER:[[self.idCardNo.text stringByReplacingOccurrencesOfString:@" " withString:@""] RSAPublicEncryption]}];
    
    [BaseIndicatorView showInView:self.view];
    @weakify(self)
    self.task = [[UserinfoManager sharedUserinfo] startRequest:kUserinfoOperationCertified params:params success:^(id result) {
        @strongify(self)
        [BaseIndicatorView hideWithAnimation:self.didShow];

        [SpringAlertView showInWindow:self.view.window message:result[RESULT_REMARK]];
        [self pushToNextItem];
    } failure:^( id result, NSString *errorDescription) {
        @strongify(self)
        
        [BaseIndicatorView hideWithAnimation:self.didShow];
        [SpringAlertView showInWindow:self.view.window message:errorDescription];
    }];
}

- (void)pushToNextItem {
    
    if ([self.parentViewController isKindOfClass:[AuthenticationVC class]]) {
        [(AuthenticationVC *)self.parentViewController changeRootViewControllerToViewControoler:[AiMiApplication obtainControllerForStoryboard:@"Auth" controller:TRADEPSD_SETUP_STORYBOARD_ID]];
    } else {
        [self.navigationController popViewControllerAnimated:YES];
    }
}


- (void)keyboardDidShow:(NSNotification *)notification {
    
    [self changeIdCardX:YES notification:notification];
}
- (void)keyboardWillHide:(NSNotification *)notification {
    
    [self changeIdCardX:NO notification:notification];
}

- (void)changeIdCardX:(BOOL)isShow notification:(NSNotification *)notification {
    
    self.idCardX.hidden = (self.idCardNo != self.currentTextField) | !isShow;//notification.object ==  self.currentTextField ? : !isShow;
    
    if (!self.idCardX.superview && notification) {
        
        CGRect keyboardEndFrame = [[notification.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
        CGRect buttonEndFrame = CGRectMake(keyboardEndFrame.origin.x, (NSInteger)( UISCREEN_HEIGHT - keyboardEndFrame.size.height/4), (NSInteger)(keyboardEndFrame.size.width/3), (NSInteger)(keyboardEndFrame.size.height/4));
        
        [[[UIApplication sharedApplication].windows lastObject] addSubview:self.idCardX];
        
        self.idCardX.frame = buttonEndFrame;
    }
}

#pragma mark - setter & getter
- (void)setIdCardNo:(IntersectedTextField *)idCardNo {
    _idCardNo = idCardNo;
    
    idCardNo.filter = @"[0-9Xx]*";
}
- (void)setCurrentTextField:(UITextField *)currentTextField {
    
    if (_currentTextField == currentTextField) return;
    
    _currentTextField = currentTextField;
    [self changeIdCardX:YES notification:nil];
}

- (UIButton *)idCardX {
    
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

- (void)addX:(UIButton *)sender {
    
    if (sender.superview && !sender.hidden) {
        
        self.idCardNo.text = [self.idCardNo.text stringByAppendingString:sender.currentTitle];
        [self.idCardNo textDidChange];
    }
}

- (void)dealloc {
    
    if (_idCardX.superview)
        [_idCardX removeFromSuperview];
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
