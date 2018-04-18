//
//  RecommendProductViewModel.h
//  YuanXin_Project
//
//  Created by Yuanin on 16/4/19.
//  Copyright © 2016年 yuanxin. All rights reserved.
//

#import "BaseViewModel.h"

#import "RecommendProductInfo.h"

@interface RecommendProductViewModel : BaseViewModel

@property (strong, nonatomic, readonly) NSArray<RecommendProductInfo *> *recommendProductInfo;

- (void)fetchRecommendProductInfoWithSuccess:(void(^)(id result)) successBlock failure:(void(^)(NSString *errorDescription)) failureBlock;
@end
