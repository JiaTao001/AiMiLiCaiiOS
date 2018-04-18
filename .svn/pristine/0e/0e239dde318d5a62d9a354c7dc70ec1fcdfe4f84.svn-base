//
//  IncomeCalculatorVC.m
//  YuanXin_Project
//
//  Created by Yuanin on 15/12/28.
//  Copyright © 2015年 yuanxin. All rights reserved.
//

#import "IncomeCalculatorVC.h"

#import "LimitTextField.h"


#define YU_X_BAO 0.03
#define BANK     0.003

@interface IncomeCalculatorVC ()

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *aimiProgress;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *yuXbaoProgress;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bankProgress;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomHeight;

@property (weak, nonatomic) IBOutlet LimitTextField *inputMoney;
@property (weak, nonatomic) IBOutlet UILabel *month;
@property (weak, nonatomic) IBOutlet UILabel *interest;
@property (weak, nonatomic) IBOutlet UILabel *interestUnit;

@property (weak, nonatomic) IBOutlet UILabel *aimiIncome;
@property (weak, nonatomic) IBOutlet UILabel *yuXbaoIncome;
@property (weak, nonatomic) IBOutlet UILabel *bankIncome;

@property (strong, nonatomic) CalculationOfInterest *interestCalculation;
@end

@implementation IncomeCalculatorVC

- (void)viewDidLoad {
    [super viewDidLoad];
 
    [self layoutNavigationLeftButtonWithImage:[UIImage imageNamed:Nav_Back_Image] block:^(__kindof UIViewController *viewController) {
        [viewController.navigationController popViewControllerAnimated:YES];
    }];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillChange:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillChange:) name:UIKeyboardWillHideNotification object:nil];
    
    self.month.text = self.expires;
    self.interest.text = self.yield;
    self.interestUnit.text = self.unit;
}

#pragma mark - Notification
- (void)keyboardWillChange:(NSNotification *)notification {
    
    self.bottomHeight.constant = [UIKeyboardWillShowNotification isEqualToString: notification.name] ? [[notification.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size.height : 0;

    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationCurve:[[notification.userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey] unsignedIntegerValue]];
    [UIView setAnimationDuration:[[notification.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue]];
    
    [self.view layoutIfNeeded];
    
    [UIView commitAnimations];
}

#pragma mark - action
- (IBAction)calculation:(UIButton *)sender {
    
    if (!self.inputMoney.success) {
        [SpringAlertView showMessage:@"请输入小于9,999,999的数字"];
        return;
    }
    
    [self.view endEditing:YES];
    [self resetProgress];
    
    NSInteger inputMoney = [self.inputMoney.text integerValue];
    if (inputMoney <= 0) {
        self.aimiIncome.text   = @"0元";
        self.yuXbaoIncome.text = @"0元";
        self.bankIncome.text   = @"0元";
    } else {
        
        NSInteger expires = self.expires.integerValue;
        if ([@"天" isEqualToString:self.unit]) {
            expires = 1;
        }
        
        self.interestCalculation.money = inputMoney;
        self.aimiIncome.text   = [NSString stringWithFormat:@"%.2f元", self.interestCalculation.sumOfInterest];
        self.yuXbaoIncome.text = [NSString stringWithFormat:@"%.2f元", YU_X_BAO*inputMoney*expires/12];
        self.bankIncome.text   = [NSString stringWithFormat:@"%.2f元", BANK*inputMoney*expires/12];
        [self updateProgress];
    }
}
- (void)updateProgress {
    
    self.aimiProgress.constant   = UISCREEN_WIDTH - 50 - 80;
    self.yuXbaoProgress.constant = YU_X_BAO*self.aimiProgress.constant/0.09;
    self.bankProgress.constant   = BANK*self.aimiProgress.constant/0.09;
    
    [UIView animateWithDuration:NORMAL_ANIMATION_DURATION animations:^{
        [self.view layoutIfNeeded];
    }];
}
- (void)resetProgress {
    
    self.aimiProgress.constant   = 0;
    self.yuXbaoProgress.constant = 0;
    self.bankProgress.constant   = 0;
    
    [self.view layoutIfNeeded];
}

#pragma mark - setter
- (void)setInputMoney:(LimitTextField *)inputMoney {
    _inputMoney = inputMoney;
    
    UIView *paddingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 20)];
    
    inputMoney.leftView = paddingView;
    inputMoney.leftViewMode = UITextFieldViewModeAlways;
}

- (CalculationOfInterest *)interestCalculation {
    
    if (!_interestCalculation) {
        
        NSInteger expires = self.expires.integerValue;
        CGFloat yield = self.yield.doubleValue/100;
        if ([@"天" isEqualToString:self.unit]) {
            yield = yield*expires/30; //将天的利率转为一个月的利率额度
            expires = 1;
        }
        _interestCalculation = [[CalculationOfInterest alloc] initWithCalculationPattern:self.type yield:yield expires:expires];
    }
    return _interestCalculation;
}

- (void)dealloc {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}

@end
