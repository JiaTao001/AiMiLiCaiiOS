//
//  WJKeychain.h
//  wujin-buyer
//
//  Created by wujin  on 15/1/19.
//  Copyright (c) 2015年 wujin. All rights reserved.
//

#import <Foundation/Foundation.h>

#define KEY_USER_INFO               @"com.yuanin.app.userinfo"

    #define KEY_USER_GESTUREPASSWORD    @"com.yuanin.app.gesturepassword"
    #define KEY_USERINFO_DIC            @"com.yuanin.app.userinfoDic"



// amount;      /**< 账户总资产 */
// balance;     /**< 可用余额 */
// interest;     /**< 总收益 */
// BOOL certifierstate;  /**< 实名认证 */
// BOOL bankcardstate;    /**< 银行卡认证 */
// BOOL tradepasswordstate;  /**< 交易密码设置 */

@interface TCKeychain : NSObject
+ (NSMutableDictionary *)getKeychainQuery:(NSString *)service;

+ (void)delete:(NSString *)service;

+ (id)load:(NSString *)service;

+ (void)save:(NSString *)service data:(id)data;
@end
