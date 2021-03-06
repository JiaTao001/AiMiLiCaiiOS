//
//  BindBankCardVC.m
//  YuanXin_Project
//
//  Created by Yuanin on 15/10/9.
//  Copyright © 2015年 yuanxin. All rights reserved.
//

#import "BindBankCardVC.h"
#import "AuthenticationVC.h"
#import "SinaWebVC.h"

@interface BindBankCardVC ()

@property (weak, nonatomic) IBOutlet UILabel *prompt;
@end


@implementation BindBankCardVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self layoutNavigationLeftButtonWithImage:[UIImage imageNamed:Nav_Back_Image] block:^(BindBankCardVC *viewController) {
        
        [viewController.navigationController popViewControllerAnimated:YES];
    }];
//    [self layoutNavigationRightButtonWithImage:[UIImage imageNamed:@"bind_bank_instruction"] block:^(BindBankCardVC *viewController) {
//        WebVC *vc = [WebVC webVCWithWebPath:[CommonTools completeWebPathWithSubpath:Introduct_Bind_Bank]];
//        
//        vc.title = Bind_Bnak_Instruction;
//        [viewController.navigationController pushViewController:vc animated:YES];
//    }];
}


#pragma mark - action
- (IBAction)bindBankCard:(UIButton *)sender {
    
//    [self presentViewController:[SinaWebVC sinaWebWithServerPath:@"sina_recharge" params:@{@"amount": [UserinfoManager sharedUserinfo].userInfo.minRechargeMoney} success:^{
//        [self.navigationController popViewControllerAnimated:YES];
//    }] animated:YES completion:nil];
    [(AuthenticationVC *)self.parentViewController changeRootViewControllerToViewControoler:[SinaWebVC sinaWebVCWithServerPath:@"sina_recharge" params:@{@"amount": [UserinfoManager sharedUserinfo].userInfo.minRechargeMoney} success:^{
//                [self  pushToNextItem];
        [self.navigationController popViewControllerAnimated:YES];
//        [self dismissViewControllerAnimated:YES completion:nil];
    }]];
}

- (void)setPrompt:(UILabel *)prompt {
    _prompt = prompt;
    
    prompt.text = [NSString stringWithFormat:@"首次绑卡将会通过您的银行账户向您在爱米金服的新浪支付账户进行%@元充值，用于验证账户的真实性。", [UserinfoManager sharedUserinfo].userInfo.minRechargeMoney];
}
@end
