//
//  SettingTVC.m
//  YuanXin_Project
//
//  Created by Yuanin on 15/10/10.
//  Copyright © 2015年 yuanxin. All rights reserved.
//

#import "SettingVC.h"

#import "AlterPhoneVC.h"
#import "AlterPasswordVC.h"
#import "CheckRealNameVC.h"
#import "SinaWebVC.h"
#import "AuthenticationVC.h"
#import "GesturePasswordVC.h"
#import "CheckBankCardVC.h"

#import <LocalAuthentication/LocalAuthentication.h>

#import "SettingHeaderView.h"
#import "SettingNormalCell.h"
#import "SettingSwitchCell.h"
#import "WarmmingView.h"
#define SETTING @"未认证"
#define ALTER   @"修改"
#define CHECK   @"已认证"

#define Person_Info @"个人信息"
#define Sina_Info @"密码管理"

#define Image_Name @"imageName"
#define Title      @"title"
#define Cell_Type  @"cellType"
#define Need_Authentication @"needAuthentication"
#import "KaiHuViewController.h"

#import "HKWebVC.h"
@interface SettingVC () <UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) NSDictionary *cellInfo;
@property (copy, nonatomic, readwrite) void(^callBack)();

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong,nonatomic)WarmmingView *warmmingView;
@property(strong, nonatomic) NSURLSessionTask *task;
@end

@implementation SettingVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self layoutNavigationLeftButtonWithImage:[UIImage imageNamed:Nav_Back_Image] block:^(UIViewController *viewController) {
        [viewController.navigationController popViewControllerAnimated:YES];
    }];
    
    @weakify(self)
    [RACObserve([UserinfoManager sharedUserinfo].userInfo, certifierstate) subscribeNext:^(id x) {
        @strongify(self)
        [self.tableView reloadData];
    }];
    [RACObserve([UserinfoManager sharedUserinfo].userInfo, mobile) subscribeNext:^(id x) {
        @strongify(self)
        [self.tableView reloadData];
    }];
//    [self showWarmView];
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
}
- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    
    [self.task cancel];
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
            
          
            
//            [BaseIndicatorView showInView:self.view];
//            @weakify(self)
//            self.task = [[UserinfoManager sharedUserinfo] startRequest:kUserinfoOperationJiHuo params:nil success:^(id result) {
//                @strongify(self)
//                [BaseIndicatorView hideWithAnimation:self.didShow];
//                
//                [SpringAlertView showInWindow:self.view.window message:result[RESULT_REMARK]];
//                [self pushToNextItemWithUrl:[result[@"data"] firstObject][@"redirect_url"]];
//            } failure:^( id result, NSString *errorDescription) {
//                @strongify(self)
//                
//                [BaseIndicatorView hideWithAnimation:self.didShow];
//                [SpringAlertView showInWindow:self.view.window message:errorDescription];
//            }];
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

