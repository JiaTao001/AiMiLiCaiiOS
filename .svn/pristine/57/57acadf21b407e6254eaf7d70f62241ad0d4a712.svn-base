//
//  ProductViewModel.h
//  YuanXin_Project
//
//  Created by Yuanin on 16/4/20.
//  Copyright © 2016年 yuanxin. All rights reserved.
//

#import "BaseViewModel.h"

#import "ProductInfo.h"

@interface ProductViewModel : BaseViewModel

@property (strong, nonatomic, readonly) NSArray<ProductInfo *> *productInfo;
@property (assign, nonatomic, readonly) NSUInteger currentPage;

- (void)beginFetchProductInfoWithSuccess:(void(^)(id result)) successBlock failure:(void(^)(NSString *errorDescription)) failureBlock;
- (void)fetchNextPageProductInfoWithSuccess:(void(^)(id result)) successBlock failure:(void(^)(NSString *errorDescription)) failureBlock;
@end
