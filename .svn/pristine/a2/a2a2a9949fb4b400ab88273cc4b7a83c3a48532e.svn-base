//
//  GesturePasswordVC.m
//  YuanXin_Project
//
//  Created by Yuanin on 15/10/22.
//  Copyright © 2015年 yuanxin. All rights reserved.
//

#import "GesturePasswordVC.h"

#import "AppDelegate.h"
#import "LoginNavigationController.h"

#import "GesturePassword.h"
#import "SudokuView.h"
#import "TCKeychain.h"
#import <LocalAuthentication/LocalAuthentication.h>
#import <AudioToolbox/AudioToolbox.h>

#define ALTER_GESTURE_PASSWORD  @"修改手势密码"
#define AUTH_GESTURE_PASSWORD   @"验证手势密码"
#define SETUP_GESTURE_PASSWORD  @"设置手势密码"

#define BE_CAREFUL              @"绘制密码时，谨防他人偷看"
#define DRAW_AGAIN              @"重新绘制"

#define OLD_INPUT               @"请绘制原手势密码"
#define INPUT                   @"请绘制新手势密码"
#define INPUT_AGAIN             @"请再次绘制手势密码"

#define ERROR_NOT_ENOUGH        @"请至少连接四个点"
#define ERROE_NOT_SAME          @"两次绘制不一致，请重新绘制"
#define ERROR_INPUT             @"密码错误"

#define SUCCESS                 @"验证成功"
#define MORE_ERROR_INFO         @"您还可以输入%@次"

#define Max_Count_Of_Error      5
#define Gesture_Min_Length      4


@interface GesturePasswordVC ()

@property (copy, nonatomic) void(^callBack)(GesturePasswordVC *, GesturePasswordOperationType);
@property (assign, nonatomic) NSInteger maxErrorCount;
@property (assign, nonatomic) BOOL      isCancel;
@property (strong, nonatomic) NSString  *password;
@property (weak, nonatomic) IBOutlet UILabel *dayLB;
@property (weak, nonatomic) IBOutlet UILabel *monthLB;
@property (weak, nonatomic) IBOutlet UILabel *weekLB;

//@property (weak, nonatomic) IBOutlet SudokuView      *sudoku;
@property (weak, nonatomic) IBOutlet GesturePassword *gesturePassword;
@property (weak, nonatomic) IBOutlet UILabel         *gestureInfo;
@property (weak, nonatomic) IBOutlet UIButton        *drawAgainButton;

//@property (weak, nonatomic) IBOutlet UILabel         *phone;
//@property (weak, nonatomic) IBOutlet UIImageView     *gestureIcon;

@property (weak, nonatomic) IBOutlet UIButton        *forgetPassword;
@property (weak, nonatomic) IBOutlet UIButton        *userTouchID;

@property (weak, nonatomic) IBOutlet UILabel         *customTitle;
@end

@implementation GesturePasswordVC

#pragma mark - life cycle
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self initUI];
    self.navigationBarAlpha = 0;
    self.isCancel      = YES;
    self.type          = _type;
    self.maxErrorCount = Max_Count_Of_Error;
    
    [self layoutNavigationLeftButtonWithImage:[UIImage imageNamed:@""] block:^(GesturePasswordVC *viewController) {
        
        [viewController.navigationController popViewControllerAnimated:YES];
    }];
}
- (void)initUI{
    // 获取当前时间
    NSDate *  senddate=[NSDate date];
    NSDateFormatter  *dateformatter=[[NSDateFormatter alloc] init];
    [dateformatter setDateFormat:@"yyy"];
    //    NSString *  yearString = [dateformatter stringFromDate:senddate];
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
//    self.gestureVCBtn.hidden = ![AiMiApplication haveGesturePassword];
//    
//    if (self.gestureVCBtn.hidden) {
//        self.fengeView.hidden = YES;
//        self.changeAccountRight.constant = -30;
//    }
//    
    
}


- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    
    if (self.isformTouchID) {
        
    }else{
       if (self.isCancel && self.callBack) {
        @weakify(self)
        self.callBack(self_weak_, kGesturePasseordOperationCancel);
       }
    }
    
}


#pragma mark - publick
- (void)setCompletionBlock:( void(^)(GesturePasswordVC *, GesturePasswordOperationType type))callBack
{
    self.callBack = callBack;
}

