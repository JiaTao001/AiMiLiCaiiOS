//
//  BaseViewModel.h
//  YuanXin_Project
//
//  Created by Yuanin on 16/3/24.
//  Copyright © 2016年 yuanxin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BaseViewModel : NSObject {
    
    NSURLSessionTask *_task;
}

@property (strong, nonatomic, readonly) NSURLSessionTask *task;

- (void)postMethod:(NSString *)method params:(NSDictionary *)params success:(void(^)(id result))successBlock failure:(void(^)(id result, NSString *errorDescription))failureBlock;
- (void)cancelFetchOperation;
@end
