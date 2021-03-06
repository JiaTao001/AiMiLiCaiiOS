//
//  Userinfo.h
//  YuanXin_Project
//
//  Created by Yuanin on 15/10/28.
//  Copyright © 2015年 yuanxin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TCKeychain.h"


#define KEY_USERID             @"userid"
#define KEY_Login_Token        @"login_token"
#define KEY_MOBILE             @"mobile"
#define KEY_PASSWORD           @"password"
#define KEY_VERIFYCODE         @"verifycode"
#define KEY_AMOUT              @"amount"
#define KEY_user_account_status     @"user_account_status"
#define KEY_MIN_RECHARGE_MONEY @"bank_min_amount"
#define KEY_BALANCE            @"balance"
#define KEY_INTEREST           @"interest"
#define KEY_CURRENT            @"current"
#define KEY_DEPOSIT            @"deposit"
#define KEY_CERTIFIERSTATE     @"cartifierstate"
#define KEY_REALNAME           @"realname"
#define KEY_IDNUMBER           @"idnumber"
#define KEY_NEWMOBILE          @"newmobile"
#define KEY_CERIFIER           @"certifier"
#define KEY_IDCARD             @"idcardno"
#define KEY_BUY_SHARE          @"buyqty"
#define KEY_GIFT               @"giftid"


/**
 *  //////////////////////////userinfo
 */
@interface Userinfo : NSObject

@property (strong, atomic, readonly) NSString *userid;
@property (strong, atomic, readonly) NSString *login_token;
@property (strong, atomic, readonly) NSString *mobile;
@property (strong, atomic, readonly) NSString *amount;          /**< 账户总资产 */
@property (strong, atomic, readonly) NSString *balance;         /**< 可用余额 */
@property (strong, atomic, readonly) NSString *interest;        /**< 总收益 */
@property (strong, atomic, readonly) NSString *current;         /**< 活期总额 */
@property (strong, atomic, readonly) NSString *deposit;         /**< 定期总额 */
@property (strong, atomic, readonly) NSString *enjoy;
@property (strong, atomic, readonly) NSString *red_num;
@property (strong, atomic, readonly) NSNumber *minRechargeMoney;/**< 最小充值金额 */
@property (assign, atomic, readonly) BOOL certifierstate;       /**< 实名认证 */
@property (strong, atomic, readonly) NSString *user_account_status;
@property (strong, atomic, readonly) NSString *is_activate_hkaccount;
@property (strong, atomic, readonly) NSString *surveyresult;
@property (strong, atomic, readonly) NSString *is_bind_bankcard;
- (void)clear;

- (void)updateLoginInfo:(NSDictionary *)loginInfo;
- (void)updateUserinfo:(NSDictionary *)userinfoDic;
- (void)updateBalance:(NSString *)balance;

- (void)updateis_activate_hkaccount:(NSString *)is_activate_hkaccount;
- (void)updatesurveyresult:(NSString *)surveyresult;


- (void)updateis_bind_bankcard:(NSString *)is_bind_bankcard;

- (void)updateDeposit:(NSString *)deposit;
- (void)updateAmount:(NSString *)amount;
- (void)updateMobile:(NSString *)mobile;
- (void)updateAccountStatus:(NSString *)accounStatus;
- (void)setUserinfoCertifierstateToYes;
@end
