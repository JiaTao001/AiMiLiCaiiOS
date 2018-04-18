//
//  RewardViewModel.m
//  YuanXin_Project
//
//  Created by Yuanin on 16/4/26.
//  Copyright © 2016年 yuanxin. All rights reserved.
//

#import "RewardViewModel.h"

@interface RewardViewModel ()

@property (strong, nonatomic, readwrite) NSMutableArray *info;
@property (assign, nonatomic, readwrite) NSUInteger currentPage;
@end

@implementation RewardViewModel

- (instancetype)init {
    self = [super init];
    
    if (self) {
        _currentPage = 0;
    }
    return self;
}
- (void)fetchRewardWithPage:(NSUInteger)page success:(void(^)(id result)) successBlock failure:(void(^)(NSString *errorDescription)) failureBlock {
    
       @weakify(self)
    [self postMethod:@"getgiftproductlist" params:[self createParamsWithPage:page] success:^(id result) {
        @strongify(self)
        
        self.currentPage = page;
        if (!successBlock) return;
        successBlock(result);
    } failure:^(id result, NSString *errorDescription) {
        
        if (!failureBlock) return;
        failureBlock(errorDescription);
    }];
}
- (NSDictionary *)createParamsWithPage:(NSUInteger)page {
    
    NSMutableDictionary *result = [[UserinfoManager sharedUserinfo] increaseUserParams:nil];
    [result addEntriesFromDictionary:@{@"type":@(self.type), @"status":@((NSInteger)self.needValid), @"pageqty":@(Each_Page_Num), @"currentpage":@(page)}];

    return result;
}

- (void)beginFetchRewardWithSuccess:(void(^)(id result)) successBlock failure:(void(^)(NSString *errorDescription)) failureBlock {
    
    @weakify(self)
    [self fetchRewardWithPage:1 success:^(id result) {
        @strongify(self)
        
        self.info = [NSMutableArray arrayWithArray:result[RESULT_DATA]];
        if (!successBlock) return;
        successBlock(result);
    } failure:failureBlock];
}
- (void)fetchNextPageRewardWithSuccess:(void(^)(id result)) successBlock failure:(void(^)(NSString *errorDescription)) failureBlock {
    
    [self fetchRewardWithPage:_currentPage + 1 success:^(id result) {
        
        [self.info addObjectsFromArray:result[RESULT_DATA]];
        if (!successBlock) return;
        successBlock(result);
    } failure:failureBlock];
}

- (NSArray *)rewardInfo {
    
    return [self.info copy];
}
@end
