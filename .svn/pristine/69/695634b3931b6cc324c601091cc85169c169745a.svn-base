//
//  CreatePresetParamete.m
//  YuanXin_Project
//
//  Created by Yuanin on 15/10/23.
//  Copyright © 2015年 yuanxin. All rights reserved.
//

#import "CreatePresetParamete.h"
#import "UserinfoManager.h"
#import "Userinfo.h"
#define PRESET_PARMETE_FILE_NAME @"PresetParamete.plist"



@implementation CreatePresetParamete

+ (NSDictionary *)createPresetParmete:(NSString *)key {
    NSParameterAssert(key);
    
    static NSDictionary *presetParamete = nil;
    static dispatch_once_t once;
    static NSMutableDictionary *result = nil;
    
    dispatch_once(&once, ^{
        
        presetParamete = [[NSDictionary alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:PRESET_PARMETE_FILE_NAME ofType:nil]];
        result = [[NSMutableDictionary alloc] init];
        [result setValue:[NSBundle mainBundle].infoDictionary[APP_ID] forKey:APP_ID];
        [result setValue:[NSBundle mainBundle].infoDictionary[APP_KEY] forKey:APP_KEY];
       
        [result setValue:[NSBundle mainBundle].infoDictionary[APP_VERSION_KEY] forKey:@"version_num"];
    });
     [result setValue:[UserinfoManager sharedUserinfo].userInfo.login_token forKey:Login_Token];
    
    [result setValue:presetParamete[key][MODULE] forKey:MODULE];
    [result setValue:presetParamete[key][MOTHED] forKey:MOTHED];

    return result;
}
@end
