//
//  RegularEntrustVC.m
//  YuanXin_Project
//
//  Created by Yuanin on 16/5/3.
//  Copyright © 2016年 yuanxin. All rights reserved.
//

#import "RegularEntrustVC.h"

#import "WebVC.h"

#import "RegularInfoView.h"
#import "PickerAccessoryView.h"
#import "LimitTextField.h"

#import "BaseViewModel.h"
#import "ExclusiveButton.h"
#import "SinglePickerView.h"
#import "AlertViewManager.h"

@interface RegularEntrustVC () <UITextFieldDelegate>

//@property (strong, nonatomic) NSArray       *regularInfo;
@property (strong, nonatomic) BaseViewModel *baseViewModel;
//@property (strong, nonatomic) UIDatePicker  *datePicker;
//@property (strong, nonatomic) NSDateFormatter *dateFormat;
//
//@property (strong, nonatomic) IBOutlet ExclusiveButton *exclusiveButtons;
//@property (weak, nonatomic) IBOutlet UIScrollView *contentView;
//@property (weak, nonatomic) IBOutlet UIButton *saveAndEntrust;
////@property (strong, nonatomic) IBOutletCollection(RegularInfoView) NSArray<RegularInfoView *> *regularInfoViews;
//
//@property (weak, nonatomic) IBOutlet LimitTextField *entrustMoney;
//@property (weak, nonatomic) IBOutlet UITextField *entrustTime;
//@property (weak, nonatomic) IBOutlet UILabel *balance;
@property (weak, nonatomic) IBOutlet UITextField *PlanNameTF;

@property (weak, nonatomic) IBOutlet UITextField *YearsRateTF;
@property (weak, nonatomic) IBOutlet UITextField *TimeTF;

@property (weak, nonatomic) IBOutlet UIButton *AllMoneyBtn;

@property (weak, nonatomic) IBOutlet UIButton *SingleMoneyBtn;
@property (weak, nonatomic) IBOutlet UITextField *MoneyTF;

@property (weak, nonatomic) IBOutlet UISwitch *useRedSwitch;


@property (weak, nonatomic) IBOutlet NSLayoutConstraint *singleMoneyLBHeight;
@property (weak, nonatomic) IBOutlet UILabel *promotLB;

@property (weak, nonatomic) IBOutlet UILabel *singleMoneyNumLB;

@property (strong, nonatomic) SinglePickerView *aprPickerView;
@property (strong, nonatomic) SinglePickerView *dayPickerView;
@property (strong, nonatomic) IBOutletCollection(UITextField) NSArray *userInterFace;

@property (strong,nonatomic)NSArray *aprArr;
@property (strong,nonatomic)NSArray *dayArr;



@property (weak, nonatomic) IBOutlet NSLayoutConstraint *warmLBHeight;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *planNameLBHeight;


@property (weak, nonatomic) IBOutlet NSLayoutConstraint *planNameTFHeight;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *yearRateLBHeight;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *timeLBHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *entrustMoneyLBHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *allMoneyLBHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *allMoneyBtnWidth;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *aingleMoneyLBHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *singleMoneyBtnWidth;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *useRedMoneyLBHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *wenhaoHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *wenhaoWidth;

@end


