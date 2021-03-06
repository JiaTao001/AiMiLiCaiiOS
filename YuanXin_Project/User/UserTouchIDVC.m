//
//  UserTouchIDVC.m
//  YuanXin_Project
//
//  Created by Yuanin on 2017/5/9.
//  Copyright © 2017年 yuanxin. All rights reserved.
//

#import "UserTouchIDVC.h"
#import "UserinfoManager.h"
#import <LocalAuthentication/LocalAuthentication.h>
#import "AiMiApplication.h"
@interface UserTouchIDVC ()
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *changeAccountRight;
@property (weak, nonatomic) IBOutlet UIView *fengeView;

@end

@implementation UserTouchIDVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initUI];
    
  
    
    // Do any additional setup after loading the view.
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self authTouchID:nil];
//    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
//    LAContext *context = [[LAContext alloc] init];
//    if ([userDefaults boolForKey:@"open_touch_id"] & [context canEvaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics error:nil]) {
//        
//        [context evaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics localizedReason:@"需要验证您的指纹来确认您的身份信息" reply:^(BOOL success, NSError * _Nullable error) {
//            if (success) {
//                
//                dispatch_async(dispatch_get_main_queue(), ^{
//                    //                    [self authGestureSuccess];
//                    if (self.callBack) {
//                        self.callBack(0);
//                    }
//                });
//            }
//        }];
//    }
}
- (void)initUI{
    // 获取当前时间
    NSDate *  senddate=[NSDate date];
    NSDateFormatter  *dateformatter=[[NSDateFormatter alloc] init];
    [dateformatter setDateFormat:@"yyyMMdd"];
    NSString *  yearString = [dateformatter stringFromDate:senddate];
    [dateformatter setDateFormat:@"MM"];
    NSString *  monthString = [dateformatter stringFromDate:senddate];
    [dateformatter setDateFormat:@"dd"];
    NSString *  dayString = [dateformatter stringFromDate:senddate];
    [dateformatter setDateFormat:@"EEE"];
    
    NSString *  weekString = [dateformatter stringFromDate:senddate];
    self.weekLB.text = weekString;
    //    int year = [yearString intValue];
    
    int month = [monthString intValue];
    switch (month) {
        case 1:
            self.monthLB.text = @"一月";
            break;
        case 2:
            self.monthLB.text = @"二月";
            break;
            
        case 3:
            self.monthLB.text = @"三月";
            break;
            
        case 4:
            self.monthLB.text = @"四月";
            break;
        case 5:
            self.monthLB.text = @"五月";
            break;
        case 6:
            self.monthLB.text = @"六月";
            break;
        case 7:
            self.monthLB.text = @"七月";
            break;
        case 8:
            self.monthLB.text = @"八月";
            break;
        case 9:
            self.monthLB.text = @"九月";
            break;
        case 10:
            self.monthLB.text = @"十月";
            break;
        case 11:
            self.monthLB.text = @"十一月";
            break;
        case 12:
            self.monthLB.text = @"十二月";
            break;
            
            
        default:
            break;
    }
    
    //    self.monthLB.text = monthString;
    //    int day = [dayString intValue];
    self.dayLB.text = dayString;
    self.gestureVCBtn.hidden = ![AiMiApplication haveGesturePassword];
    NSArray *conList = [[NSUserDefaults standardUserDefaults] objectForKey:@"conList"];
    
    for (NSDictionary *dict  in conList) {
        if ([dict[@"time"]  isEqualToString:yearString]) {
            self.biaoqianLB.text = dict[@"con"];
        }
    }
    if (self.gestureVCBtn.hidden) {
        self.fengeView.hidden = YES;
        self.changeAccountRight.constant = -30;
    }
    

}
- (IBAction)authTouchID:(UIButton *)sender {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    LAContext *context = [[LAContext alloc] init];
    if ([userDefaults boolForKey:@"open_touch_id"] & [context canEvaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics error:nil]) {
        
        [context evaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics localizedReason:@"需要验证您的指纹来确认您的身份信息" reply:^(BOOL success, NSError * _Nullable error) {
            if (success) {
                
                dispatch_async(dispatch_get_main_queue(), ^{
//                    [self authGestureSuccess];
                    if (self.callBack) {
                        self.callBack(0);
                    }
                });
            }
        }];
    }
}
- (IBAction)changeAccount:(id)sender {
    [[UserinfoManager sharedUserinfo] logout];
    
//    @weakify(self)
//    if (self.callBack) self.callBack(self_weak_, kGesturePasswordOperationFailure);
//    
//    self.isCancel      = NO;
//    [self.navigationController popToRootViewControllerAnimated:YES];
    if (self.callBack) {
        self.callBack(1);
    }
}
- (IBAction)gestureVC:(id)sender {
    if (self.callBack) {
        self.callBack(2);
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
