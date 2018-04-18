//
//  NSString+ExtendMethod.h
//  YuanXin_Project
//
//  Created by Yuanin on 16/6/1.
//  Copyright © 2016年 yuanxin. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, HideStringPartPosition) {
    kHideStringCenter,
    kHideStringLeft,
    kHideStringRight,
};

@interface NSString (ExtendMethod)

/**
 *  将 string 进行 32位MD5加密
 *
 *  @param string 需要加密的字符串
 *
 *  @return 加密过的String
 */
- (NSString *)MD5Encryption;

/**
 *  将 string 进行RSA加密
 *
 *  @return 加密过的String
 */
- (NSString *)RSAPublicEncryption;

/**
 *  用@"*"隐藏需要隐藏的部分
 *
 *  @param string 需要隐藏的string
 *  @param type   隐藏的位置, 中间，左边， 右边
 *  @param length 需要隐藏的长度
 *
 *  @return 返回 隐藏了数据的 新的字符串
 */
- (NSString *)hidePosition:(HideStringPartPosition)type length:(NSUInteger)length;
@end
