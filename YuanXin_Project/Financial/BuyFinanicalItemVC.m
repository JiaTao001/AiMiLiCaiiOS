//
//  BuyFinanicalItemVC.m
//  YuanXin_Project
//
//  Created by Yuanin on 15/12/28.
//  Copyright © 2015年 yuanxin. All rights reserved.
//

#import "BuyFinanicalItemVC.h"

#import "AuthenticationVC.h"
#import "BuySuccessPromptVC.h"
#import "ProductDetailVC.h"
#import "WebVC.h"
#import "RewardVC.h"
#import "SinaWebVC.h"

#import "KeyboardScrollView.h"
#import "MJRefresh.h"
#import "CrossButton.h"

#import "KaiHuViewController.h"

#import "HKWebVC.h"
#import "WarmmingView.h"
#define PRODUCT_DETAIL_ID_KEY @"productid"
#import "BingDingCardVC.h"

@interface BuyFinanicalItemVC () <UITextFieldDelegate>

@property (strong, nonatomic) NSURLSessionTask *task;

@property (weak, nonatomic) IBOutlet KeyboardScrollView *contentView;
@property (weak, nonatomic) IBOutlet UIView             *notNewView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *notNewViewHeight;
@property (weak, nonatomic) IBOutlet UILabel            *customTitle;

@property (strong, nonatomic) NSDictionary *bonusInfo;
@property (weak, nonatomic) IBOutlet UIButton *selectBonus;
@property (weak, nonatomic) IBOutlet UILabel *bonusMoney;

@property (weak, nonatomic) IBOutlet CrossButton        *crossButton;
@property (weak, nonatomic) IBOutlet KeyboardScrollView *showContent;
@property (weak, nonatomic) IBOutlet UIButton           *submitButton;

//@property (weak, nonatomic) IBOutlet NSLayoutConstraint *buyShareCon;
@property (weak, nonatomic) IBOutlet UITextField        *moneyShare;
@property (weak, nonatomic) IBOutlet UIButton           *agree;

@property (weak, nonatomic) IBOutlet UILabel *yield;
@property (weak, nonatomic) IBOutlet UILabel *timeLimit;
@property (weak, nonatomic) IBOutlet UILabel *unit;
@property (weak, nonatomic) IBOutlet UILabel *surplusMoney;
@property (weak, nonatomic) IBOutlet UILabel *anticipatedIncome;
@property (weak, nonatomic) IBOutlet UILabel *payMoney;
@property (weak, nonatomic) IBOutlet UILabel *availablyBalance;

//@property (weak, nonatomic) IBOutlet UILabel *single;
@property (strong,nonatomic)NSString *single;
@property (assign, nonatomic) NSInteger singleOfProduct;
@property (assign, nonatomic) NSInteger minMoney;/**< 最小购买额度 */
@property (assign, nonatomic) NSInteger maxMoney;/**< 最大购买额度 */
@property (assign, nonatomic) BOOL  didAuthorization;
//@property (assign, nonatomic) NSInteger maxAuthorizationMoney;
@property (assign, nonatomic) CGFloat interestRate;
@property (strong,nonatomic)WarmmingView *warmmingView;


@property (strong, nonatomic) NSArray * bonusArr;
@end

@implementation BuyFinanicalItemVC

