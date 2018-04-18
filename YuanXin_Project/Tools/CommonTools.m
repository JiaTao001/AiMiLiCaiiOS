//
//  CommonTools.m
//  YuanXin_Project
//
//  Created by Yuanin on 16/6/1.
//  Copyright © 2016年 yuanxin. All rights reserved.
//

#import "CommonTools.h"

@implementation CommonTools

+ (UIImage *)singleImageFromColor:(UIColor *)color {
    NSParameterAssert(color);
    
    CGRect rect = CGRectMake(0, 0, 1, 1);
    
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return img;
}

+ (NSString *)convertToStringWithObject:(id)object {
    
    if ([object isKindOfClass:[NSString class]]) {
        return object;
    } else if ([object isKindOfClass:[NSNumber class]]) {
        return [[UserinfoManager sharedUserinfo].formatter stringFromNumber:object];
    } else if ([object isKindOfClass:[NSDictionary class]] || [object isKindOfClass:[NSArray class]] || [object isKindOfClass:[NSSet class]]) {
        return [object description];
    } else if (!object || [object isKindOfClass:[NSNull class]]) {
        return @"";
    } else {
        return nil;
    }
}

+ (CGFloat)cutOutCGFloatDecimal:(CGFloat)aFloat preserve:(NSUInteger)decimal {
    
    NSInteger tmpPow = pow(10, decimal);
    
    NSInteger tmpInt = ((aFloat*tmpPow*10) + (aFloat >= 0 ? 5 : -5) )/10; //四舍五入
    CGFloat tmpFloat = (CGFloat)tmpInt/tmpPow;
    
    return tmpFloat;
}

+ (NSInteger)roundedCGFloat:(CGFloat)aFloat {
    
    return (NSInteger)((aFloat*10) + (aFloat >= 0 ? 5 : -5) )/10; //四舍五入
}

+ (NSString *)completeWebPathWithSubpath:(NSString *)subpath {
    
    return [NSString stringWithFormat:@"%@%@", hostUrl, subpath];
}

@end
