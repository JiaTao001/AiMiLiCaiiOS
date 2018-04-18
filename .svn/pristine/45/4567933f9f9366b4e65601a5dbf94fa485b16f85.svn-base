//
//  NSString+ExtendMethod.m
//  YuanXin_Project
//
//  Created by Yuanin on 16/6/1.
//  Copyright © 2016年 yuanxin. All rights reserved.
//

#import "NSString+ExtendMethod.h"
#import "CRSA.h"

#import <CommonCrypto/CommonDigest.h>

@implementation NSString (ExtendMethod)


- (NSString *)MD5Encryption {
    
    const char *cStr = [self UTF8String];
    
    unsigned char digest[CC_MD5_DIGEST_LENGTH];
    CC_MD5( cStr, (CC_LONG)strlen(cStr), digest ); //这里的用法明显是错误的，但是不知道为什么依然可以在网络上得以流传。当srcString中包含空字符（\0）时
    //CC_MD5( cStr, (CC_LONG)string.length, digest );  //////对中文加密不正确，因为中文的字节长度不一样，上面方面正确计算了中文的字节长度
    NSMutableString *result = [NSMutableString stringWithCapacity:2 * CC_MD5_DIGEST_LENGTH];
    for(int i = 0; i < CC_MD5_DIGEST_LENGTH; i++) {
        [result appendFormat:@"%02x", digest[i]];
    }
    
    return result;
}

- (NSString *)RSAPublicEncryption {
    
    return [[CRSA shareInstance] encryptByRsa:self withKeyType:KeyTypePublic];
}

- (NSString *)hidePosition:(HideStringPartPosition)type length:(NSUInteger)length {
    
    if (self.length <= length) return self;
    
    NSMutableString *result = [NSMutableString stringWithString:self];
    
    //default
    NSInteger startPosition = 0;
    NSInteger endPosition = length;
    if (kHideStringRight == type) { //right
        startPosition = result.length - length;
        endPosition = result.length;
    } else if (kHideStringCenter == type) { //center
        startPosition = (result.length - length)/2;
        endPosition = startPosition + length;
    }
    
    for (; startPosition < endPosition; ++startPosition) {
        [result replaceCharactersInRange:NSMakeRange(startPosition, 1) withString:@"*"];
    }
    return result;
}
@end
