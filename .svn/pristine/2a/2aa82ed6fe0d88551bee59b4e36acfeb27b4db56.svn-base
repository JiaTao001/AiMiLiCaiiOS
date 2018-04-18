//
//  RecommendProductInfo.m
//  YuanXin_Project
//
//  Created by Yuanin on 16/4/19.
//  Copyright © 2016年 yuanxin. All rights reserved.
//

#import "RecommendProductInfo.h"

@interface RecommendProductInfo ()

@property (assign, nonatomic, readwrite) BOOL newRecommend;

@end

@implementation RecommendProductInfo

- (instancetype)initWithDictionary:(NSDictionary *)aDic {
    self = [super initWithDictionary:aDic];
    
    if (self) {

        _newRecommend = [aDic[@"isnew"] boolValue];
    }
    return self;
}
+ (instancetype)productInfoWithDictionary:(NSDictionary *)aDic {
    
    return [[RecommendProductInfo alloc] initWithDictionary:aDic];
}

#pragma mark - NSCoding

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [super encodeWithCoder:aCoder];
    
    [aCoder encodeBool:self.newRecommend forKey:@"newRecommend"];
}
- (nullable instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    
    if (self) {
        _newRecommend = [aDecoder decodeBoolForKey:@"newRecommend"];
    }
    
    return self;
}
@end
