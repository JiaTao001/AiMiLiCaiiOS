//
//  CreatePresetParamete.h
//  YuanXin_Project
//
//  Created by Yuanin on 15/10/23.
//  Copyright © 2015年 yuanxin. All rights reserved.
//

#import <Foundation/Foundation.h>

//提交的固定key
#define MODULE  @"module"
#define MOTHED  @"mothed"
#define APP_ID  @"appid"
#define APP_KEY @"key"
#define Login_Token @"login_token"

@interface CreatePresetParamete : NSObject

+ (NSDictionary *)createPresetParmete:(NSString *)key;
@end
