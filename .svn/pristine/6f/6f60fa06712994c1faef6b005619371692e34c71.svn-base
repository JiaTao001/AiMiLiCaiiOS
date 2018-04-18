//
//  AccumulatedIncomeViewModel.m
//  YuanXin_Project
//
//  Created by Yuanin on 15/10/29.
//  Copyright © 2015年 yuanxin. All rights reserved.
//

#import "AccumulatedIncomeViewModel.h"

@interface AccumulatedIncomeViewModel ()

@property (assign, nonatomic, readwrite) NSInteger page;
@property (strong, nonatomic, readwrite) NSMutableArray<AccumulatedIncomeInfo *> *incomeInfo;
@end

@implementation AccumulatedIncomeViewModel

- (instancetype)init {
    if (self = [super init]) {
        
        _page = 0;
    }
    return self;
}

- (NSURLSessionTask *)fetchAccumulatedIncomeInfoWithParams:(NSDictionary *)params refresh:(BOOL)refresh result:( void(^)(id result, BOOL success, NSString *errorDescription))resultBlock {
        
    NSMutableDictionary *paramete = [[UserinfoManager sharedUserinfo] increaseUserParams:params];
    
    [paramete setValue:@(Each_Page_Num) forKey:KEY_PAGETY];
    [paramete setValue:@(refresh ? 1:self.page + 1) forKey:KEY_PAGE];
    
    @weakify(self)
    return [NetworkContectManager sessionPOSTWithMothed:@"getuseraccumulatedincome" params:paramete success:^(NSURLSessionTask *task, id result) {
        @strongify(self)
        
        if (refresh) {
            [self.incomeInfo removeAllObjects];
            self.page = 1;
        } else {
            self.page++;
        }
        @autoreleasepool {
            for (NSDictionary *aDic in result[RESULT_DATA]) {
                [self.incomeInfo addObject:[AccumulatedIncomeInfo accumulatedIncomeInfoWithDictionary:aDic]];
            }
        }
        resultBlock(result, YES, nil);
    } failure:^(NSURLSessionTask *task, id result, NSString *errorDescription) {
        
        resultBlock(nil, NO, errorDescription);
    }];
}

- (NSArray<AccumulatedIncomeInfo *> *)allIncomeInfo {
    
    return self.incomeInfo;
}
- (NSMutableArray<AccumulatedIncomeInfo *> *)incomeInfo {
    
    if (!_incomeInfo) {
        _incomeInfo = [NSMutableArray array];
    }
    return _incomeInfo;
}
@end