#pragma mark - dataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return [self.cellInfo[[self customKeyWithSection:section]] count] - [self notCellNumberWithSection:section];
}
- (NSString *)customKeyWithSection:(NSInteger)section {
    
    return 0 == section ? Person_Info : Sina_Info;
}
- (NSInteger)notCellNumberWithSection:(NSInteger)section {
    NSInteger result = 0;
    if (1 == section) {
//      LAContext *context = [[LAContext alloc] init];
//      if ([context canEvaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics error:nil]) {
//                        result = 0;
//      }else{
//          result = 1;
//      }
//        
        if ([USERDEFAULTS boolForKey:DID_OPEN_GESTURE]) {
            

        } else {
            result += 1;//无修改手势密码选项
        }
    }
    return result;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    SettingHeaderView *headerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:NSStringFromClass([SettingHeaderView class])];
    
    headerView.sectionTitle.text = [self customKeyWithSection:section];
    return headerView;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *result = nil;
    
    if ([@1 isEqualToNumber:self.cellInfo[[self customKeyWithSection:indexPath.section]][indexPath.row][Cell_Type]]) {
        
        SettingNormalCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([SettingNormalCell class])];
        cell.customImageView.image = [UIImage imageNamed:self.cellInfo[[self customKeyWithSection:indexPath.section]][indexPath.row][Image_Name]];
        cell.customTitle.text = self.cellInfo[[self customKeyWithSection:indexPath.section]][indexPath.row][Title];
        cell.customDescription.text = [self cellIntroductionWithIndexPath:indexPath];
        
        result = cell;
    } else {
        SettingSwitchCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([SettingSwitchCell class])];
        
        cell.customImageView.image = [UIImage imageNamed:self.cellInfo[[self customKeyWithSection:indexPath.section]][indexPath.row][Image_Name]];
        cell.customTitle.text = self.cellInfo[[self customKeyWithSection:indexPath.section]][indexPath.row][Title];
        cell.customSwitch.on = [USERDEFAULTS boolForKey:3 == indexPath.row ? DID_OPEN_GESTURE : DID_OPEN_TOUCHID];
        
        @weakify(self)
        cell.switchChange  = ^(UISwitch *sender) {
            @strongify(self)
            
            if (3 == indexPath.row) {
                [self intoGestureVCWithSender:sender];
            } else if(2 == indexPath.row) {
                [self intotouchVCWith:sender];

            }
        };
        
        result = cell;
    }
    
    if ([tableView numberOfRowsInSection:indexPath.section] - 1 == indexPath.row) {
        result.separatorInset = UIEdgeInsetsZero;
    } else {
        result.separatorInset = UIEdgeInsetsMake(0, CUSTOM_LINE_MRGIN, 0, 0);
    }
    
    return result;
}
- (NSString *)cellIntroductionWithIndexPath:(NSIndexPath *)indexPath {
    
    NSString *result = @"";
    if (0 == indexPath.section) {
        switch (indexPath.row) {
            case 0:
                result = [[UserinfoManager sharedUserinfo].userInfo.mobile hidePosition:kHideStringCenter length:4];
                break;
            case 1:
                
                result = [[UserinfoManager sharedUserinfo].userInfo.is_activate_hkaccount integerValue] == 1 ? CHECK : SETTING;
                break;

                break;
        }
    }
    
    return result;
}
- (void)intotouchVCWith:(UISwitch *)sender{
    
    LAContext *context = [[LAContext alloc] init];
    if ( [context canEvaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics error:nil]) {
        
        [context evaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics localizedReason:@"需要验证您的指纹来确认您的身份信息" reply:^(BOOL success, NSError * _Nullable error) {
            if (success) {
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    [USERDEFAULTS setBool:sender.isOn forKey:DID_OPEN_TOUCHID];
                    [USERDEFAULTS synchronize];
                     [self.tableView reloadData];
                   
                });
            }else{
                
                dispatch_async(dispatch_get_main_queue(), ^{
                     [sender setOn:!sender.isOn animated:YES];
              
                });
               
               
            }
            
            
        }];
    }else{
        dispatch_async(dispatch_get_main_queue(), ^{
            [sender setOn:!sender.isOn animated:YES];
            
        });
        [AlertViewManager showInViewController:self title:@"提示" message:@"请先在通用设置里打开指纹密码" clickedButtonAtIndex:^(id alertView, NSInteger buttonIndex) {
//            if (buttonIndex == 1) {
////                NSURL *url = [NSURL URLWithString:@"prefs:root=FACETIME"];
////                if ([[UIApplication sharedApplication] canOpenURL:url])
////                {
////                    [[UIApplication sharedApplication] openURL:url];
////                }
//                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
////
//            }
                } cancelButtonTitle:NSLocalizedString(@"cancel", nil) otherButtonTitles: nil];

        
        
    }
    

}
- (void)intoGestureVCWithSender:(UISwitch *)sender {
    
    GesturePasswordVC *vc = [AiMiApplication obtainControllerForMainStoryboardWithID:GESTURE_PASSWORD_STORYBOARD_ID];
    
    if (!sender) {
        
        vc.type = kGesturePasswordAlter;
    } else {
        
        vc.type = sender.isOn ? kGesturePasswordSetting : kGesturePasswordAuth2;
        [vc setCompletionBlock:^(GesturePasswordVC *vc, GesturePasswordOperationType type) {
            
            if (kGesturePasswordOperationSuccess == type) {
                [USERDEFAULTS setBool:sender.isOn forKey:DID_OPEN_GESTURE];
                [USERDEFAULTS synchronize];
                
                [self.tableView reloadData];
                if (!sender.isOn) {//关闭手势密码的同时也关闭touch ID
//                    [USERDEFAULTS setBool:NO forKey:DID_OPEN_TOUCHID];
                }
            } else {
                [sender setOn:!sender.isOn animated:YES];
            }
        }];
    }
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if ([self.cellInfo[[self customKeyWithSection:indexPath.section]][indexPath.row][Need_Authentication] boolValue] && [[UserinfoManager sharedUserinfo].userInfo.is_activate_hkaccount integerValue] != 1) {
//        是否激活海口账户，1：已激活；0：普通用户待开户；2：导入用户待激活
//        if ([[UserinfoManager sharedUserinfo].userInfo.is_activate_hkaccount integerValue] == 0) {
//            //kaihu
//         [self.navigationController pushViewController:[AiMiApplication obtainControllerForStoryboard:@"Auth" controller:NSStringFromClass([KaiHuViewController class])] animated:YES ];
//        }else{
//            //jihuo
//            [self goToJiHuo];
//            
//            
//        }
        [self showWarmView];
       
        return;
    }
    
//    dispatch_async(dispatch_get_main_queue(), ^{
        if (0 == indexPath.section) {
            
            switch (indexPath.row) {
                case 0:
                    [self performSegueWithIdentifier:To_AlterPhoneVC_Segue_Identifier sender:nil];
                    break;
                case 1:
                    [self performSegueWithIdentifier:To_Real_Name_Segue_Identifier sender:nil];
                    break;
                case 2:
                    [self performSegueWithIdentifier:To_Check_BankCard_Segue_Identifier sender:nil];

                    break;
            }
        } else {
            
            switch (indexPath.row) {
                case 0:
                    [self performSegueWithIdentifier:To_AlterPasswordVC_Segure_Identifier sender:nil];


                    break;
                case 1:{
//                    [self presentViewController:[SinaWebVC sinaWebWithServerPath:@"set_sina_withhold_authority" params:nil] animated:YES completion:nil];
                    [BaseIndicatorView showInView:self.view maskType:kIndicatorNoMask];
                    @weakify(self)
                    self.task = [NetworkContectManager sessionPOSTWithMothed:@"changehaikoupassword" params:[[UserinfoManager sharedUserinfo] increaseUserParams:nil] success:^(NSURLSessionTask *task, id result) {
                        @strongify(self)
                        
                        [BaseIndicatorView hideWithAnimation:self.didShow];
                        [self pushToNextItemWithUrl:[result[@"data"] firstObject][@"redirect_url"]];

                    } failure:^(NSURLSessionTask *task, id result, NSString *errorDescription) {
                        @strongify(self)
                        
                        [BaseIndicatorView hideWithAnimation:self.didShow];
                        [SpringAlertView showMessage:errorDescription];
                    }];
                }
                    break;
//                case 2:
//                    [self performSegueWithIdentifier:To_Check_BankCard_Segue_Identifier sender:nil];
//                    break;
//                case 2:
//                      [self performSegueWithIdentifier:To_AlterPasswordVC_Segure_Identifier sender:nil];
//                      break;
                case 4:
                     [self intoGestureVCWithSender:nil];
                      break;
            }
        }
//    });
}

