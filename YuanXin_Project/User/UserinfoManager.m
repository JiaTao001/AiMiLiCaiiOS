//
//  UserinfoManager.m
//  YuanXin_Project
//
//  Created by Yuanin on 15/10/23.
//  Copyright © 2015年 yuanxin. All rights reserved.
//

#import "UserinfoManager.h"
#import "UMessage.h"
#import "GestureFinishedAnimation.h"

#import "RechargeVC.h"
#import "WithdrawVC.h"
#import "RuleWebVC.h"


/**
 *  //////////////////////userinfoManager
 *
 */
#define LAST_LOGIN_ACCOUNT @"last_accont"

@interface UserinfoManager()

@property (strong, nonatomic, readwrite) NSMutableArray         *observer;
@property (strong, nonatomic, readwrite) Userinfo               *userInfo;
@property (strong, nonatomic, readwrite) NSDecimalNumberHandler *roundingBehacior;
@property (strong, nonatomic, readwrite) NSNumberFormatter      *formatter;
@property (assign, nonatomic, readwrite) BOOL                   logined;
@end

@implementation UserinfoManager

#pragma mark - public method
+ (instancetype)sharedUserinfo {
    
    static UserinfoManager *info = nil;
    static dispatch_once_t once;
    
    dispatch_once(&once, ^{
        info = [[UserinfoManager alloc] init];
        info.userInfo = [[Userinfo alloc] init];
    
        NSDictionary *userinfo = [TCKeychain load:KEY_USER_INFO][KEY_USERINFO_DIC];
        [info.userInfo updateLoginInfo:userinfo];
        [info.userInfo updateUserinfo:userinfo];
        info.logined = info.userInfo.mobile.length && info.userInfo.userid.length;
    });
    
    return info;
}

- (void)logout {
    
    
    [USERDEFAULTS setBool:NO forKey:DID_OPEN_GESTURE];
    [USERDEFAULTS setBool:NO forKey:DID_OPEN_TOUCHID];
    
 
    [USERDEFAULTS synchronize];
    
    
    NSUserDefaults*shared = [[NSUserDefaults alloc]initWithSuiteName:@"group.com.yuanin.widge"];
    
    [shared setBool:NO forKey:IS_LOG];
   
    [shared setObject:nil forKey:@"amount"];
    
    [shared setObject:nil forKey:@"balance"];
  
    [shared setObject:nil forKey:@"interest"];
    
    [shared synchronize];
  
    [self.userInfo clear];
    [GestureFinishedAnimation removeCacheGestureImage];
    [UMessage removeAlias:[UserinfoManager sharedUserinfo].userInfo.userid type:UM_Alias_Type response:nil];
    self.logined = NO;
    if (SYSTEM_VERSION_GREATER_THAN_9) {
        [UIApplication sharedApplication].shortcutItems = @[];
    }
}

- (NSMutableDictionary *)needUserParamsWithType:(UserinfoOperationType)type {
    
    if ( kUserinfoOperationLogin == type || kUserinfoOperationRegister == type || kUserinfoOperationFindPassword == type) {
        return [NSMutableDictionary dictionary];
    } else {
        return [self increaseUserParams:nil];
    }
}
- (NSMutableDictionary *)increaseUserParams:(NSDictionary *)oldParams {
    
    NSMutableDictionary *result = [[NSMutableDictionary alloc] initWithDictionary:oldParams];
    
    if (self.logined) {
        [result setValue:self.userInfo.userid forKey:KEY_USERID];
        [result setValue:[self.userInfo.mobile RSAPublicEncryption] forKey:KEY_MOBILE];
        [result setValue:[UserinfoManager sharedUserinfo].userInfo.login_token forKey:@"login_token"];
    }
    
    return result;
}

- (NSURLSessionTask *)startRequest:(UserinfoOperationType)type
                       params:(NSDictionary *)params
                      success:(void(^)(id result) )success
                      failure:(void(^)(id result, NSString *errorDescription) )failure {
    
    NSString *mothed = [self fetchMothedByOperationType:type];
    NSMutableDictionary *paramete = [self needUserParamsWithType:type];
    [paramete addEntriesFromDictionary:params];
    
    return [NetworkContectManager sessionPOSTWithMothed:mothed params:paramete success:^(NSURLSessionTask *task, id result) {
       
        [self updateUserinfo:result params:params type:type];
        if (success)
            success(result);
        
    } failure:^(NSURLSessionTask *task, id result, NSString *errorDescription) {
        
        if (failure)
            failure(result, errorDescription);
    }];
}


#pragma mark - private method
- (NSString *)fetchMothedByOperationType:(UserinfoOperationType)type {
    
    NSString *mothed = nil;
    
    switch (type) {
        case kUserinfoOperationLogin:
            mothed = @"login";
            break;
            
        case kUserinfoOperationRegister:
            mothed = @"register";
            break;
            
        case kUserinfoOperationAlterPassword:
            mothed = @"updatepassword";
            break;
            
        case kUserinfoOperationAlterPhone:
            mothed = @"changeregistermobile";
            break;
            
        case kUserinfoOperationFindPassword:
            mothed = @"forgetpassword";
            break;
            
        case kUserinfoOperationAccountInfo:
            mothed = @"useraccount_new";
            break;
            
        case kUserinfoOperationCertified:
            mothed = @"savecertified";
            break;
            
        case kUserinfoOperationKaiHu:
            mothed = @"personal_register";
            break;
        case kUserinfoOperationJiHuo:
            mothed = @"activate_user";
            break;
        case kUserinfoOperationbangka:
            mothed = @"savebankcard";
            break;
        case kUserinfoOperationUnwindBankCard:
            mothed = @"unbindinghaikoubankcard";
            break;
            
        case kUserinfoOperationBuyProduct:
            mothed = @"buyinvestproduct";
            break;
            
        default:
            NSParameterAssert(false); //参数无效
            break;
    }
    
    return mothed;
}

