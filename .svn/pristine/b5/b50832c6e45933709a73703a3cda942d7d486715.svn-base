//
//  TransactionRecordsViewModel.m
//  YuanXin_Project
//
//  Created by Yuanin on 15/10/28.
//  Copyright © 2015年 yuanxin. All rights reserved.
//

#import "TransactionRecordsViewModel.h"

@interface TransactionRecordsViewModel()

@property (assign, nonatomic, readwrite) NSInteger page;
@property (strong, nonatomic, readwrite) NSMutableArray *transactionRecordsInfo;
@end

@implementation TransactionRecordsViewModel

- (instancetype)init {
    if (self = [super init]) {
        self.page = 0;
    }
    return self;
}

- (NSURLSessionTask *)fetchTransactionRecordsInfoWithParams:(NSDictionary *)params refresh:(BOOL)refresh result:( void(^)(id result, BOOL success, NSString *errorDescription))resultBlock {
    
//userid（用户id）、mobile（手机号码）、timetype（0表示不限、1表示7天以内、2表示1个月以内、3表示3个月以内、4表示6个月以内、5表示一年以内、6表示一年以外）、status（状态；0表示不限、1表示已完成，2表示未完成）、pageqty（每页显示数量）、currentpage（当前索引页）
    
    NSMutableDictionary *paramete = [[NSMutableDictionary alloc] initWithDictionary:params];
    
    [paramete addEntriesFromDictionary:[[UserinfoManager sharedUserinfo] increaseUserParams:nil]];
    [paramete setValue:@(Each_Page_Num) forKey:KEY_PAGETY];
    [paramete setValue:@(refresh ? 1:self.page + 1) forKey:KEY_PAGE];
    
    @weakify(self)
    return [NetworkContectManager sessionPOSTWithMothed:@"fundlog_new" params:paramete success:^(NSURLSessionTask *task, id result) {
        @strongify(self)
        
        if (refresh) {
            [self.transactionRecordsInfo removeAllObjects];
            self.page = 1;
        } else {
            self.page++;
        }
        @autoreleasepool {
            for (NSDictionary *aDic in result[RESULT_DATA]) {
                if ([aDic[@"year"] isEqualToString:[self.transactionRecordsInfo lastObject][@"year"]]) {
                    
                    NSMutableArray *arr = [NSMutableArray arrayWithArray:[self.transactionRecordsInfo lastObject][@"list"]];
                    [self.transactionRecordsInfo removeLastObject];
                    [arr addObjectsFromArray:aDic[@"list"]];
                    NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:aDic[@"year"],@"year",arr,@"list", nil];
                      [self.transactionRecordsInfo addObject:dict];
                }else{
                
                     [self.transactionRecordsInfo addObject:aDic];
                }
            }
        }
        resultBlock(result, YES, nil);
    } failure:^(NSURLSessionTask *task, id result, NSString *errorDescription) {
        
        resultBlock(nil, NO, errorDescription);
    }];
}

- (NSArray *)allTransactionRecordsInfo {
    
    return self.transactionRecordsInfo;
}
- (NSMutableArray *)transactionRecordsInfo {
    
    if (!_transactionRecordsInfo) {
        _transactionRecordsInfo = [NSMutableArray array];
    }
    return _transactionRecordsInfo;
}
@end