#pragma mark - action
- (IBAction)drawAgain:(UIButton *)sender
{
    sender.userInteractionEnabled = NO;
//    [sender setTitle:BE_CAREFUL forState:UIControlStateNormal];
    self.drawAgainButton.hidden = YES;
    self.fengeView.hidden = YES;
    self.quxiaoLeft.constant = -30;
    
    self.password                = @"";
    self.gestureInfo.text        = INPUT;
//    self.sudoku.hightLightPoints = @[];
}
- (IBAction)logout:(UIButton *)sender
{
    [[UserinfoManager sharedUserinfo] logout];

    @weakify(self)
    if (self.callBack) self.callBack(self_weak_, kGesturePasswordOperationFailure);
    
    self.isCancel      = NO;
    [self.navigationController popToRootViewControllerAnimated:YES];
}
- (IBAction)cancleBtnClicked:(UIButton *)sender {
            [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - private method

- (void)gestureDidFailure
{
    NSString *errInfo = nil;
    if (kGesturePasswordSetting != self.type) {
        
        self.maxErrorCount--;

        NSString *moreInfo = [NSString stringWithFormat:MORE_ERROR_INFO, @(self.maxErrorCount)];
        errInfo = [NSString stringWithFormat:@"%@,%@",ERROR_NOT_ENOUGH, moreInfo];
    } else {
        errInfo = ERROR_NOT_ENOUGH;
    }
    
    [self setErrorSpring:errInfo];
}
- (void)gestureDidSuccess:(NSString *)password
{
    if (kGesturePasswordSetting == self.type) {
        if (self.password.length) {

//            self.drawAgainButton.userInteractionEnabled = YES;
            if ([password isEqualToString:self.password]) { //设置手势成功
                
                self.gestureInfo.text = SUCCESS;
                NSMutableDictionary *userNamePassPairs = [TCKeychain load:KEY_USER_INFO];
                [userNamePassPairs setValue:self.password forKey:KEY_USER_GESTUREPASSWORD];
                [TCKeychain save:KEY_USER_INFO data:userNamePassPairs];
                
                @weakify(self)
                if (self.callBack) self.callBack(self_weak_, kGesturePasswordOperationSuccess);
                
                self.isCancel = NO;
                if (![self.navigationController isKindOfClass:[LoginNavigationController class]]) {
                    [self.navigationController popViewControllerAnimated:YES];
                }
            } else {
                [self setErrorSpring:ERROE_NOT_SAME];
            }
        } else {
            
            NSMutableArray *hightPoints = [[NSMutableArray alloc] init];
            for (NSString *part in [password componentsSeparatedByString:@"-"]) {
                [hightPoints addObject:@([self.gesturePassword.values indexOfObject:part])];
            }
            [self.drawAgainButton setTitle:DRAW_AGAIN forState:UIControlStateNormal];
            self.drawAgainButton.userInteractionEnabled = YES;
            self.drawAgainButton.hidden = NO;
            self.fengeView.hidden = NO;
            self.quxiaoLeft.constant = 20;
            self.gestureInfo.text                       = INPUT_AGAIN;
            self.password                               = password;
//            self.sudoku.hightLightPoints                = hightPoints;
        }
    } else {
        
        NSDictionary *userinfo    = [TCKeychain load:KEY_USER_INFO];
        NSString *gesturePassword = userinfo[KEY_USER_GESTUREPASSWORD];

        if ([gesturePassword isEqualToString:password]) {//验证手势成功
            
            [self authGestureSuccess];
        } else {
            self.maxErrorCount--;
            NSString *moreInfo = [NSString stringWithFormat:MORE_ERROR_INFO, @(self.maxErrorCount)];
            NSString *errInfo  = [NSString stringWithFormat:@"%@, %@", ERROR_INPUT, moreInfo];
            [self setErrorSpring:errInfo];
        }
    }
}
- (void)authGestureSuccess
{
    if (kGesturePasswordAlter == self.type) {
        self.gestureInfo.text = INPUT;
        self.type             = kGesturePasswordSetting;
    } else {
        self.gestureInfo.text = SUCCESS;
        self.isCancel = NO;
        
        @weakify(self)
        if (self.callBack) self.callBack(self_weak_, kGesturePasswordOperationSuccess);
        if (self.navigationController) [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)setErrorSpring:(NSString *)errInfo
{
    self.gestureInfo.text = errInfo;
    
    CGPoint position = self.gestureInfo.layer.position;
    CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    animation.values = @[
                         [NSValue valueWithCGPoint:position],
                         [NSValue valueWithCGPoint:CGPointMake(position.x + 2*MARGIN_DISTANCE, position.y)],
                         [NSValue valueWithCGPoint:CGPointMake(position.x - 2*MARGIN_DISTANCE, position.y)],
                         [NSValue valueWithCGPoint:CGPointMake(position.x + BIG_MARGIN_DISTANCE, position.y)],
                         [NSValue valueWithCGPoint:CGPointMake(position.x - BIG_MARGIN_DISTANCE, position.y)],
                         [NSValue valueWithCGPoint:position]
                         ];
    
    animation.duration            = 1.0f;
    animation.timingFunction      = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    animation.removedOnCompletion = NO;
    animation.fillMode            = kCAFillModeForwards;
    
    [self.gestureInfo.layer addAnimation:animation forKey:@"errAnimation"];
    
    AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
}

- (IBAction)authTouchId
{
//    NSUserDefaults *userDefaults = USERDEFAULTS;
//    LAContext *context = [[LAContext alloc] init];
//    if ([userDefaults boolForKey:DID_OPEN_TOUCHID] & [context canEvaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics error:nil]) {
//        
//        [context evaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics localizedReason:@"需要验证您的指纹来确认您的身份信息" reply:^(BOOL success, NSError * _Nullable error) {
//            if (success) {
//
//                dispatch_async(dispatch_get_main_queue(), ^{
//                    [self authGestureSuccess];
//                });
//            }
//        }];
//    }
    if (self.touchID) {
        self.touchID();
    }
 
}

#pragma mark - setter & getter
- (void)setGesturePassword:(GesturePassword *)gesturePassword {
    _gesturePassword = gesturePassword;
    
    gesturePassword.separatedString   = @"-";
    gesturePassword.minPasswordLength = Gesture_Min_Length;
    
    @weakify(self)
    [gesturePassword setCompletionBlock:^( NSString *password, GestureCompletionType type) {
        @strongify(self)
        
        [self.gesturePassword clear];
        
        if (kGestureCompletionSuccess == type) {
            [self gestureDidSuccess:password];
        } else if (kGestureCompletionNotEnough == type) {
            [self gestureDidFailure];
        }
    }];
}

- (void)setType:(GesturePasswordVCType)type {
    _type = type;
    
//    if (!self.phone) return;
    
    //default
//    self.phone.text             = @"";
//    self.sudoku.hidden          = kGesturePasswordSetting != self.type ? : NO;
//    self.gestureIcon.hidden     = kGesturePasswordSetting == self.type ? : NO;
//    self.cancleBtn.hidden = kGesturePasswordAuth == self.type;
//    self.drawAgainButton.hidden = kGesturePasswordSetting != self.type;
    self.drawAgainButton.hidden = YES;
    if (type == kGesturePasswordSetting ||self.type == kGesturePasswordAlter) {
        self.fengeView.hidden = YES;
        self.quxiaoLeft.constant = -30;
    }else{
        self.fengeView.hidden = NO;
        self.quxiaoLeft.constant = 20;
    
    }
    self.cancleBtn.hidden = kGesturePasswordAuth == self.type;
    self.forgetPassword.hidden  = kGesturePasswordSetting  == self.type ||kGesturePasswordAlter == self.type  ;
    self.userTouchID.hidden     = kGesturePasswordSetting == self.type||kGesturePasswordAlter == self.type ||kGesturePasswordAuth2 == self.type||
                                  ![USERDEFAULTS boolForKey:DID_OPEN_TOUCHID] ||
                                  ![[[LAContext alloc] init] canEvaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics error:nil];
    
    if (kGesturePasswordAlter == self.type) { //修改手势密码
        
//        self.title            = ALTER_GESTURE_PASSWORD;
        self.gestureInfo.text = OLD_INPUT;
    } else if (kGesturePasswordAuth == self.type) { //验证手势密码
        if (self.userTouchID.hidden) {
            self.fengeView.hidden = YES;
            self.forgetBtnRight.constant = -45;
        }
//        self.title      = AUTH_GESTURE_PASSWORD;
//        self.phone.text = [[[UserinfoManager sharedUserinfo] lastAccount] hidePosition:kHideStringCenter length:[[UserinfoManager sharedUserinfo] lastAccount].length/2];
    }else if (kGesturePasswordAuth2 == self.type) { //验证手势密码
        
//        self.title      = AUTH_GESTURE_PASSWORD;
//        self.phone.text = [[[UserinfoManager sharedUserinfo] lastAccount] hidePosition:kHideStringCenter length:[[UserinfoManager sharedUserinfo] lastAccount].length/2];
    }else {
        
//        self.title = SETUP_GESTURE_PASSWORD;
    }
}
- (void)setMaxErrorCount:(NSInteger)maxErrorCount {
    
    _maxErrorCount = maxErrorCount;
    
    if (maxErrorCount <= 0) {
        [self logout:nil];
    }
}
- (void)setTitle:(NSString *)title {
    
    self.customTitle.text = title;
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    
    return UIStatusBarStyleLightContent;
}
@end