@implementation RegularEntrustVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initUI];


    [self layoutNavigationLeftButtonWithImage:[UIImage imageNamed:Nav_Back_Image] block:^(__kindof UIViewController *viewController) {
        [viewController.navigationController popViewControllerAnimated:YES];
    }];
    

}
- (void)initUI{
    self.PlanNameTF.delegate  = self;
  
    [_PlanNameTF addTarget:self action:@selector(RestrictTextFieldLength:)
              forControlEvents:UIControlEventEditingChanged];
    self.YearsRateTF.delegate  = self;
    self.MoneyTF.delegate  = self;
    self.singleMoneyLBHeight.constant = 0;
    self.singleMoneyNumLB.hidden = YES;
  
    
    float screeRadio =  [UIScreen mainScreen].bounds.size.width/375.0;
    if ([UIScreen mainScreen].bounds.size.width < 375) {
        self.warmLBHeight.constant = 65*screeRadio;
        self.planNameLBHeight.constant = 44 *screeRadio;
        self.planNameTFHeight.constant = 44 *screeRadio;
        self.yearRateLBHeight.constant = 44 *screeRadio;
        self.timeLBHeight.constant = 44 *screeRadio;
        self.entrustMoneyLBHeight.constant = 44 *screeRadio;
        self.allMoneyLBHeight.constant = 44 *screeRadio;
        self.allMoneyBtnWidth.constant = 44 *screeRadio - 24;
        self.aingleMoneyLBHeight.constant =44 *screeRadio;
        self.singleMoneyBtnWidth.constant =44 *screeRadio - 24;
        self.useRedMoneyLBHeight.constant = 44 *screeRadio;
        self.wenhaoHeight.constant = 20 *screeRadio;
        self.wenhaoWidth.constant = 20*screeRadio;
    }
    
    
    
  
  
    NSMutableAttributedString *noteStr = [[NSMutableAttributedString alloc] initWithString:@"设置出借条件。充值或回款2小时后的资金，系统将进行自动投资。"];
    NSRange redRange = NSMakeRange([[noteStr string] rangeOfString:@"2小时"].location, [[noteStr string] rangeOfString:@"2小时后"].length);
    [noteStr addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:redRange];
    

    
    [self.promotLB setAttributedText:noteStr];
}
- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    
    [self.baseViewModel cancelFetchOperation];
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if (self.dataDic) {
        
    
    //方案名称
    self.PlanNameTF.text     = _dataDic[@"remark"];
    
    //投资期限
    NSString *min_unit = _dataDic[@"min_unit"];
    NSString *max_unit = _dataDic[@"max_unit"];
    if ([min_unit isEqualToString:max_unit]) {
        if ([min_unit isEqualToString:@"0"]) {
            self.TimeTF.text      = @"不限";
        }else{
            self.TimeTF.text      = [NSString stringWithFormat:@"%@个月",min_unit];
        }
    }else{
        if ([min_unit isEqualToString:@"0"]) {
            self.TimeTF.text      = [NSString stringWithFormat:@"0个月～%@个月",max_unit];
        }else{
            self.TimeTF.text      = [NSString stringWithFormat:@"%@个月～%@个月",min_unit,max_unit];
        }
    }
    // 年化收益
    NSString *min_annual = _dataDic[@"min_annual"];
    NSString *max_annual = _dataDic[@"max_annual"];
    
    if ([min_annual isEqualToString:max_annual]) {
        if ([min_annual isEqualToString:@"0"]) {
            self.YearsRateTF.text      = @"不限";
        }else{
            self.YearsRateTF.text      = [NSString stringWithFormat:@"%@%%",min_annual];
        }
    }else{
        if ([min_annual isEqualToString:@"0"]) {
            self.YearsRateTF.text      = [NSString stringWithFormat:@"1%%～%@%%",max_annual];
        }else{
            self.YearsRateTF.text      = [NSString stringWithFormat:@"%@%%～%@%%",min_annual,max_annual];
        }
    }
    
    
    //投资方式
    if ([_dataDic[@"all_amount"] integerValue] == 0) {
        self.SingleMoneyBtn.selected = YES;
        float screeRadio =  [UIScreen mainScreen].bounds.size.width/375.0;
        if ([UIScreen mainScreen].bounds.size.width < 375) {
            self.singleMoneyLBHeight.constant = 40 *screeRadio;
            self.singleMoneyNumLB.hidden = NO;
        }else{
            
            self.singleMoneyLBHeight.constant = 40;
            self.singleMoneyNumLB.hidden = NO;
        }
        self.AllMoneyBtn.selected = NO;
        self.MoneyTF.text = _dataDic[@"amount"];
    }else{
        self.SingleMoneyBtn.selected = NO;
        self.singleMoneyLBHeight.constant = 0;
        self.singleMoneyNumLB.hidden = YES;
        self.AllMoneyBtn.selected = YES;
    }
    
    //是否适用优惠券
    if ([_dataDic[@"is_red"] integerValue]== 0) {
        //        self.amount.text          = @"不使用";
        self.useRedSwitch.on = NO;
    }else{
        //        self.amount.text          = @"使用";
        self.useRedSwitch.on = YES;
    }
        
    }
    
}
//点击爱米理财投资协议 和委托投资规则
- (IBAction)ClickedProtcolAimi:(id)sender {
    
    [self.navigationController pushViewController:[WebVC webVCWithWebPath:[CommonTools completeWebPathWithSubpath: Introduce_Buy ]] animated:YES];
}
- (IBAction)ClickedAimiInvestRule:(id)sender {
    
     [self.navigationController pushViewController:[WebVC webVCWithWebPath:[CommonTools completeWebPathWithSubpath: Introduct_Entrust ]] animated:YES];
   
}