#pragma mark - life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self layoutNavigationLeftButtonWithImage:[UIImage imageNamed:Nav_Back_Image] block:^(UIViewController *viewController) {
        [viewController.navigationController popViewControllerAnimated:YES];
    }];
      [self.moneyShare becomeFirstResponder];
    @weakify(self)
    [[[NSNotificationCenter defaultCenter] rac_addObserverForName:UITextFieldTextDidChangeNotification object:self.moneyShare] subscribeNext:^(NSNotification *notifictaion) {
        @strongify(self)
        
        if (self.moneyShare.text.integerValue > self.surplusMoney.text.integerValue) {
            self.moneyShare.text = self.surplusMoney.text;
        }
        self.payMoney.text          = [NSString stringWithFormat:@"%.02f", self.moneyShare.text.doubleValue];
//        self.anticipatedIncome.text = [NSString stringWithFormat:@"%.02f", self.moneyShare.text.integerValue*self.interestRate/100.0];
        
        self.anticipatedIncome.text =[NSString stringWithFormat:@"%.02f", [[self stringByNotRounding:self.moneyShare.text.integerValue*self.interestRate/100.0 afterPoint:2] floatValue] ];
        
        
        self.bonusInfo = nil;
        for (NSDictionary *dict in self.bonusArr) {
            if (self.moneyShare.text.integerValue >= [dict[@"min_invest_amount"] integerValue]) {
                if ([self.bonusInfo[@"amount"] integerValue] < [dict[@"amount"] integerValue]) {
                    self.bonusInfo = dict;
                    break;
                }
                
            }
        }
        
        if (self.moneyShare.text.integerValue < [self.bonusInfo[@"min_invest_amount"] integerValue] ) {
            self.bonusInfo = nil;
        }
        
        
    }];
}
-(NSString *)stringByNotRounding:(double)price afterPoint:(int)position{
    NSDecimalNumberHandler* roundingBehavior = [NSDecimalNumberHandler decimalNumberHandlerWithRoundingMode:NSRoundDown scale:position raiseOnExactness:NO raiseOnOverflow:NO raiseOnUnderflow:NO raiseOnDivideByZero:NO];
    NSDecimalNumber *ouncesDecimal;
    NSDecimalNumber *roundedOunces;
    
    ouncesDecimal = [[NSDecimalNumber alloc] initWithFloat:price];
    roundedOunces = [ouncesDecimal decimalNumberByRoundingAccordingToBehavior:roundingBehavior];
    
    return [NSString stringWithFormat:@"%@",roundedOunces];
   
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self fetchProductdetail];
}
- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    
    [self.task cancel];
}

#pragma mark - delegate
//***************UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    [textField resignFirstResponder];
    return YES;
}
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    
    if (!textField.text.length) {
//        self.buyShareCon.constant = ROW_HEIGHT/2;
        [UIView animateWithDuration:NORMAL_ANIMATION_DURATION animations:^{
            [self.view layoutIfNeeded];
        }];
    }
    return YES;
}
- (BOOL)textFieldShouldEndEditing:(UITextField *)textField {
    
    if (!textField.text.length) {
//        self.buyShareCon.constant = 0;
        [UIView animateWithDuration:NORMAL_ANIMATION_DURATION animations:^{
            [self.view layoutIfNeeded];
        }];
    }
    return YES;
}

#pragma mark - action
- (IBAction)changeAgreement:(UIButton *)sender {
    
    sender.selected = !sender.selected;
}
- (IBAction)selectBonus:(UIButton *)sender {
    
    RewardVC *vc = [AiMiApplication obtainControllerForMainStoryboardWithID:REWARD_STORYBOARD_ID];
    
    @weakify(self)
    [vc setMoneyShare:self.moneyShare.text callBack:^(NSDictionary *bonusInfo) {
        @strongify(self)
        
        self.bonusInfo = bonusInfo;
    }];
    [self.navigationController pushViewController:vc animated:YES];
}
- (IBAction)deleteBonus:(CrossButton *)sender {
    
    if (self.bonusInfo) {
        self.bonusInfo = nil;
    } else {
        [self selectBonus:nil];
    }
}

