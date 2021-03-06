//
//  EntrustViewModel.h
//  YuanXin_Project
//
//  Created by Yuanin on 16/5/3.
//  Copyright © 2016年 yuanxin. All rights reserved.
//

#import "BaseViewModel.h"

typedef NS_ENUM(NSInteger, EntrustType) {
    kEntrustRegular,
    kEntrustOptimization
};

@interface EntrustViewModel : BaseViewModel

@property (assign, nonatomic) EntrustType type;
@property (strong, nonatomic, readonly) NSMutableArray *entrustInfo;
@property (assign, nonatomic, readonly) NSUInteger currentPage;

- (void)beginFetchEntrustWithSuccess:(void(^)(id result)) successBlock failure:(void(^)(NSString *errorDescription)) failureBlock;
- (void)fetchNextPageEntrustWithSuccess:(void(^)(id result)) successBlock failure:(void(^)(NSString *errorDescription)) failureBlock;

- (void)changeEntrustStateWithIndex:(NSInteger)index on:(BOOL)on success:(void(^)(id result)) successBlock failure:(void(^)(NSString *errorDescription)) failureBlock;
@end
