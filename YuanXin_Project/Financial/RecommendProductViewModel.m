//
//  RecommendProductViewModel.m
//  YuanXin_Project
//
//  Created by Yuanin on 16/4/19.
//  Copyright © 2016年 yuanxin. All rights reserved.
//

#import "RecommendProductViewModel.h"

@interface RecommendProductViewModel ()

@property (strong, nonatomic, readwrite) NSArray *recommendProductInfo;
@end

@implementation RecommendProductViewModel

@synthesize recommendProductInfo = _recommendProductInfo;

- (void)fetchRecommendProductInfoWithSuccess:(void(^)(id result)) successBlock failure:(void(^)(NSString *errorDescription)) failureBlock {
    
    @weakify(self)
    [self postMethod:@"indexproductlist" params:nil success:^(id result) {
        @strongify(self)
        
        self.recommendProductInfo =  [self convertToRecommentProductInfoWithArror:result[RESULT_DATA]];
        
        if (!successBlock) return;
        successBlock(result);
    } failure:^(id result, NSString *errorDescription) {
        
        if (!failureBlock) return;
        failureBlock(errorDescription);
    }];
}

- (NSArray<RecommendProductInfo *> *)convertToRecommentProductInfoWithArror:(NSArray *)aArr {
    
    NSMutableArray *result = [NSMutableArray array];
    
    for (NSDictionary *aDic in aArr) {
        [result addObject:[RecommendProductInfo productInfoWithDictionary:aDic]];
    }
    
    return result;
}

- (void)setRecommendProductInfo:(NSArray *)recommendProductInfo {
    _recommendProductInfo = recommendProductInfo;
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        [NSKeyedArchiver archiveRootObject:recommendProductInfo toFile:[AiMiApplication pathForCachesWithFileName:recommendPath]];
    });
}

- (NSArray<RecommendProductInfo *> *)recommendProductInfo {
    
    if (!_recommendProductInfo) {
        _recommendProductInfo = [NSKeyedUnarchiver unarchiveObjectWithFile:[AiMiApplication pathForCachesWithFileName:recommendPath]];
    }
    
    return _recommendProductInfo;
}
@end