#pragma mark - public method
- (void)setLogoutCallBack:( void(^)() ) callBack {
    
    self.callBack = callBack;
}

#pragma mark - private method

- (IBAction)logout:(id)sender {
    
    [AlertViewManager showInViewController:self title:@"" message:NSLocalizedString(@"logout_alert_info", nil) clickedButtonAtIndex:^(id alertView, NSInteger buttonIndex) {
        
        if (1 == buttonIndex) {
            [[UserinfoManager sharedUserinfo] logout];
            [self.navigationController popViewControllerAnimated:YES];
        }
    } cancelButtonTitle:NSLocalizedString(@"cancel", nil) otherButtonTitles:NSLocalizedString(@"confirm", nil), nil];
}

#pragma mark - setter & getter

- (void)setTableView:(UITableView *)tableView {
    _tableView = tableView;
    
    [tableView registerNib:[UINib nibWithNibName:NSStringFromClass([SettingHeaderView class]) bundle:nil] forHeaderFooterViewReuseIdentifier:NSStringFromClass([SettingHeaderView class])];
    tableView.tableFooterView = [UIView new]; //去掉底部多余的横线
    tableView.separatorInset = UIEdgeInsetsZero;
    if ([tableView respondsToSelector:@selector(layoutMargins)])
        tableView.layoutMargins = UIEdgeInsetsZero;
    
}

- (NSDictionary *)cellInfo {
    
    if (!_cellInfo) {
        _cellInfo = [NSDictionary dictionaryWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"person_setting_cell_info" ofType:@"plist"]];
//        LAContext *context = [[LAContext alloc] init];
//         if ([context canEvaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics error:nil]) {
//           
//         }else{
////            NSMutableArray *arr = [NSMutableArray arrayWithArray:_cellInfo[Sina_Info]];
////        
////            [arr removeObjectAtIndex:2];
////             NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:_cellInfo];
////             
////             [dict setValue:arr forKey:Sina_Info];
////           
////             _cellInfo = [NSDictionary dictionaryWithDictionary:dict];
//            
//        }
        
    }
    return _cellInfo;
}
- (WarmmingView *)warmmingView{
    if (!_warmmingView) {
        _warmmingView = [[WarmmingView alloc]init];
    }
    return _warmmingView;
}

@end
