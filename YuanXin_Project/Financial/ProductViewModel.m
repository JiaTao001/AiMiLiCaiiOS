//
//  ProductViewModel.m
//  YuanXin_Project
//
//  Created by Yuanin on 16/4/20.
//  Copyright © 2016年 yuanxin. All rights reserved.
//

#import "ProductViewModel.h"

@interface ProductViewModel()

@property (strong, nonatomic, readwrite) NSMutableArray<ProductInfo *> *productInfo;
@property (assign, nonatomic, readwrite) NSUInteger currentPage;
@end

@implementation ProductViewModel
@synthesize productInfo = _productInfo;

- (instancetype)init {
    self = [super init];
    
    if (self) {
        _currentPage = 0;
    }
    return self;
}

- (void)fetchProductInfoWithPage:(NSUInteger)page success:(void(^)(id result)) successBlock failure:(void(^)(NSString *errorDescription)) failureBlock {
    
    @weakify(self)
    [self postMethod:@"getnewproductlist" params:@{@"type":@"3", @"pageqty":@(Each_Page_Num), @"currentpage":@(page)}  success:^(id result) {
        @strongify(self)
        
        self.currentPage = page;
        if (!successBlock) return;
        successBlock(result);
    } failure:^(id result, NSString *errorDescription) {
        
        if (!failureBlock) return;
        failureBlock(errorDescription);
    }];
}

- (void)beginFetchProductInfoWithSuccess:(void(^)(id result)) successBlock failure:(void(^)(NSString *errorDescription)) failureBlock {
    
    @weakify(self)
    [self fetchProductInfoWithPage:1 success:^(id result) {
        @strongify(self)
        
        self.productInfo = [self createNewInfoByArray:result[RESULT_DATA]];
        if (!successBlock) return;
        successBlock(result);
    } failure:failureBlock];
}
- (void)fetchNextPageProductInfoWithSuccess:(void(^)(id result)) successBlock failure:(void(^)(NSString *errorDescription)) failureBlock {
    
    @weakify(self)
    [self fetchProductInfoWithPage:_currentPage + 1 success:^(id result) {
        @strongify(self)
        
        [_productInfo addObjectsFromArray:[self createNewInfoByArray:result[RESULT_DATA]]];
        if (!successBlock) return;
        successBlock(result);
    } failure:failureBlock];
}

- (NSMutableArray<ProductInfo *> *)createNewInfoByArray:(NSArray *)newInfo {
//     返回list  id（理财项目id）、title（理财项目名称）、unit（单位《天/个月》）、annual（年化收益率）、term（期限）、amount（可购金额）、guarantee_method（担保方式）、repay_method（还款方式）、statusname（状态名称）、isbuy（是否可以购买《1表示可购买；0表示不可购买》）、type（类型《1表示定期；2表示新手标；3表示优选》）
    NSMutableArray *result = [[NSMutableArray alloc] init];
    
    for (NSDictionary *aDic in newInfo) {
        [result addObject:[ProductInfo productInfoWithDictionary:aDic]];
    }
    
    return result;
}

- (void)setProductInfo:(NSMutableArray<ProductInfo *> *)productInfo {
    _productInfo = productInfo;
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        [NSKeyedArchiver archiveRootObject:productInfo toFile:[AiMiApplication pathForCachesWithFileName:productsPath]];
    });
}
- (NSArray<ProductInfo *> *)productInfo {
    
    if (nil == _productInfo) {
        _productInfo = [NSKeyedUnarchiver unarchiveObjectWithFile:[AiMiApplication pathForCachesWithFileName:productsPath]];
    }
    return _productInfo;
}

@end
