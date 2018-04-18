//
//  PropertyViewModel.m
//  YuanXin_Project
//
//  Created by Yuanin on 15/10/29.
//  Copyright © 2015年 yuanxin. All rights reserved.
//

#import "PropertyViewModel.h"

@interface PropertyViewModel()

@property (assign, nonatomic, readwrite) NSInteger page;
@property (strong, nonatomic, readwrite) NSMutableArray<PropertyInfo *> *propertyInfo;
@end

@implementation PropertyViewModel

- (instancetype)init {
    if (self = [super init]) {
        self.page = 0;
    }
    return self;
}

- (NSURLSessionTask *)fetchPropertyInfoWithParams:(NSDictionary *)params refresh:(BOOL)refresh result:( void(^)(id result, BOOL success, NSString *errorDescription))resultBlock {
    
    NSMutableDictionary *paramete = [[UserinfoManager sharedUserinfo] increaseUserParams:params];
    
    [paramete setValue:@(Each_Page_Num) forKey:Key_Pagety];
    [paramete setValue:@(refresh ? 1:self.page + 1) forKey:Key_Page];
    
    @weakify(self)
    return [NetworkContectManager sessionPOSTWithMothed:@"getinvestprojectlist" params:paramete success:^(NSURLSessionTask *task, id result) {
        @strongify(self)
        
        if (refresh) {
            [self.propertyInfo removeAllObjects];
            self.page = 1;
        } else {
            self.page++;
        }
        @autoreleasepool {
            for (NSDictionary *aDic in result[RESULT_DATA]) {
                [self.propertyInfo addObject:[PropertyInfo propertyInfoWithDictionary:aDic]];
            }
        }
        resultBlock(result, YES, nil);
    } failure:^(NSURLSessionTask *task, id result, NSString *errorDescription) {
        
        resultBlock(nil, NO, errorDescription);
    }];
}


- (NSArray<PropertyInfo *> *)allPropertyInfo {
    
    return self.propertyInfo;
}
- (NSMutableArray<PropertyInfo *> *)propertyInfo {
    
    if (!_propertyInfo) {
        _propertyInfo = [NSMutableArray array];
    }
    return _propertyInfo;
}
@end
