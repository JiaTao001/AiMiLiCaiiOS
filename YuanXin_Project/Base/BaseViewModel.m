//
//  BaseViewModel.m
//  YuanXin_Project
//
//  Created by Yuanin on 16/3/24.
//  Copyright © 2016年 yuanxin. All rights reserved.
//

#import "BaseViewModel.h"

@implementation BaseViewModel

- (void)postMethod:(NSString *)method params:(NSDictionary *)params success:(void(^)(id result))successBlock failure:(void(^)(id result, NSString *errorDescription))failureBlock
{
    [self cancelFetchOperation];
    _task = [NetworkContectManager sessionPOSTWithMothed:method params:params success:^(NSURLSessionTask *task, id result) {
        
        !successBlock ? : successBlock(result);
    } failure:^(NSURLSessionTask *task, id result, NSString *errorDescription) {
        
        !failureBlock ? : failureBlock(nil, errorDescription);
    }];
}

- (NSURLSessionTask *)task
{
    return _task;
}

- (void)cancelFetchOperation
{
    if (NSURLSessionTaskStateRunning != _task.state) return;
    [_task cancel];
}
@end