- (void)fetchProductdetail {
    if (!self.productInfo.productID) return;
    
    NSMutableDictionary *params = [[UserinfoManager sharedUserinfo] increaseUserParams:nil];
    [params setValue:self.productInfo.productID forKey:@"productid"];
    
    [BaseIndicatorView showInView:self.view maskType:kIndicatorNoMask];
    @weakify(self)
    self.task = [NetworkContectManager sessionPOSTWithMothed:@"getbuyproductdetail" params:params success:^(NSURLSessionTask *task, id result) {
        @strongify(self)
        
        [BaseIndicatorView hideWithAnimation:self.didShow];
        [self.contentView.header endRefreshing];
        [self configureInterfact:[result[RESULT_DATA] firstObject]];
    } failure:^(NSURLSessionTask *task, id result, NSString *errorDescription) {
        @strongify(self)
        
        [BaseIndicatorView hideWithAnimation:self.didShow];
        [self.contentView.header endRefreshing];
        [SpringAlertView showInWindow:self.view.window message:errorDescription];
    }];
}
- (void)configureInterfact:(NSDictionary *)aDic {
    
    //给view赋值
    self.customTitle.text  = aDic[@"project_name"];
//    self.yield.text        = [CommonTools convertToStringWithObject:aDic[@"annual"]];
    if ([aDic[@"extannual"] floatValue] != 0.00f) {
        NSString *rateString = [NSString stringWithFormat:@"%@%%+%@%%",[CommonTools convertToStringWithObject:aDic[@"organnual"]],[CommonTools convertToStringWithObject:aDic[@"extannual"]] ];
        NSString *addString = [NSString stringWithFormat:@"%%+%@%%",[CommonTools convertToStringWithObject:aDic[@"extannual"]] ];
        
        self.yield.text = rateString;
        //        NSString
        
        
        NSMutableAttributedString *noteStr = [[NSMutableAttributedString alloc] initWithString:rateString];
        NSRange redRange = NSMakeRange([[noteStr string] rangeOfString:addString].location, [[noteStr string] rangeOfString:addString].length);
        //        [noteStr addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:redRange];
        [noteStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:13.0f] range:redRange];
        
        
        [self.yield setAttributedText:noteStr];
        [self.yield sizeToFit];
    }else{
        
        NSString *rateString = [NSString stringWithFormat:@"%@%%",[CommonTools convertToStringWithObject:aDic[@"organnual"]] ];
        NSString *addString = [NSString stringWithFormat:@"%%"];
        
        self.yield.text = rateString;
        //        NSString
        
        
        NSMutableAttributedString *noteStr = [[NSMutableAttributedString alloc] initWithString:rateString];
        NSRange redRange = NSMakeRange([[noteStr string] rangeOfString:addString].location, [[noteStr string] rangeOfString:addString].length);
        //        [noteStr addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:redRange];
        [noteStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:13.0f] range:redRange];
        
        
        [self.yield setAttributedText:noteStr];
        [self.yield sizeToFit];
        //        self.yearRateLB.text = [NSString stringWithFormat:@"%@%%",[CommonTools convertToStringWithObject:aDic[@"organnual"]]];
    }
    
    
    
    
    
    self.timeLimit.text    = [CommonTools convertToStringWithObject:aDic[@"term"]];
    
    
    
    
    
    self.unit.text         = aDic[@"unit"];
    self.surplusMoney.text = [CommonTools convertToStringWithObject:aDic[@"amount"]];
    self.single       = [CommonTools convertToStringWithObject:aDic[@"eachamount"]];
    self.moneyShare.placeholder = [NSString stringWithFormat:@"请输入%@的整数倍",self.single];
    self.singleOfProduct       = self.single.integerValue;
    self.minMoney              = [aDic[@"minbuyvote"] integerValue];
    self.maxMoney              = [aDic[@"maxbuyvote"] integerValue];
    self.didAuthorization      = [aDic[@"is_open_withhold_authority"] boolValue];
//    self.maxAuthorizationMoney = [aDic[@"single_max_withhold_amount"] integerValue];
    self.interestRate          = [aDic[@"interest"] doubleValue];
    
    if (![aDic[@"is_new"] integerValue]) {
        self.bonusArr  = aDic[@"list"];
    }
    
    //更新余额
    [[UserinfoManager sharedUserinfo].userInfo updateBalance:[CommonTools convertToStringWithObject:aDic[@"balance"]]];
    
    //更新授权
    
    [[UserinfoManager sharedUserinfo].userInfo updateis_activate_hkaccount:[CommonTools convertToStringWithObject:aDic[@"is_activate_hkaccount"]]];
    
    [[UserinfoManager sharedUserinfo].userInfo updateis_bind_bankcard:[CommonTools convertToStringWithObject:aDic[@"is_bind_bankcard"]]];
    
    @weakify(self)
    [RACObserve([UserinfoManager sharedUserinfo].userInfo, balance) subscribeNext:^(NSString *newBalance) {
        @strongify(self)
        self.availablyBalance.text = newBalance;
    }];
    self.submitButton.enabled = 1 == [aDic[@"isbuy"] intValue] ? : NO;
    
    if (0 == [self.surplusMoney.text integerValue]) {
        [self.submitButton setTitle:NSLocalizedString(@"sellout", nil) forState:UIControlStateNormal];
    }
    
    if (1 == [aDic[@"is_new"] integerValue]) {
        self.notNewView.hidden = YES;
        self.notNewViewHeight.constant = 0;
    }
    
    self.showContent.hidden  = self.submitButton.hidden = NO;
}
- (IBAction)intoBuyProtocol:(UIButton *)sender {
    
    [self.navigationController pushViewController:[WebVC webVCWithWebPath:[CommonTools completeWebPathWithSubpath:@"html/instruction.html"]] animated:YES];
}


