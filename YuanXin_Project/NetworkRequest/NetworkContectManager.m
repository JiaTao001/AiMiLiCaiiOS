//
//  NetworkContectManager.m
//  YuanXin_Project
//
//  Created by Yuanin on 15/10/16.
//  Copyright © 2015年 yuanxin. All rights reserved.
//

#import "NetworkContectManager.h"

#import "AFNetworking.h"
#import "JSONKit.h"
#import "CreatePresetParamete.h"
#import "UserinfoManager.h"
//需要的信息
#define TOKEN_KEY @"token"


//static NSString * const kCharactersToBeEscapedInQueryString = @":/?&=;+!@#$()',*";
//
//static NSString *stringWithEncoding(NSString *string, NSStringEncoding encoding) {
//    return (__bridge_transfer  NSString *)CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault, (__bridge CFStringRef)string, NULL, (__bridge CFStringRef)kCharactersToBeEscapedInQueryString, CFStringConvertNSStringEncodingToEncoding(encoding));
//}

@interface AFHTTPSessionManager (FixdLeaks)<UIAlertViewDelegate>

+ (AFHTTPSessionManager *)fl_sharedHTTPSession;
@end

@implementation AFHTTPSessionManager (FixdLeaks)

+ (AFHTTPSessionManager *)fl_sharedHTTPSession
{
    static AFHTTPSessionManager *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [AFHTTPSessionManager manager];
    });
    return manager;
}

@end


@implementation NetworkContectManager

//备用方式
//    NSMutableDictionary *calculateDic = [NSMutableDictionary dictionaryWithDictionary:params];
//    NSDictionary *appDic = [NSBundle mainBundle].infoDictionary;
//
//    [calculateDic setValue:appDic[APP_ID] forKey:APP_ID];
//    [calculateDic setValue:appDic[APP_KEY] forKey:APP_KEY];
//
//    AFHTTPRequestOperationManager *requestManager = [AFHTTPRequestOperationManager manager];
//
//    NSString *md5Str = [self calculationMD5Token:params];
//    NSString *token = [AiMiApplication MD5Encryption:md5Str];
//
//    NSMutableDictionary *realParams = [NSMutableDictionary dictionaryWithDictionary:params];
//    [realParams removeObjectForKey:@"key"];
//    [realParams setValue:token forKey:TOKEN_KEY];
//
//    NSDictionary *parameters = @{@"obj": [realParams JSONString]/*[JSONDecoder decoderWithParseOptions:NSUTF8StringEncoding]*/};
//
//    NSLog(@"params -- %@. token -- %@", parameters, token);
//
//自带方式
//    NSMutableURLRequest *req = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:hostUrl]];
//    [req setHTTPMethod:@"POST"];
//
//    NSString *str = [[NSString alloc] initWithFormat:@"%@=%@", @"obj", [realParams JSONString]];
//    [req setHTTPBody:[str dataUsingEncoding:NSUTF8StringEncoding]];
//
//    NSData *response = [NSURLConnection sendSynchronousRequest:req returningResponse:nil error:nil];
//
//    NSLog(@"data -- %@", [[JSONDecoder decoder] objectWithData:response]);

+ (NSURLSessionTask *)sessionPOSTWithMothed:(NSString *)mothed params:(NSDictionary *)params success:( void(^)(NSURLSessionTask *task, id result) )success failure:( void(^)(NSURLSessionTask *task, id result, NSString *errorDescription) )failure {
        
    return [[AFHTTPSessionManager fl_sharedHTTPSession] POST:hostUrl parameters:[self prepareParamsWithMethed:mothed oldParams:params] progress:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        NSLog(@"POST:URL:%@  MOTHED:%@ %@",hostUrl,mothed,[self prepareParamsWithMethed:mothed oldParams:params]);
         NSLog(@"MOTHED:%@  RESULT:%@  ",mothed, responseObject);
        
        [self parseResult:responseObject operation:task success:success failure:failure];
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"error---%@",error);
        
        if (failure) failure(task, nil, (-999 == error.code || -1005 == error.code ) ? nil : NSLocalizedString(@"err_network", nil));
    }];
}


+ (void)parseResult:(id)result operation:(__kindof NSObject *)operation success:( void(^)(__kindof NSObject *operation,id result) )success failure:( void(^)(__kindof NSObject *operation, id result, NSString *errorDescription) )failure {
    if (400 == [result[RESULT_RESULT] intValue]) {
          UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:result[@"remark"] message:nil delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alertView dismissWithClickedButtonIndex:0 animated:YES];
         [[UserinfoManager sharedUserinfo] logout];
        [alertView show];
        
        
    }
    
    if ((REQUEST_SUCCESS_CODE == [result[RESULT_RESULT] intValue]) && success) {
        success(operation, result);
    }  else if (failure) {
        failure(operation, result, result[RESULT_REMARK]);
    }
}

+ (NSDictionary *)prepareParamsWithMethed:(NSString *)method oldParams:(NSDictionary *)oldParams {
    
    NSParameterAssert(method);
    
    NSMutableDictionary *result = [NSMutableDictionary dictionaryWithDictionary:oldParams];
    [result addEntriesFromDictionary:[CreatePresetParamete createPresetParmete:method]];
    
    NSString *token = [[self calculationMD5Token:result] MD5Encryption];
    
    [result removeObjectForKey:APP_KEY];
    [result setValue:token forKey:TOKEN_KEY];
        
    return @{@"obj": Dislodge_Nil_String([result JSONString])/*[JSONDecoder decoderWithParseOptions:NSUTF8StringEncoding]*/};
}
+ (NSString *)calculationMD5Token:(id)params {

    NSMutableString *md5Str = [[NSMutableString alloc] init];
    
    NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"description" ascending:YES selector:@selector(compare:)];
    
    if ([params isKindOfClass:[NSDictionary class]]) {
        NSDictionary *dictionary = params;
        // Sort dictionary keys to ensure consistent ordering in query string, which is important when deserializing potentially ambiguous sequences, such as an array of dictionaries
        for (id nestedKey in [dictionary.allKeys sortedArrayUsingDescriptors:@[ sortDescriptor ]]) {
            id nestedValue = [dictionary objectForKey:nestedKey];
            if (nestedValue) {
                
                [md5Str appendFormat:@"%@", [self calculationMD5Token:nestedValue]];
            }
        }
    } else if ([params isKindOfClass:[NSArray class]]) {
        NSArray *array = params;
        for (id nestedValue in array) {
            
            [md5Str appendFormat:@"%@", [self calculationMD5Token:nestedValue]];
        }
    } else if ([params isKindOfClass:[NSSet class]]) {
        NSSet *set = params;
        for (id nestedValue in [set sortedArrayUsingDescriptors:@[ sortDescriptor ]]) {
            
            [md5Str appendFormat:@"%@", [self calculationMD5Token:nestedValue]];
        }
    } else {
        [md5Str appendFormat:@"%@",params];
    }
    
    return md5Str;
}

@end


