//
//  Userinfo.m
//  YuanXin_Project
//
//  Created by Yuanin on 15/10/28.
//  Copyright © 2015年 yuanxin. All rights reserved.
//

#import "Userinfo.h"

@interface Userinfo()

@property (strong, atomic, readwrite) NSString *userid;
@property (strong, atomic, readwrite) NSString *login_token;
@property (strong, atomic, readwrite) NSString *user_account_status;
@property (strong, atomic, readwrite) NSString *is_activate_hkaccount;
@property (strong, atomic, readwrite) NSString *surveyresult;
@property (strong, atomic, readwrite) NSString *is_bind_bankcard;
@property (strong, atomic, readwrite) NSString *mobile;
@property (strong, atomic, readwrite) NSString *amount;         /**< 账户总资产 */
@property (strong, atomic, readwrite) NSString *balance;        /**< 可用余额 */
@property (strong, atomic, readwrite) NSString *interest;       /**< 总收益 */
@property (strong, atomic, readwrite) NSString *current;        /**< 活期总额 */
@property (strong, atomic, readwrite) NSString *deposit;        /**< 定期总额 */
@property (strong, atomic, readwrite) NSString *enjoy;
@property (strong, atomic, readwrite) NSString *red_num;
@property (strong, atomic, readwrite) NSNumber *minRechargeMoney;/**< 最小充值金额 */
@property (assign, atomic, readwrite) BOOL certifierstate;      /**< 实名认证 */
@end

@implementation Userinfo

- (instancetype)init {
    self = [super init];
    
    if (self) {
        [self resetUserinfo];
    }
    return self;
}

- (void)clear {
    
    [self resetUserinfo];
    [TCKeychain delete:KEY_USER_INFO];
    [[NSNotificationCenter defaultCenter] postNotificationName:kRecommendShouldChangeNotification object:nil];
}
- (void)resetUserinfo {
    
    self.userid           = @"";
    self.login_token = @"";
//    [UserinfoManager sharedUserinfo].userInfo.login_token  = @"";
    self.user_account_status   = @"";
    self.is_activate_hkaccount   = @"";
    self.surveyresult   = @"";
    self.is_bind_bankcard   = @"";
    self.mobile           = @"";
    self.amount           = @"0.00";
    self.balance          = @"0.00";
    self.interest         = @"0.00";
    self.current          = @"0.00";
    self.deposit          = @"0.00";
    self.enjoy          = @"0.00";
    self.red_num          = @"0";
    self.minRechargeMoney = @5;
    self.certifierstate   = NO;
}
- (void)updateLoginInfo:(NSDictionary *)loginInfo {
    if (!loginInfo.count) return;
    
    self.userid = [CommonTools convertToStringWithObject:loginInfo[KEY_USERID]];
    self.login_token = [CommonTools convertToStringWithObject:loginInfo[KEY_Login_Token]];
    self.mobile = [CommonTools convertToStringWithObject:loginInfo[KEY_MOBILE]];
    
    [self saveUserinfo];
    [[NSNotificationCenter defaultCenter] postNotificationName:kRecommendShouldChangeNotification object:nil];
}
- (void)updateUserinfo:(NSDictionary *)userinfoDic {
    
    if (!userinfoDic.count) return;
    
    self.amount           = [CommonTools convertToStringWithObject:userinfoDic[KEY_AMOUT]];
    self.user_account_status           = [CommonTools convertToStringWithObject:userinfoDic[KEY_user_account_status]];
    self.is_activate_hkaccount           = [CommonTools convertToStringWithObject:userinfoDic[@"is_activate_hkaccount"]];
     self.surveyresult           = [CommonTools convertToStringWithObject:userinfoDic[@"surveyresult"]];
    self.is_bind_bankcard           = [CommonTools convertToStringWithObject:userinfoDic[@"is_bind_bankcard"]];
    self.balance          = [CommonTools convertToStringWithObject:userinfoDic[KEY_BALANCE]];
    self.interest         = [CommonTools convertToStringWithObject:userinfoDic[KEY_INTEREST]];
    self.current          = [CommonTools convertToStringWithObject:userinfoDic[KEY_CURRENT]];
    self.deposit          = [CommonTools convertToStringWithObject:userinfoDic[KEY_DEPOSIT]];
    self.enjoy          =   [NSString stringWithFormat:@"%@",userinfoDic[@"enjoy"]] ;
    self.red_num          = [NSString stringWithFormat:@"%@",userinfoDic[@"red_num"]] ;
    self.certifierstate   = [userinfoDic[KEY_CERTIFIERSTATE] boolValue];
    self.minRechargeMoney = userinfoDic[KEY_MIN_RECHARGE_MONEY];
    
    [self saveUserinfo];
}
- (void)updateBalance:(NSString *)balance {
    
    if ([balance isEqualToString:self.balance]) return;
    
    self.balance = balance;
    [self saveUserinfo];
}