#pragma mark - 购买流程
- (IBAction)buyProduct {
    
    NSInteger buyMoney = self.moneyShare.text.integerValue;
    if (buyMoney%self.singleOfProduct) {
        [SpringAlertView showMessage:[NSString stringWithFormat:@"请输入%@的整数倍", self.single]];
        return;
    }
    if (buyMoney < self.minMoney) {
        [SpringAlertView showMessage:[NSString stringWithFormat:@"出借金额不能小于%li元", (long)self.minMoney]];
        return;
    }
    if (0 != self.maxMoney && buyMoney > self.maxMoney) {
        [SpringAlertView showMessage:[NSString stringWithFormat:@"出借金额不能大于%li元", (long)self.maxMoney]];
        return;
    }
    if (!self.agree.selected) {
        [SpringAlertView showMessage:@"请阅读出借风险提示及禁止性行为说明书并且同意后再购买"];
        return;
    }
    if (self.bonusInfo && self.moneyShare.text.doubleValue < [self.bonusInfo[@"min_invest_amount"] doubleValue]) {
        [SpringAlertView showMessage:@"您输入的出借金额小于加息红包的最小出借额度。请修改出借金额或者更改加息红包"];
        return;
    }
    [self.view endEditing:YES];
    
    if ([[UserinfoManager sharedUserinfo].userInfo.is_activate_hkaccount integerValue]!= 1) {
        [self showWarmView];
    } else if ([self.moneyShare.text doubleValue] > [[UserinfoManager sharedUserinfo].userInfo.balance doubleValue]) {
        [self goRecharge];
    }else {
        [self buyRegular];
    }
}
- (void)showWarmView{
    // 1：已激活；0：普通用户待开户；2：导入用户待激活
    if ([[UserinfoManager sharedUserinfo].userInfo.is_activate_hkaccount integerValue]  == 0 ) {
        @weakify(self)
        [self.warmmingView showInView:[UIApplication sharedApplication].keyWindow WithImageName:@"kaihu" clickImage:^{
            @strongify(self)
            //            [self.bonusAnimationView removeFromSuperview];
            [self.warmmingView dissMiss];
            
        }];
        self.warmmingView.ShareBlock = ^(){
            @strongify(self)
            [self.warmmingView dissMiss];
            [self.navigationController pushViewController:[AiMiApplication obtainControllerForStoryboard:@"Auth" controller:NSStringFromClass([KaiHuViewController class])] animated:YES ];
            
            
        };
        
        
    }else if([[UserinfoManager sharedUserinfo].userInfo.is_activate_hkaccount integerValue]  == 2){
        @weakify(self)
        [self.warmmingView showInView:[UIApplication sharedApplication].keyWindow WithImageName:@"jihuo" clickImage:^{
            @strongify(self)
            
            [self.warmmingView dissMiss];
            
            
            
        }];
        self.warmmingView.ShareBlock = ^(){
            @strongify(self)
            [self.warmmingView dissMiss];
            
            
        
            [self goToJiHuo];
            //            
            
            
            
        };
    }
    
    
}
- (void)goToJiHuo{
    [BaseIndicatorView showInView:self.view];
    @weakify(self)
    self.task = [[UserinfoManager sharedUserinfo] startRequest:kUserinfoOperationJiHuo params:nil success:^(id result) {
        @strongify(self)
        [BaseIndicatorView hideWithAnimation:self.didShow];
        
        [SpringAlertView showInWindow:self.view.window message:result[RESULT_REMARK]];
        [self pushToNextItemWithUrl:[result[@"data"] firstObject][@"redirect_url"]];
    } failure:^( id result, NSString *errorDescription) {
        @strongify(self)
        
        [BaseIndicatorView hideWithAnimation:self.didShow];
        [SpringAlertView showInWindow:self.view.window message:errorDescription];
    }];
    
    
}
- (void)pushToNextItemWithUrl:(NSString *)url{
    [self.navigationController pushViewController:[HKWebVC webVCWithWebPath:url] animated:YES];
}

