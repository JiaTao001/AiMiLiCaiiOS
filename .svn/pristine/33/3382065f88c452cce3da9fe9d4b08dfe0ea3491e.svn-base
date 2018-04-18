//
//  KaiHuViewController.m
//  YuanXin_Project
//
//  Created by Yuanin on 2017/5/9.
//  Copyright © 2017年 yuanxin. All rights reserved.
//

#import "KaiHuViewController.h"
#import "UIViewController+NavigationItem.h"
#import "LimitTextField.h"
#import "BaseIndicatorView.h"
#import "SpringAlertView.h"
#import "UserinfoManager.h"
#import <ReactiveCocoa/ReactiveCocoa.h>
#import "NetworkContectManager.h"
#import "NSString+ExtendMethod.h"
#import "UserinfoManager.h"
#import "HKWebVC.h"
#import "IntersectedTextField.h"
@interface KaiHuViewController ()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet LimitTextField *nameTF;
@property (weak, nonatomic) IBOutlet IntersectedTextField *IDNumTF;
@property (weak, nonatomic) IBOutlet LimitTextField *bankCardTF;
@property (weak, nonatomic) IBOutlet LimitTextField *phoneNumTF;
@property (weak, nonatomic) IBOutlet UIImageView *bannerImageView;
@property (weak, nonatomic) IBOutlet UIButton *openAccountBtn;
@property(strong, nonatomic) NSURLSessionTask *task;

@property (strong, nonatomic) UITextField *currentTextField;
@property (strong, nonatomic) UIButton *idCardX;
@end

@implementation KaiHuViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self layoutNavigationLeftButtonWithImage:[UIImage imageNamed:Nav_Back_Image] block:^(__kindof UIViewController *viewController) {
        [viewController.navigationController popViewControllerAnimated:YES];
    }];
    self.IDNumTF.delegate = self;
    self.nameTF.delegate = self;
    self.bankCardTF.delegate = self;
    self.phoneNumTF.delegate = self;
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
- (IBAction)openAccountBtnClicked:(UIButton *)sender {
    if (!self.nameTF.success) {
        [SpringAlertView showMessage:NSLocalizedString(@"err_name", nil)];
        return;
    }
    if (!self.IDNumTF.success) {
        [SpringAlertView showMessage:NSLocalizedString(@"err_idCard", nil)];
        return;
    }
    if (!self.bankCardTF.success) {
        [SpringAlertView showMessage:@"请输入正确的银行卡号"];
        return;
    }
    if (!self.phoneNumTF.success) {
        [SpringAlertView showMessage:NSLocalizedString(@"err_phone", nil)];
        return;
    }
    [self.view endEditing:YES];
    
    NSMutableDictionary *params = [[NSMutableDictionary alloc] initWithDictionary:@{@"realname":[self.nameTF.text RSAPublicEncryption], @"idnumber":[[self.IDNumTF.text stringByReplacingOccurrencesOfString:@" " withString:@""] RSAPublicEncryption], @"card_no":[self.bankCardTF.text RSAPublicEncryption], @"card_mobile":[self.phoneNumTF.text RSAPublicEncryption]}];
    
    
    [BaseIndicatorView showInView:self.view];
    @weakify(self)
    self.task = [[UserinfoManager sharedUserinfo] startRequest:kUserinfoOperationKaiHu params:params success:^(id result) {
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




- (void)keyboardDidShow:(NSNotification *)notification {
    
    [self changeIdCardX:YES notification:notification];
}
- (void)keyboardWillHide:(NSNotification *)notification {
    
    [self changeIdCardX:NO notification:notification];
}

- (void)changeIdCardX:(BOOL)isShow notification:(NSNotification *)notification {
    if (self.IDNumTF == self.currentTextField && isShow) {
        self.idCardX.hidden = NO;
    }else{
        self.idCardX.hidden = YES;
    }
    
//    self.idCardX.hidden = (self.IDNumTF != self.currentTextField) | !isShow;//notification.object ==  self.currentTextField ? : !isShow;
    
    if (!self.idCardX.superview && notification) {
        
        CGRect keyboardEndFrame = [[notification.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
        CGRect buttonEndFrame = CGRectMake(keyboardEndFrame.origin.x, (NSInteger)( [UIScreen mainScreen].bounds.size.height - keyboardEndFrame.size.height/4), (NSInteger)(keyboardEndFrame.size.width/3), (NSInteger)(keyboardEndFrame.size.height/4));
        
        [[[UIApplication sharedApplication].windows lastObject] addSubview:self.idCardX];
        
        self.idCardX.frame = buttonEndFrame;
    }
}

#pragma mark - setter & getter

- (void)setIDNumTF:(IntersectedTextField *)IDNumTF{
    _IDNumTF = IDNumTF;
     IDNumTF.filter = @"[0-9Xx]*";
}
- (void)setCurrentTextField:(UITextField *)currentTextField {
    
    if (_currentTextField == currentTextField) return;
    
    _currentTextField = currentTextField;
    [self changeIdCardX:YES notification:nil];
}

- (UIButton *)idCardX {
    
    if (!_idCardX) {
        _idCardX = [[UIButton alloc] init];
//        _idCardX.backgroundColor = [UIColor redColor];
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
        
        self.IDNumTF.text = [self.IDNumTF.text stringByAppendingString:sender.currentTitle];
        [self.IDNumTF textDidChange];
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
