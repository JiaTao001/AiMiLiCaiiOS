//
//  RecommendProductInfo.h
//  YuanXin_Project
//
//  Created by Yuanin on 16/4/19.
//  Copyright © 2016年 yuanxin. All rights reserved.
//

#import "ProductInfo.h"

@interface RecommendProductInfo : ProductInfo

@property (assign, nonatomic, readonly, getter=isNewReconmend) BOOL newRecommend;

- (instancetype)initWithDictionary:(NSDictionary *)aDic;
+ (instancetype)productInfoWithDictionary:(NSDictionary *)aDic;
@end
