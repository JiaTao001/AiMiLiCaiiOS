//
//  TransactionRecordsViewModel.h
//  YuanXin_Project
//
//  Created by Yuanin on 15/10/28.
//  Copyright © 2015年 yuanxin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TransactionRecordsInfo.h"

//userid（用户id）、mobile（手机号码）、timetype（0表示不限、1表示7天以内、2表示1个月以内、3表示3个月以内、4表示6个月以内、5表示一年以内、6表示一年以外）、fundtype（类型 0表示所有、1表示购买定期、2表示充值、3表示体现）、status（状态；0表示不限、1表示已完成，2表示未完成）、pageqty（每页显示数量）、currentpage（当前索引页

#define KEY_TIMETYPE @"timetype"
#define KEY_FUNDTYPE @"fundtype"
#define KEY_STATES   @"status"
#define KEY_PAGETY   @"pageqty"
#define KEY_PAGE     @"currentpage"

@interface TransactionRecordsViewModel : NSObject

//@property (strong, nonatomic, readonly) NSMutableArray<TransactionRecordsInfo *> *allTransactionRecordsInfo;
@property (strong, nonatomic, readonly) NSMutableArray *allTransactionRecordsInfo;


- (NSURLSessionTask *)fetchTransactionRecordsInfoWithParams:(NSDictionary *)params refresh:(BOOL)refresh result:( void(^)(id result, BOOL success, NSString *errorDescription))resultBlock;
@end