- (void)updateUserinfo:(id)result params:(NSDictionary *)params type:(UserinfoOperationType)type {
    
    switch (type) {
        case kUserinfoOperationLogin:
        case kUserinfoOperationRegister:
        case kUserinfoOperationFindPassword:
            [self updateLoginInfo:[result[RESULT_DATA] firstObject]];
            break;
            
        case kUserinfoOperationAccountInfo:
            [self updateAccountInfo:[result[RESULT_DATA] firstObject]];
            break;
            
        case kUserinfoOperationCertified:
            [self.userInfo setUserinfoCertifierstateToYes];
            break;
            
        case kUserinfoOperationKaiHu:
//            [self.userInfo setUserinfoCertifierstateToYes];
            break;
        case kUserinfoOperationbangka:
            //            [self.userInfo setUserinfoCertifierstateToYes];
            break;
            
        case kUserinfoOperationBuyProduct:
            [self updateDepositInfo:params[KEY_BUY_SHARE]];
            break;
            
        default:
            break;
    }
}
- (void)updateLoginInfo:(NSDictionary *)loginInfo {
    
    [self.userInfo updateLoginInfo:loginInfo];
    self.logined = YES;
    
    [[UserinfoManager sharedUserinfo] startRequest:kUserinfoOperationAccountInfo params:nil success:nil failure:nil];
   
    [USERDEFAULTS synchronize];
    //widge 沙盒通讯
    NSUserDefaults*shared = [[NSUserDefaults alloc]initWithSuiteName:@"group.com.yuanin.widge"];
    [shared setBool:YES forKey:IS_LOG];
    NSString *amount = self.userInfo.amount;
    [shared setObject:amount forKey:@"amount"];
    NSString *balance = self.userInfo.balance;
    [shared setObject:balance forKey:@"balance"];
    NSString *interest = self.userInfo.interest;
    [shared setObject:interest forKey:@"interest"];
    [shared synchronize];

    if (SYSTEM_VERSION_GREATER_THAN_9) {
        UIApplicationShortcutItem *rechargeItem = [[UIApplicationShortcutItem alloc] initWithType:NSStringFromClass([RechargeVC class]) localizedTitle:@"充值" localizedSubtitle:nil icon:[UIApplicationShortcutIcon iconWithTemplateImageName:@"shortcut_recharge"] userInfo:nil];
        UIApplicationShortcutItem *withdrawItem = [[UIApplicationShortcutItem alloc] initWithType:NSStringFromClass([WithdrawVC class]) localizedTitle:@"提现" localizedSubtitle:nil icon:[UIApplicationShortcutIcon iconWithTemplateImageName:@"shortcut_withdraw"] userInfo:nil];
        UIApplicationShortcutItem *ruleWebItem  = [[UIApplicationShortcutItem alloc] initWithType:NSStringFromClass([RuleWebVC class]) localizedTitle:@"邀请好友" localizedSubtitle:nil icon:[UIApplicationShortcutIcon iconWithTemplateImageName:@"shortcut_invite_friend"] userInfo:nil];
        
        [UIApplication sharedApplication].shortcutItems = @[rechargeItem, withdrawItem, ruleWebItem];
    }
}
- (void)updateAccountInfo:(NSDictionary *)accountInfo {
    
    [self.userInfo updateUserinfo:accountInfo];
}
- (void)alterPhone:(NSString *)mobile {
    
    [self.userInfo updateMobile:mobile];
}

- (void)updateDepositInfo:(NSString *)share {
    
    NSDecimalNumber *balance = [[NSDecimalNumber decimalNumberWithString:self.userInfo.balance] decimalNumberBySubtracting:[NSDecimalNumber decimalNumberWithString:share] withBehavior:self.roundingBehacior];
    NSDecimalNumber *deposit = [[NSDecimalNumber decimalNumberWithString:self.userInfo.deposit] decimalNumberByAdding:[NSDecimalNumber decimalNumberWithString:share] withBehavior:self.roundingBehacior];
    [self.userInfo updateBalance:[self.formatter stringFromNumber:balance]];
    [self.userInfo updateDeposit:[self.formatter stringFromNumber:deposit]];
}

- (void)saveLastAccount {
    
    [USERDEFAULTS setValue:self.userInfo.mobile forKey:LAST_LOGIN_ACCOUNT];
    [USERDEFAULTS synchronize];
}
- (NSString *)lastAccount {
    
    return [USERDEFAULTS objectForKey:LAST_LOGIN_ACCOUNT];
}

#pragma mark - getter & setter
- (NSMutableArray *)observer {
    if (!_observer) {
        _observer = [[NSMutableArray alloc] init];
    }
    return _observer;
}
- (NSDecimalNumberHandler *)roundingBehacior {
    
    if (!_roundingBehacior) {
        
        _roundingBehacior = [NSDecimalNumberHandler decimalNumberHandlerWithRoundingMode:NSRoundPlain scale:2 raiseOnExactness:NO raiseOnOverflow:NO raiseOnUnderflow:NO raiseOnDivideByZero:NO];
    }
    
    return _roundingBehacior;
}
- (NSNumberFormatter *)formatter {
    
    if (!_formatter) {
        _formatter = [[NSNumberFormatter alloc] init];
//        _formatter.maximumFractionDigits = 2;
//        _formatter.numberStyle = NSNumberFormatterDecimalStyle;
        [_formatter setPositiveFormat:@"0.##"];
    }
    return _formatter;
}
@end