//- (void)goAuthorization {
//    [AlertViewManager showInViewController:self title:@"提示" message:@"请先设置新浪代扣授权" clickedButtonAtIndex:^(id alertView, NSInteger buttonIndex) {
//        if (1 == buttonIndex) {
//            [self presentViewController:[SinaWebVC sinaWebWithServerPath:@"set_sina_withhold_authority" params:nil] animated:YES completion:nil];
//        }
//    } cancelButtonTitle:NSLocalizedString(@"cancel", nil) otherButtonTitles:@"去授权", nil];
//}
//- (void)alterAuthorization {
//    [AlertViewManager showInViewController:self title:@"提示" message:@"新浪代扣授权额度不足，请修改授权额度" clickedButtonAtIndex:^(id alertView, NSInteger buttonIndex) {
//        if (1 == buttonIndex) {
//            [self presentViewController:[SinaWebVC sinaWebWithServerPath:@"set_sina_withhold_authority" params:nil] animated:YES completion:nil];
//        }
//    } cancelButtonTitle:NSLocalizedString(@"cancel", nil) otherButtonTitles:@"去修改", nil];
//}
//- (void)goAuthentication {
//    [AlertViewManager showInViewController:self title:@"提示" message:@"信息未完善，请先去完善信息" clickedButtonAtIndex:^(id alertView, NSInteger buttonIndex) {
//        if (1 == buttonIndex) {
//            [self.navigationController pushViewController:[[AuthenticationVC alloc] init] animated:YES];
//        }
//    } cancelButtonTitle:NSLocalizedString(@"cancel", nil) otherButtonTitles:@"去完善", nil];
//
//}
- (void)goRecharge {
    
    if ([[UserinfoManager sharedUserinfo].userInfo.is_bind_bankcard integerValue]!= 1) {
        [AlertViewManager showInViewController:self title:@"提示" message:@"您尚未绑定银行卡，充值请先绑卡" clickedButtonAtIndex:^(id alertView, NSInteger buttonIndex) {
            if (1 == buttonIndex) {
                   [self.navigationController pushViewController:[AiMiApplication obtainControllerForStoryboard:@"Main" controller:NSStringFromClass([BingDingCardVC class])] animated:YES ];
               
            }
             return ;
        } cancelButtonTitle:NSLocalizedString(@"cancel", nil) otherButtonTitles:@"去绑定", nil];
    }
    
    
    NSInteger money           = ceil([self.moneyShare.text doubleValue] - [[UserinfoManager sharedUserinfo].userInfo.balance doubleValue]);//向上取整
    NSString *needMoney       = [[UserinfoManager sharedUserinfo].formatter stringFromNumber:@(money)];
    NSString *message         = [[NSString alloc] initWithFormat:@"您的余额不足以购买您输入的金额，您是否需要充值"];
    NSString *rechargeMessage = [NSString stringWithFormat:@"充值%@元", needMoney];
    [AlertViewManager showInViewController:self title:nil message:message clickedButtonAtIndex:^(id alertView, NSInteger buttonIndex) {
        if (1 == buttonIndex) {
//            [self presentViewController:[SinaWebVC sinaWebWithServerPath:@"sina_recharge" params:@{@"amount":needMoney}] animated:YES completion:nil];
            
            NSDictionary *dict = [NSDictionary dictionaryWithObject:needMoney forKey:@"amount"];
            
            [BaseIndicatorView showInView:self.view maskType:kIndicatorNoMask];
            
            @weakify(self)
            self.task = [NetworkContectManager sessionPOSTWithMothed:@"haikou_recharge" params:[[UserinfoManager sharedUserinfo] increaseUserParams:dict] success:^(NSURLSessionTask *task, id result) {
                @strongify(self)
                
                [BaseIndicatorView hideWithAnimation:self.didShow];
                [self pushToNextItemWithUrl:[result[@"data"] firstObject][@"redirect_url"]];
            } failure:^(NSURLSessionTask *task, id result, NSString *errorDescription) {
                @strongify(self)
                
                [BaseIndicatorView hideWithAnimation:self.didShow];
                [SpringAlertView showInWindow:self.view.window message:errorDescription];
            }];
        }
    } cancelButtonTitle:@"取消" otherButtonTitles:rechargeMessage, nil];
}