- (IBAction)clickdWenHao:(id)sender {
    [AlertViewManager showInViewController:self title:@"系统会为您自动选择符合条件的最大金额的加息红包" message:nil clickedButtonAtIndex:^(id alertView, NSInteger buttonIndex) {
        
    } cancelButtonTitle:@"朕知道了" otherButtonTitles:nil, nil];
    
}
- (IBAction)clickedUseDiscountSwitchBtn:(id)sender {
}

- (IBAction)ClickedAllMoneyBtn:(id)sender {
    self.AllMoneyBtn.selected = !self.AllMoneyBtn.selected;
    if (self.AllMoneyBtn.selected) {
         self.SingleMoneyBtn.selected = !self.AllMoneyBtn.selected;
        self.singleMoneyLBHeight.constant = 0;
        self.singleMoneyNumLB.hidden = YES;
    }
   
}

- (IBAction)ClickedSingleMoneyBtn:(id)sender {
    self.SingleMoneyBtn.selected = !self.SingleMoneyBtn.selected;
    
      if (self.SingleMoneyBtn.selected) {
         self.AllMoneyBtn.selected = !self.SingleMoneyBtn.selected;
         
          float screeRadio =  [UIScreen mainScreen].bounds.size.width/375.0;
          if ([UIScreen mainScreen].bounds.size.width < 375) {
              self.singleMoneyLBHeight.constant = 40 *screeRadio;
                self.singleMoneyNumLB.hidden = NO;
          }else{
              
              self.singleMoneyLBHeight.constant = 40;
              self.singleMoneyNumLB.hidden = NO;
          }
      }else{
          self.singleMoneyLBHeight.constant = 0;
            self.singleMoneyNumLB.hidden = YES;
      }
}

- (void)setDataDic:(NSDictionary *)dataDic{
    _dataDic = dataDic;
    
    //方案名称
    self.PlanNameTF.text     = dataDic[@"remark"];
    
    //投资期限
    NSString *min_unit = dataDic[@"min_unit"];
    NSString *max_unit = dataDic[@"max_unit"];
    if ([min_unit isEqualToString:max_unit]) {
        if ([min_unit isEqualToString:@"0"]) {
            self.TimeTF.text      = @"不限";
        }else{
            self.TimeTF.text      = [NSString stringWithFormat:@"%@个月",min_unit];
        }
    }else{
        if ([min_unit isEqualToString:@"0"]) {
            self.TimeTF.text      = [NSString stringWithFormat:@"0个月～%@个月",max_unit];
        }else{
            self.TimeTF.text      = [NSString stringWithFormat:@"%@个月～%@个月",min_unit,max_unit];
        }
    }
    // 年化收益
    NSString *min_annual = dataDic[@"min_annual"];
    NSString *max_annual = dataDic[@"max_annual"];
    
    if ([min_annual isEqualToString:max_annual]) {
        if ([min_annual isEqualToString:@"0"]) {
            self.YearsRateTF.text      = @"不限";
        }else{
            self.YearsRateTF.text      = [NSString stringWithFormat:@"%@%%",min_annual];
        }
    }else{
        if ([min_annual isEqualToString:@"0"]) {
            self.YearsRateTF.text      = [NSString stringWithFormat:@"1%%～%@%%",max_annual];
        }else{
            self.YearsRateTF.text      = [NSString stringWithFormat:@"%@%%～%@%%",min_annual,max_annual];
        }
    }
    
    
    //投资方式
    if ([dataDic[@"all_amount"] integerValue] == 0) {
        self.SingleMoneyBtn.selected = YES;
        
        float screeRadio =  [UIScreen mainScreen].bounds.size.width/375.0;
        if ([UIScreen mainScreen].bounds.size.width < 375) {
          self.singleMoneyLBHeight.constant = 40 *screeRadio;
            self.singleMoneyNumLB.hidden = NO;
        }else{
        
          self.singleMoneyLBHeight.constant = 40;
            self.singleMoneyNumLB.hidden = NO;
        }
        self.AllMoneyBtn.selected = NO;
        self.MoneyTF.text = dataDic[@"amount"];
    }else{
        self.SingleMoneyBtn.selected = NO;
        self.singleMoneyLBHeight.constant = 0;
        self.singleMoneyNumLB.hidden = YES;
        self.AllMoneyBtn.selected = YES;
    }
    
    //是否适用优惠券
    if ([dataDic[@"is_red"] integerValue]== 0) {
//        self.amount.text          = @"不使用";
        self.useRedSwitch.on = NO;
    }else{
//        self.amount.text          = @"使用";
        self.useRedSwitch.on = YES;
    }
    
    
    //    self.entrustSwitch.hidden = NO;
//    if ([aDic[@"status"] integerValue] == 0) {
//        self.entrustSwitch.on  = YES;
//    }else{
//        self.entrustSwitch.on  = NO;
//    }
//    

    
    
    
}

