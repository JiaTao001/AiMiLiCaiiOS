//
//  SinaWebVC.h
//  YuanXin_Project
//
//  Created by Yuanin on 16/7/6.
//  Copyright © 2016年 yuanxin. All rights reserved.
//

#import "WebVC.h"

@interface SinaWebVC : WebVC

+ (UINavigationController *)sinaWebWithServerPath:(NSString *)serverPath params:(NSDictionary *)params;
+ (UINavigationController *)sinaWebWithServerPath:(NSString *)serverPath params:(NSDictionary *)params success:(void(^)())success;
+ (UIViewController *)sinaWebVCWithServerPath:(NSString *)serverPath params:(NSDictionary *)params success:(void(^)())success;
@end
