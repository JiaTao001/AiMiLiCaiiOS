//
//  NetworkContectManager.h
//  YuanXin_Project
//
//  Created by Yuanin on 15/10/16.
//  Copyright © 2015年 yuanxin. All rights reserved.
//

#import <Foundation/Foundation.h>

/////////////////////////////////////////URL
#ifdef DEBUG
 #define hostUrl @"http://csapi.yuanin.com/"
//#define hostUrl @"https://wcapi.aimilicai.com/"
//#define hostUrl @"https://shapi.aimilicai.com/"

//      #define hostUrl @"https://apk.aimilicai.com/"
#else
//    #define hostUrl @"https://apk.aimilicai.com/"
//      #define hostUrl @"https://apk.aimilicai.com/"
     #define hostUrl @"https://shapi.aimilicai.com/"
#endif
/////////////////////////////////////////URL


//返回的信息
#define REQUEST_SUCCESS_CODE 1

#define RESULT_DATA   @"data"
#define RESULT_RESULT @"result"
#define RESULT_REMARK @"remark"


@interface NetworkContectManager : NSObject

+ (NSURLSessionTask *)sessionPOSTWithMothed:(NSString *)mothed params:(NSDictionary *)params success:( void(^)(NSURLSessionTask *task, id result) )success failure:( void(^)(NSURLSessionTask *task, id result, NSString *errorDescription) )failure;
@end