#pragma mark - delegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    [textField endEditing:YES];
    return YES;
}
//- (IBAction)RestrictTextFieldLength:(id)sender {
//    UITextField *textField = (UITextField *)sender;
//    NSString *temp = textField.text;
//    
//    if (textField.markedTextRange == nil) {
//        while(1){
//            if ([temp lengthOfBytesUsingEncoding:NSUTF8StringEncoding] <= 24) {
//                break;
//            }else {
//                temp = [temp substringToIndex:temp.length-1];
//            }
//        }
//        textField.text = temp;
//    }
//}
- (IBAction)RestrictTextFieldLength:(id)sender {
        UITextField *textField = (UITextField *)sender;
        NSString *temp = textField.text;
    
        if (textField.markedTextRange == nil) {
            while(1){
                if ([temp lengthOfBytesUsingEncoding:NSUTF8StringEncoding] <= 30) {
                    break;
                }else {
                    temp = [temp substringToIndex:temp.length-1];
                }
            }
            textField.text = temp;
        }
}


- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.PlanNameTF resignFirstResponder];
    [self.YearsRateTF resignFirstResponder];
    [self.MoneyTF resignFirstResponder];

  
}


- (void)setYearsRateTF:(UITextField *)YearsRateTF {
    
    _YearsRateTF = YearsRateTF;
    NSArray *arr = @[@[@"不限",@"7",@"8",@"9",@"10",@"11",@"12",@"13"],@[@"不限",@"7",@"8",@"9",@"10",@"11",@"12",@"13"]];
    self.aprPickerView.pickerInfo = arr;
        _YearsRateTF.inputView = self.aprPickerView;

        __weak UITextField *weak_text = _YearsRateTF;
        @weakify(self)
        _YearsRateTF.inputAccessoryView = [PickerAccessoryView pickerAccessoryViewWithDoneBlock:^{
            @strongify(self)
            [weak_text endEditing:YES];
            
            self.aprArr = [self.aprPickerView selectedInfo];
            
            
            if ([_aprArr[0] isEqualToString:_aprArr[1]]) {
                if ([_aprArr[0] isEqualToString:@"不限"]) {
                    weak_text.text = @"不限";
                

                }else{
                    weak_text.text = [NSString stringWithFormat:@"%@%%",_aprArr[0]];
                    
                }
//
            }else{
                if ([_aprArr[0] isEqualToString:@"不限"]) {
                      weak_text.text = [NSString stringWithFormat:@"7%%~%@%%",_aprArr[1]];
                }else{
                     weak_text.text = [NSString stringWithFormat:@"%@%%~%@%%",_aprArr[0],_aprArr[1]];
                }
                
            }
           
        } cancelBlock:^{
            [weak_text endEditing:YES];
        }];
        
        UIView *paddingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 20)];
        _YearsRateTF.leftView = paddingView;
        _YearsRateTF.leftViewMode = UITextFieldViewModeAlways;
    
}
- (void)setTimeTF:(UITextField *)TimeTF{
    _TimeTF = TimeTF;
    NSArray *arr = @[@[@"不限",@"1",@"3",@"6",@"12",@"18",@"24"],@[@"不限",@"1",@"3",@"6",@"12",@"18",@"24"]];
    self.dayPickerView.pickerInfo = arr;
    _TimeTF.inputView = self.dayPickerView;

    __weak UITextField *weak_text = _TimeTF;
    @weakify(self)
    _TimeTF.inputAccessoryView = [PickerAccessoryView pickerAccessoryViewWithDoneBlock:^{
        @strongify(self)
        [weak_text endEditing:YES];
        self.dayArr = [self.dayPickerView selectedInfo];
        if ([_dayArr[0] isEqualToString:_dayArr[1]]) {
            if ([_dayArr[0] isEqualToString:@"不限"]) {
                weak_text.text = @"不限";
                
                
            }else{
                NSString * str = [NSString stringWithFormat:@"%@",_dayArr[0]];
                NSInteger i = [str integerValue] *30;
                weak_text.text = [NSString stringWithFormat:@"%@个月(%li天)",_dayArr[0], i ];
                
            }
            //
        }else{
            if ([_dayArr[0] isEqualToString:@"不限"]) {
                NSString * str = [NSString stringWithFormat:@"%@",_dayArr[1]];
                NSInteger i = [str integerValue] *30;
                weak_text.text = [NSString stringWithFormat:@"0~%@个月(0~%li天)",_dayArr[1],i];
            }else{
                NSString * str = [NSString stringWithFormat:@"%@",_dayArr[0]];
                NSInteger i = [str integerValue] *30;
                NSString * str2 = [NSString stringWithFormat:@"%@",_dayArr[1]];
                NSInteger j = [str2 integerValue] *30;
                weak_text.text = [NSString stringWithFormat:@"%@~%@个月(%li天~%li天)",_dayArr[0],_dayArr[1],i,j];
            }
            
        }
        
    } cancelBlock:^{
        [weak_text endEditing:YES];
    }];
    
    UIView *paddingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 20)];
    _YearsRateTF.leftView = paddingView;
    _YearsRateTF.leftViewMode = UITextFieldViewModeAlways;
}


