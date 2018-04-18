//
//  AccumulatedIncomeViewModel.h
//  YuanXin_Project
//
//  Created by Yuanin on 15/10/29.
//  Copyright © 2015年 yuanxin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AccumulatedIncomeInfo.h"

#define KEY_STATUS @"type"       //0 表示待收，1表示已收
#define KEY_PAGETY @"pageqty"
#define KEY_PAGE   @"currentpage"

@interface AccumulatedIncomeViewModel : NSObject

@property (strong, nonatomic, readonly) NSArray<AccumulatedIncomeInfo *> *allIncomeInfo;

- (NSURLSessionTask *)fetchAccumulatedIncomeInfoWithParams:(NSDictionary *)params refresh:(BOOL)refresh result:( void(^)(id result, BOOL success, NSString *errorDescription))resultBlock;
@end