- (void)buyRegular {

    [AlertViewManager showInViewController:self title:@"提示" message:[NSString stringWithFormat:@"你确定出借%@元？", self.moneyShare.text] clickedButtonAtIndex:^(id alertView, NSInteger buttonIndex) {
        if (1 == buttonIndex) {
            NSMutableDictionary *params = [[UserinfoManager sharedUserinfo] increaseUserParams:nil];
            [params setValue:self.productInfo.productID forKey:PRODUCT_DETAIL_ID_KEY];
            [params setValue:self.moneyShare.text forKey:KEY_BUY_SHARE];
            [params setValue:self.bonusInfo[@"id"] ? : @0 forKey:KEY_GIFT];
            
            [BaseIndicatorView showInView:self.view.window maskType:kIndicatorMaskAll];
            @weakify(self)
            self.task = [[UserinfoManager sharedUserinfo] startRequest:kUserinfoOperationBuyProduct params:params success:^(id result) {
                @strongify(self)
                
                [BaseIndicatorView hideWithAnimation:self.didShow];
                [self didBuySuccessWithResult:result];
            } failure:^(id result, NSString *errorDescription) {
                @strongify(self)
                
                [BaseIndicatorView hideWithAnimation:self.didShow];
                [SpringAlertView showInWindow:self.view.window message:errorDescription];
            }];
        }
    } cancelButtonTitle:NSLocalizedString(@"cancel", nil) otherButtonTitles:NSLocalizedString(@"confirm", nil), nil];
}
- (void)didBuySuccessWithResult:(id)result {
    
    BuySuccessPromptVC *vc = [AiMiApplication obtainControllerForMainStoryboardWithID:PROMPT_STORYBOARD_ID];
    vc.buyProductInfo = [self createBuyProductInfoWithResult:[result[RESULT_DATA] firstObject]];
    [self.navigationController pushViewController:vc animated:YES];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:kRecommendShouldChangeNotification object:nil];
    [[NSNotificationCenter defaultCenter] postNotificationName:kProductDidBuyNotification object:@{BUY_PRODUCTID_KEY:self.productInfo.productID, BUY_MONEY_KEY:self.moneyShare.text}];
    
    self.surplusMoney.text = [NSString stringWithFormat:@"%li", (long)(self.surplusMoney.text.integerValue - self.moneyShare.text.integerValue)];
    self.moneyShare.text = nil;
    self.bonusInfo = nil;
    [self textFieldShouldEndEditing:self.moneyShare];
    [[NSNotificationCenter defaultCenter] postNotificationName:UITextFieldTextDidChangeNotification object:self.moneyShare];
}
- (NSDictionary *)createBuyProductInfoWithResult:(NSDictionary *)resultData {
    NSMutableDictionary *result = [NSMutableDictionary dictionaryWithObjectsAndKeys:self.moneyShare.text, Indent_Money, self.customTitle.text, Product_Name, self.bonusInfo ? self.bonusInfo[@"name"] : @"无", Platform_Reward, nil];

    [result addEntriesFromDictionary:resultData];
    return result;
}

#pragma mark - setter
- (void)setMoneyShare:(UITextField *)moneyShare {
    _moneyShare = moneyShare;
    
    UIView *paddingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 20)];
    
    moneyShare.leftView = paddingView;
    moneyShare.leftViewMode = UITextFieldViewModeAlways;
}
- (void)setCanIntoProductDetail:(BOOL)canIntoProductDetail {
    _canIntoProductDetail = canIntoProductDetail;
    
    if (canIntoProductDetail) {
        [self layoutNavigationRightButtonWithTitle:@"详情" color:nil block:^(BuyFinanicalItemVC *viewController) {
            
            ProductDetailVC *vc = [AiMiApplication obtainControllerForMainStoryboardWithID:PRODUCT_DETAIL_STORYBOARD_ID];
            
            vc.needShowPastProject = YES;
            vc.productInfo = viewController.productInfo;
            [viewController.navigationController pushViewController:vc animated:YES];
        }];
    }
}
- (void)setBonusInfo:(NSDictionary *)bonusInfo {
    _bonusInfo = bonusInfo;
    
    if (bonusInfo) {
        
        self.bonusMoney.text = [NSString stringWithFormat:@"+%@", [CommonTools convertToStringWithObject:bonusInfo[@"amount"]]];
        [self.selectBonus setTitle:bonusInfo[@"name"] forState:UIControlStateNormal];
    } else {
        self.bonusMoney.text = @"";
        [self.selectBonus setTitle:@"未选择红包" forState:UIControlStateNormal];
    }
    
    self.crossButton.crossState = self.bonusInfo ? YES : NO;
}
- (void)setContentView:(KeyboardScrollView *)contentView {
    _contentView = contentView;
    
    @weakify(self)
    contentView.header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        @strongify(self)
        [self fetchProductdetail];
    }];
}
- (void)setCustomTitle:(UILabel *)customTitle {
    _customTitle = customTitle;
    
    customTitle.font = [UINavigationBar appearance].titleTextAttributes[NSFontAttributeName];
    customTitle.textColor = [UINavigationBar appearance].titleTextAttributes[NSForegroundColorAttributeName];
}
- (WarmmingView *)warmmingView{
    if (!_warmmingView) {
        _warmmingView = [[WarmmingView alloc]init];
    }
    return _warmmingView;
}


@end