- (IBAction)saveAndEntrustBtnClicked:(id)sender {
        NSMutableDictionary *params = [[UserinfoManager sharedUserinfo] increaseUserParams:nil];
    
    
    if ( [self.PlanNameTF.text lengthOfBytesUsingEncoding:NSUTF8StringEncoding]   < 1  ) {
        [SpringAlertView showMessage:@"请输入方案名称"];
        return;
    }
    if ([self.PlanNameTF.text lengthOfBytesUsingEncoding:NSUTF8StringEncoding] > 30  ) {
        [SpringAlertView showMessage:@"方案名称过长"];
        return;
    }
//    方案id  如果是编辑传入 新增不传
    if (self.dataDic) {
        [params setObject:_dataDic[@"id"] forKey:@"id"];
    }
    
    
    //方案名称
    [params setObject:self.PlanNameTF.text forKey:@"remark"];
    
    
     NSArray *annualArr = [self.aprPickerView selectedInfo];
    if (self.dataDic && !self.aprArr.count) {
       
           [params setObject:self.dataDic[@"min_annual"] forKey:@"min_annual"];
            [params setObject:self.dataDic[@"max_annual"] forKey:@"max_annual"];
        
    
    }else{
    //利率
   
    if ([annualArr[0] isEqualToString:@"不限"]) {
        [params setObject:@"0" forKey:@"min_annual"];
    }else{
        [params setObject:annualArr[0] forKey:@"min_annual"];
    }
    if ([annualArr[1] isEqualToString:@"不限"]) {
        [params setObject:@"0" forKey:@"max_annual"];
    }else{
        [params setObject:annualArr[1] forKey:@"max_annual"];
    }
}

    
    //期限
    NSArray *dateArr = [self.dayPickerView selectedInfo];
    
    
    if (self.dataDic && !self.dayArr.count) {
        
        [params setObject:self.dataDic[@"min_unit"] forKey:@"min_unit"];
        [params setObject:self.dataDic[@"max_unit"] forKey:@"max_unit"];
        
        
    }else{
    
    if ([dateArr[0] isEqualToString:@"不限"]) {
        [params setObject:@"0" forKey:@"min_unit"];
    }else{
        [params setObject:dateArr[0] forKey:@"min_unit"];
    }
    if ([dateArr[1] isEqualToString:@"不限"]) {
        [params setObject:@"0" forKey:@"max_unit"];
    }else{
        [params setObject:dateArr[1] forKey:@"max_unit"];
    }
    
}
   
    if ([[params objectForKey:@"min_unit" ] isEqualToString:@"0"] &&[[params objectForKey:@"max_unit" ] isEqualToString:@"0"]&&[[params objectForKey:@"max_annual" ] isEqualToString:@"0"]&& [[params objectForKey:@"min_annual" ] isEqualToString:@"0"]) {
        [SpringAlertView showMessage:@"请至少选择一个利率区间或期限区间"];
            return;
    }
   
    
//    单笔固定投资 & 账户余额全部投资
    if (!self.SingleMoneyBtn.selected && !self.AllMoneyBtn.selected ) {
            [SpringAlertView showMessage:@"请选择投资方案"];
            return;
        }
    if (self.SingleMoneyBtn.selected  ) {
        if ( [self.MoneyTF.text integerValue]%100 != 0 || [self.MoneyTF.text integerValue] < 1000) {
            [SpringAlertView showMessage:NSLocalizedString(@"err_money", nil)];
            return;
        }

       
    }

    
    if (self.SingleMoneyBtn.selected) {
        [params setObject:@"0" forKey:@"all_amount"];
        [params setObject:self.MoneyTF.text forKey:@"amount"];
    }else{
         [params setObject:@"1" forKey:@"all_amount"];
    }
    
    
//   红包
    if (self.useRedSwitch.on) {
        [params setObject:@"1" forKey:@"is_red"];
    }else{
       [params setObject:@"0" forKey:@"is_red"];
    }
    
    
    
    ////    2.9、saveentrustdeposit （保存定期委托投资） => userid（用户uid）、mobile（手机号）、borrow_id（定期理财项目id）、amount（委托金额）、entrustdate（委托时间）
    ////    返回值 result=1表示委托成功；0表示委托失败
    //
    //    if (!self.entrustMoney.success || [self.entrustMoney.text integerValue]%100 != 0 || [self.entrustMoney.text integerValue] < 1000) {
    //        [SpringAlertView showMessage:NSLocalizedString(@"err_money", nil)];
    //        return;
    //    }
    //
    //    NSMutableDictionary *params = [[UserinfoManager sharedUserinfo] increaseUserParams:nil];
//        [params addEntriesFromDictionary:@{@"borrow_id":self.regularInfo[self.exclusiveButtons.invalidButton.tag][@"id"], @"amount": self.entrustMoney.text, @"entrustdate":self.entrustTime.text}];
    //
        @weakify(self)
        [self.baseViewModel postMethod:@"auto_save" params:params success:^(id result) {
            @strongify(self)
    
            [SpringAlertView showMessage:result[RESULT_REMARK]];
            [self.navigationController popViewControllerAnimated:YES];
            if (self.entrustSuccess) {
                self.entrustSuccess();
            }
        } failure:^(id result, NSString *errorDescription) {
            
            [SpringAlertView showMessage:errorDescription];
        }];
    
    
}