- (void)updateis_activate_hkaccount:(NSString *)is_activate_hkaccount{
    if ([is_activate_hkaccount isEqualToString:self.is_activate_hkaccount]) return;
    
    self.is_activate_hkaccount = is_activate_hkaccount;
    [self saveUserinfo];
}
- (void)updatesurveyresult:(NSString *)surveyresult{
    if ([surveyresult isEqualToString:self.surveyresult]) return;
    
    self.surveyresult = surveyresult;
    [self saveUserinfo];
}

- (void)updateis_bind_bankcard:(NSString *)is_bind_bankcard{
    if ([is_bind_bankcard isEqualToString:self.is_bind_bankcard]) return;
    
    self.is_bind_bankcard   = is_bind_bankcard;
    [self saveUserinfo];
}

- (void)updateDeposit:(NSString *)deposit {
    
    if ([deposit isEqualToString:self.deposit]) return;
    
    self.deposit = deposit;
    [self saveUserinfo];
}
- (void)updateAmount:(NSString *)amount {
    
    if ([amount isEqualToString:self.amount]) return;
    
    self.amount = amount;
    [self saveUserinfo];
}

- (void)updateMobile:(NSString *)mobile {
    if ([mobile isEqualToString:self.mobile]) return;
    
    self.mobile = mobile;
    [self saveUserinfo];
}
- (void)updateAccountStatus:(NSString *)accounStatus{
    if ([accounStatus isEqualToString:self.user_account_status]) return;
    
    self.user_account_status = accounStatus;
    [self saveUserinfo];
}

- (void)setUserinfoCertifierstateToYes {
    
    self.certifierstate = YES;
    [self saveUserinfo];
}


- (void)saveUserinfo {
    
    NSMutableDictionary *userinfo    = [TCKeychain load:KEY_USER_INFO];
    NSMutableDictionary *userinfoDic = nil;
    if ([userinfo[KEY_USERINFO_DIC] isMemberOfClass:[NSMutableDictionary class]]) {
        userinfoDic = userinfo[KEY_USERINFO_DIC];
    } else {
        userinfoDic = [[NSMutableDictionary alloc] init];
    }
    
    [userinfoDic setValue:self.userid forKey:KEY_USERID];
        [userinfoDic setValue:self.login_token forKey:KEY_Login_Token];
    
     [userinfoDic setValue:self.user_account_status forKey:KEY_user_account_status];
    
      [userinfoDic setValue:self.is_activate_hkaccount forKey:@"is_activate_hkaccount"];
    [userinfoDic setValue:self.surveyresult forKey:@"surveyresult"];
      [userinfoDic setValue:self.is_bind_bankcard forKey:@"is_bind_bankcard"];
    [userinfoDic setValue:self.mobile forKey:KEY_MOBILE];
    [userinfoDic setValue:self.amount forKey:KEY_AMOUT];
    [userinfoDic setValue:self.interest forKey:KEY_INTEREST];
    [userinfoDic setValue:self.balance forKey:KEY_BALANCE];
    [userinfoDic setValue:self.current forKey:KEY_CURRENT];
    [userinfoDic setValue:self.deposit forKey:KEY_DEPOSIT];
    [userinfoDic setValue:self.enjoy forKey:@"enjoy"];
    [userinfoDic setValue:self.red_num forKey:@"red_num"];
    [userinfoDic setValue:@(self.certifierstate) forKey:KEY_CERTIFIERSTATE];
    [userinfoDic setValue:self.minRechargeMoney forKey:KEY_MIN_RECHARGE_MONEY];
    
    [userinfo setValue:userinfoDic forKey:KEY_USERINFO_DIC];
    
    [TCKeychain save:KEY_USER_INFO data:userinfo];
}

@end
