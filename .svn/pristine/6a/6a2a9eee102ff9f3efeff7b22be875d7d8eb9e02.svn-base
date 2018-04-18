//
//  PropertyViewModel.h
//  YuanXin_Project
//
//  Created by Yuanin on 15/10/29.
//  Copyright © 2015年 yuanxin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PropertyInfo.h"

//2.2 getinvestprojectlist（用户购买理财项目列表）=>userid（用户id）、mobile（手机号码）、type（类型；0表示爱米定期；1表示爱米优选）、status（状态；1表示进行中；2表示募集中；3表示已流标；4表示已还款）、pageqty（每页显示数量）、currentpage（当前索引页）

#define Key_Status @"status"
#define Key_Pagety @"pageqty"
#define Key_Page   @"currentpage"
#define Key_Type   @"type"

@interface PropertyViewModel : NSObject

@property (strong, nonatomic, readonly) NSMutableArray<PropertyInfo *> *allPropertyInfo;

- (NSURLSessionTask *)fetchPropertyInfoWithParams:(NSDictionary *)params refresh:(BOOL)refresh result:( void(^)(id result, BOOL success, NSString *errorDescription))resultBlock;
@end
