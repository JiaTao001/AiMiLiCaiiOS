//
//  ProductInfo.m
//  YuanXin_Project
//
//  Created by Yuanin on 16/4/20.
//  Copyright © 2016年 yuanxin. All rights reserved.
//

#import "ProductInfo.h"

@interface ProductInfo ()

//@property (strong, nonatomic, readwrite) NSString *term;
//@property (strong, nonatomic, readwrite) NSString *ternUnit;
@end

@implementation ProductInfo

- (instancetype)initWithDictionary:(NSDictionary *)aDic {
    self = [super initWithProductID:aDic[@"id"] productName:aDic[@"title"]];
    
    if (self) {
        _guaranteeMethod = aDic[@"guarantee_method"];
        _replyMethod = aDic[@"repay_method"];
        _productState = aDic[@"statusname"];
        _ternUnit = aDic[@"unit"];
      
        _term = [CommonTools convertToStringWithObject:aDic[@"term"]];
        _restOfShare = [CommonTools convertToStringWithObject:aDic[@"amount"]];
        _annualInterest = [CommonTools convertToStringWithObject:aDic[@"annual"]];
        _organnual = [CommonTools convertToStringWithObject:aDic[@"organnual"]];
        _extannual = [CommonTools convertToStringWithObject:aDic[@"extannual"]];
        _canBuy = [aDic[@"isbuy"] boolValue];
    }
    return self;
}
+ (instancetype)productInfoWithDictionary:(NSDictionary *)aDic {
    
    return [[ProductInfo alloc] initWithDictionary:aDic];
}

#pragma mark - NSCoding

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [super encodeWithCoder:aCoder];
    
    //    @property (strong, nonatomic, readwrite) NSString *replyMethod;
    //    @property (strong, nonatomic, readwrite) NSString *productState;
    //    @property (strong, nonatomic, readwrite) NSString *term;
    //    @property (strong, nonatomic, readwrite) NSString *ternUnit;
    //    @property (strong, nonatomic, readwrite) NSString *restOfShare;
    //    @property (strong, nonatomic, readwrite) NSString *annualInterest;
    //    @property (strong, nonatomic, readwrite) NSString *guaranteeMethod;
    //    @property (assign, nonatomic, readwrite) BOOL canBuy;
    //    @property (assign, nonatomic, readwrite) BOOL newRecommend;
    [aCoder encodeObject:self.replyMethod forKey:@"replyMethod"];
    [aCoder encodeObject:self.productState forKey:@"productState"];
    [aCoder encodeObject:self.term forKey:@"term"];
    [aCoder encodeObject:self.ternUnit forKey:@"ternUnit"];
    [aCoder encodeObject:self.restOfShare forKey:@"restOfShare"];
    [aCoder encodeObject:self.annualInterest forKey:@"annualInterest"];
    [aCoder encodeObject:self.extannual forKey:@"extannual"];
    [aCoder encodeObject:self.organnual forKey:@"organnual"];
    [aCoder encodeObject:self.guaranteeMethod forKey:@"guaranteeMethod"];
    [aCoder encodeBool:self.canBuy forKey:@"canBuy"];
}
- (nullable instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    
    if (self) {
        _replyMethod = [aDecoder decodeObjectForKey:@"replyMethod"];
        _productState = [aDecoder decodeObjectForKey:@"productState"];
        _term = [aDecoder decodeObjectForKey:@"term"];
        _ternUnit = [aDecoder decodeObjectForKey:@"ternUnit"];
        _restOfShare = [aDecoder decodeObjectForKey:@"restOfShare"];
        _annualInterest = [aDecoder decodeObjectForKey:@"annualInterest"];
        _extannual = [aDecoder decodeObjectForKey:@"extannual"];
        _organnual = [aDecoder decodeObjectForKey:@"organnual"];
        _guaranteeMethod = [aDecoder decodeObjectForKey:@"guaranteeMethod"];
        _canBuy = [aDecoder decodeBoolForKey:@"canBuy"];
    }
    
    return self;
}

- (NSString *)theTermOfProduct {
    
    return [NSString stringWithFormat:@"%@ %@", self.term, self.ternUnit];
}
- (NSString *)theRestOfShare {
    
    return [NSString stringWithFormat:@"剩余%@元", self.restOfShare];
}
@end
