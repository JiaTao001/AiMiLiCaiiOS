//
//  EntrustViewModel.m
//  YuanXin_Project
//
//  Created by Yuanin on 16/5/3.
//  Copyright © 2016年 yuanxin. All rights reserved.
//

#import "EntrustViewModel.h"

@interface EntrustViewModel ()

@property (strong, nonatomic, readwrite) NSMutableArray *entrustInfo;
@property (assign, nonatomic, readwrite) NSUInteger currentPage;
@end

@implementation EntrustViewModel

- (void)fetchEntrustWithPage:(NSUInteger)page success:(void(^)(id result)) successBlock failure:(void(^)(NSString *errorDescription)) failureBlock {
      NSMutableDictionary *params = [[UserinfoManager sharedUserinfo] increaseUserParams:nil];
    
    @weakify(self)
    [self postMethod:@"auto_list" params:params success:^(id result) {
        @strongify(self)
        
//        self.currentPage = page;
        if (!successBlock) return;
        successBlock(result);
    } failure:^(id result, NSString *errorDescription) {
        
        if (!failureBlock) return;
        failureBlock(errorDescription);
    }];
}
- (NSDictionary *)createParamsWithPage:(NSUInteger)page {
    
    NSMutableDictionary *result = [[UserinfoManager sharedUserinfo] increaseUserParams:nil];
//    [result addEntriesFromDictionary:@{@"type":@(self.type), @"pageqty":@(Each_Page_Num), @"currentpage":@(page)}];
//    
    return result;
}

- (void)beginFetchEntrustWithSuccess:(void(^)(id result)) successBlock failure:(void(^)(NSString *errorDescription)) failureBlock {
    
    @weakify(self)
    [self fetchEntrustWithPage:1 success:^(id result) {
        @strongify(self)
        
        self.entrustInfo = [NSMutableArray arrayWithArray:result[RESULT_DATA]];
        if (!successBlock) return;
        successBlock(result);
    } failure:failureBlock];
}
- (void)fetchNextPageEntrustWithSuccess:(void(^)(id result)) successBlock failure:(void(^)(NSString *errorDescription)) failureBlock {
    
    [self fetchEntrustWithPage:_currentPage + 1 success:^(id result) {
        
        [_entrustInfo addObjectsFromArray:result[RESULT_DATA]];
        if (!successBlock) return;
        successBlock(result);
    } failure:failureBlock];
}

- (void)changeEntrustStateWithIndex:(NSInteger)index on:(BOOL)on success:(void (^)(id))successBlock failure:(void (^)(NSString *))failureBlock {

    NSMutableDictionary *realParams = [[UserinfoManager sharedUserinfo] increaseUserParams:nil];
    [realParams addEntriesFromDictionary:@{@"id":self.entrustInfo[index][@"id"], @"type":@((NSInteger)on)}];

    @weakify(self)
    [self postMethod:@"cancelentrust" params:realParams success:^(id result) {
        @strongify(self)
        
        NSMutableDictionary *tmpDic = [self.entrustInfo[index] mutableCopy];
        [tmpDic setValue:@(on ? 1 : 2) forKey:@"isshow"];
        [tmpDic setValue:on ? @"委托中":@"已取消" forKey:@"statusname"];
        [_entrustInfo replaceObjectAtIndex:index withObject:tmpDic];
        
        if (!successBlock) return;
        successBlock(result);
    } failure:^(id result, NSString *errorDescription) {
        
        if (!failureBlock) return;
        failureBlock(errorDescription);
    }];
}

- (NSArray *)allEntrustInfo {
    
    return self.entrustInfo;
}
@end
