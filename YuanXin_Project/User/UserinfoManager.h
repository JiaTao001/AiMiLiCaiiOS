//
//  UserinfoManager.h
//  YuanXin_Project
//
//  Created by Yuanin on 15/10/23.
//  Copyright © 2015年 yuanxin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Userinfo.h"

typedef NS_ENUM(NSInteger, UserinfoOperationType) {
    kUserinfoOperationLogin = 0,
    kUserinfoOperationRegister,
    kUserinfoOperationFindPassword,
    //////////////以上借口不需要 userinfo 本身的参数 /////////////
    
    kUserinfoOperationAlterPassword,
    kUserinfoOperationAlterPhone,
    kUserinfoOperationAccountInfo,
    kUserinfoOperationCertified,
    kUserinfoOperationKaiHu,
    kUserinfoOperationJiHuo,
    kUserinfoOperationbangka,
    kUserinfoOperationUnwindBankCard,
    kUserinfoOperationBuyProduct,
};

@interface UserinfoManager : NSObject

@property (strong, nonatomic, readonly) NSDecimalNumberHandler *roundingBehacior;
@property (strong, nonatomic, readonly) NSNumberFormatter      *formatter;
@property (assign, nonatomic, readonly) BOOL                   logined;/**< 是否已经登录 */

@property (strong, nonatomic, readonly) Userinfo               *userInfo;/**<用户信息 */

+ (instancetype)sharedUserinfo;

/**
 *  退出登录
 */
- (void)logout;

/**
 *  增加用户数据
 *
 */
- (NSMutableDictionary *)increaseUserParams:(NSDictionary *)oldParams;

/**
 *  向服务器请求关于用户信息的操作
 *
 *  @param type    UserinfoOperationType
 *  @param params  具体的参数由服务器定义
 *  @param success 成功返回的信息
 *  @param failure 失败返回的信息
 *
 *  @return 返回线程所在的操作队列
 */
- (NSURLSessionTask *)startRequest:(UserinfoOperationType)type
                       params:(NSDictionary *)params
                      success:(void(^)(id result) )success
                      failure:(void(^)(id result, NSString *errorDescription) )failure;


- (void)alterPhone:(NSString *)mobile;
- (void)saveLastAccount;
- (NSString *)lastAccount;
@end