- (SinglePickerView *)dayPickerView {
    if (!_dayPickerView) {
        _dayPickerView = [[SinglePickerView alloc] init];
        _dayPickerView.frame = CGRectMake(0, 0, UISCREEN_WIDTH, 180);
    }
    return _dayPickerView;
}
- (SinglePickerView *)aprPickerView {
    if (!_aprPickerView) {
        _aprPickerView = [[SinglePickerView alloc] init];
        _aprPickerView.frame = CGRectMake(0, 0, UISCREEN_WIDTH, 180);
    
    }
    return _aprPickerView;
}
- (NSArray *)aprArr{
    if (!_aprArr) {
        _aprArr = [[NSArray alloc]init];
    }
    return _aprArr;
}
- (NSArray *)dayArr{
    if (!_dayArr) {
        _dayArr = [[NSArray alloc]init];
    }
    return _dayArr;
}



//- (void)fetchRegularEntrustInfo {
////    2.8、getentrustdepositproject （定期委托理财产品列表）
////    返回list  id（定期理财项目id）、period（期限《1、3、6、12月》）、apr（年化收益率）、projectname（名称）
//    [BaseIndicatorView showInView:self.view maskType:kIndicatorNoMask];
//    @weakify(self)
//    [self.baseViewModel postMethod:@"getentrustdepositproject" params:[[UserinfoManager sharedUserinfo] increaseUserParams:nil] success:^(id result) {
//        @strongify(self)
//        
//        [BaseIndicatorView hideWithAnimation:self.didShow];
//        self.regularInfo = result[RESULT_DATA];
//    } failure:^(id result, NSString *errorDescription) {
//        @strongify(self)
//        
//        [BaseIndicatorView hideWithAnimation:self.didShow];
//        [SpringAlertView showMessage:errorDescription];
//    }];
//}
//- (void)setRegularInfo:(NSArray *)regularInfo {
//    if (regularInfo.count < 4) return;
//    if ([_regularInfo isEqualToArray:regularInfo]) return;
//    
//    _regularInfo = regularInfo;
//    
//    for (RegularInfoView *view in self.regularInfoViews) {
//        [view loadInterfaceWithDictionary:regularInfo[view.tag]];
//    }
//    
//    self.contentView.hidden = NO;
//    self.saveAndEntrust.hidden = NO;
//}
//

