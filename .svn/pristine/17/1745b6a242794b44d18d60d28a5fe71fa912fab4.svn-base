//
//  TradePasswordVC.m
//  YuanXin_Project
//
//  Created by Yuanin on 15/10/10.
//  Copyright © 2015年 yuanxin. All rights reserved.
//

#import "TradePasswordVC.h"

#import "AuthenticationVC.h"
#import "SinaWebVC.h"
#import "BindBankCardVC.h"


@implementation TradePasswordVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self layoutNavigationLeftButtonWithImage:[UIImage imageNamed:Nav_Back_Image] block:^(TradePasswordVC *viewController) {
        
        [viewController.navigationController popViewControllerAnimated:YES];
    }];
}

#pragma mark - action
- (IBAction)settingPaypasswordAndAuthorization:(UIButton *)sender {
    
//    [self presentViewController:[SinaWebVC sinaWebWithServerPath:@"set_sina_withhold_authority" params:nil success:^{
//        
//        [self  pushToNextItem];
//    }] animated:YES completion:nil];
    
    [(AuthenticationVC *)self.parentViewController changeRootViewControllerToViewControoler:[SinaWebVC sinaWebVCWithServerPath:@"set_sina_withhold_authority" params:nil success:^{
//        [self  pushToNextItem];
    }]];
    
}

- (void)pushToNextItem {
    
    if ([self.parentViewController isKindOfClass:[AuthenticationVC class]]) {
        [(AuthenticationVC *)self.parentViewController changeRootViewControllerToViewControoler:[AiMiApplication obtainControllerForStoryboard:@"Auth" controller:BIND_BANK_CARD_STORYBOARD_ID]];
    } else {
        [self.navigationController popViewControllerAnimated:YES];
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
