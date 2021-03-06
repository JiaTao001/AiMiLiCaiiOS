//
//  ProductInfo.h
//  YuanXin_Project
//
//  Created by Yuanin on 16/4/20.
//  Copyright © 2016年 yuanxin. All rights reserved.
//

#import "SingleProductInfo.h"

@interface ProductInfo : SingleProductInfo

@property (assign, nonatomic, readonly, getter=isCanBuy) BOOL canBuy;
@property (strong, nonatomic, readonly) NSString *replyMethod;
@property (strong, nonatomic, readonly) NSString *productState;
@property (strong, nonatomic, readonly) NSString *restOfShare;
//利息
@property (strong, nonatomic, readonly) NSString *annualInterest;
//加息
@property (strong, nonatomic, readonly) NSString *extannual;
//原利息
@property (strong, nonatomic, readonly) NSString *organnual;

@property (strong, nonatomic, readonly) NSString *guaranteeMethod;
@property (strong, nonatomic, readwrite) NSString *term;
@property (strong, nonatomic, readwrite) NSString *ternUnit;

- (NSString *)theTermOfProduct;
- (NSString *)theRestOfShare;

- (instancetype)initWithDictionary:(NSDictionary *)aDic;
+ (instancetype)productInfoWithDictionary:(NSDictionary *)aDic;
@end