//#pragma mark - action
//- (IBAction)entrust {
////    2.9、saveentrustdeposit （保存定期委托投资） => userid（用户uid）、mobile（手机号）、borrow_id（定期理财项目id）、amount（委托金额）、entrustdate（委托时间）
////    返回值 result=1表示委托成功；0表示委托失败
//    
//    if (!self.entrustMoney.success || [self.entrustMoney.text integerValue]%100 != 0 || [self.entrustMoney.text integerValue] < 1000) {
//        [SpringAlertView showMessage:NSLocalizedString(@"err_money", nil)];
//        return;
//    }
//    
//    NSMutableDictionary *params = [[UserinfoManager sharedUserinfo] increaseUserParams:nil];
//    [params addEntriesFromDictionary:@{@"borrow_id":self.regularInfo[self.exclusiveButtons.invalidButton.tag][@"id"], @"amount": self.entrustMoney.text, @"entrustdate":self.entrustTime.text}];
//    
//    @weakify(self)
//    [self.baseViewModel postMethod:@"saveentrustdeposit" params:params success:^(id result) {
//        @strongify(self)
//        
//        [SpringAlertView showMessage:result[RESULT_REMARK]];
//        [self.navigationController popViewControllerAnimated:YES];
//        if (self.entrustSuccess) {
//            self.entrustSuccess();
//        }
//    } failure:^(id result, NSString *errorDescription) {
//        
//        [SpringAlertView showMessage:errorDescription];
//    }];
//}
//
//
//- (IBAction)intoProtocol:(UIButton *)sender {
//    
//    [self.navigationController pushViewController:[WebVC webVCWithWebPath:[CommonTools completeWebPathWithSubpath:0 == sender.tag ? Introduce_Buy : Introduct_Entrust]] animated:YES];
//}
//
//#pragma mark - setter
//- (void)setRegularInfoViews:(NSArray<RegularInfoView *> *)regularInfoViews {
//    _regularInfoViews = regularInfoViews;
//    
//    for (RegularInfoView *view in regularInfoViews) {
//        if (0 == view.tag) {
//            [self.exclusiveButtons appendButton:view.clickButton invalid:YES];
//        } else {
//            [self.exclusiveButtons appendButton:view.clickButton invalid:NO];
//        }
//        view.clickButton.tag = view.tag;
//    }
//}
//- (void)setEntrustTime:(UITextField *)entrustTime {
//    _entrustTime = entrustTime;
//    
//    entrustTime.text = [self.dateFormat stringFromDate:[NSDate date]];
//    entrustTime.inputView = self.datePicker;
//    
//    @weakify(self);
//    entrustTime.inputAccessoryView = [PickerAccessoryView pickerAccessoryViewWithDoneBlock:^{
//        @strongify(self)
//        
//        [self.entrustTime endEditing:YES];
//        self.entrustTime.text = [self.dateFormat stringFromDate:self.datePicker.date];
//    } cancelBlock:^{
//        @strongify(self)
//        
//        [self.entrustTime endEditing:YES];
//    }];
//}
//- (void)setBalance:(UILabel *)balance {
//    _balance = balance;
//    
//    [RACObserve([UserinfoManager sharedUserinfo].userInfo, balance) subscribeNext:^(NSString *newBalance) {
//        balance.text = newBalance;
//    }];
//}
//
//#pragma mark - getter
- (BaseViewModel *)baseViewModel {
    if (!_baseViewModel) {
        _baseViewModel = [[BaseViewModel alloc] init];
    }
    return _baseViewModel;
}
//- (UIDatePicker *)datePicker {
//    
//    if (!_datePicker) {
//        _datePicker = [[UIDatePicker alloc] init];
//        _datePicker.datePickerMode = UIDatePickerModeDate;
//        _datePicker.minimumDate = [NSDate date];
//    }
//    return _datePicker;
//}
//- (NSDateFormatter *)dateFormat {
//    
//    if (!_dateFormat) {
//        _dateFormat = [[NSDateFormatter alloc] init];
//        _dateFormat.dateFormat = @"y/MM/dd";
//    }
//    return _dateFormat;
//}
@end
