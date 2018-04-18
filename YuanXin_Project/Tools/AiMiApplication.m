//
//  AiMiApplication.m
//  wujin-tourist
//
//  Created by wujin  on 15/7/9.
//  Copyright (c) 2015年 wujin. All rights reserved.
//

#import "AiMiApplication.h"

#import "TCKeychain.h"
#import <TencentOpenAPI/TencentOAuth.h>
#import "WXApi.h"
//#import "MobClick.h"
#import <LocalAuthentication/LocalAuthentication.h>
#import "UMMobClick/MobClick.h"
#import "UMessage.h"

@implementation AiMiApplication

+ (void)initializeApplicationWithOptions:(NSDictionary *)launchOptions {
    
    [[UINavigationBar appearance] setTitleTextAttributes:@{ NSFontAttributeName:[UIFont systemFontOfSize:18], NSForegroundColorAttributeName:[UIColor whiteColor]}];
    [USERDEFAULTS registerDefaults:@{ DID_OPEN_GESTURE: @NO, DID_OPEN_TOUCHID: @NO}];
    
    if ([self lastVersionNotEqualCurrentVersion]) {
        
        if ([self isNewInstall]) {
            [USERDEFAULTS setBool:YES forKey:Need_Guide_Page];
            [[UserinfoManager sharedUserinfo] logout];
        } else {
            [USERDEFAULTS setBool:[[NSBundle mainBundle].infoDictionary[APP_GUIDE_PAGE_KEY] boolValue] forKey:Need_Guide_Page];
        }
        
        [self clearOldVersionData];
        //此方法使用了 [USERDEFAULTS synchronize]
        [self updateAppLasestVersion];
    }

#if !TARGET_OS_SIMULATOR
    //UMeng register
//    [MobClick startWithAppkey:PreDefM_UM];
    UMConfigInstance.appKey = PreDefM_UM;
    [MobClick startWithConfigure:UMConfigInstance];
    [MobClick setAppVersion:[NSBundle mainBundle].infoDictionary[APP_VERSION_KEY]];
    [UMessage startWithAppkey:PreDefM_UM launchOptions:launchOptions httpsenable:YES];
    //打开日志，方便调试
    [UMessage setLogEnabled:YES];
   
    //QQ register
    SUPPRESS_PERFORM_SELECTOR_UNUSED_WARNING(   [[TencentOAuth alloc] initWithAppId:PreDefM_QQAPPID andDelegate:nil]    )
    //wechat register
    [WXApi registerApp:PreDefM_WXAPPID];
#endif
}

+ (id)obtainControllerForStoryboard:(NSString *)name controller:(NSString *)VCIdentity {
    NSParameterAssert(VCIdentity);
    
    if (nil == name || nil == VCIdentity) {
        return nil;
    } else {
        
        return [[UIStoryboard storyboardWithName:name bundle:nil] instantiateViewControllerWithIdentifier:VCIdentity];
    }
}

+ (nullable id)obtainControllerForMainStoryboardWithID:(NSString *)VCIdentity {
    
    return [self obtainControllerForStoryboard:@"Main" controller:VCIdentity];
}

+ (BOOL)haveGesturePassword {
    
    if ([USERDEFAULTS boolForKey:DID_OPEN_GESTURE]) {
        
        return [[TCKeychain load:KEY_USER_INFO][KEY_USER_GESTUREPASSWORD] length];
    } else {
        return NO;
    }
}
+ (BOOL)haveTouchID {
    
    if ([USERDEFAULTS boolForKey:DID_OPEN_TOUCHID] && [[[LAContext alloc] init] canEvaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics error:nil]) {
        
        return YES;
        
    } else {
        return NO;
    }
}

+ (NSString *)pathForCachesWithFileName:(NSString *)fileName {
    
    return [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject] stringByAppendingPathComponent:fileName];;
}

+ (BOOL)isBigScreen {
    
    return [UIScreen mainScreen].bounds.size.width > 320;
}

+ (BOOL)isNewInstall {
    
    return ![USERDEFAULTS objectForKey:VERSION_KEY];
}
+ (BOOL)lastVersionNotEqualCurrentVersion {
    
    return ![[USERDEFAULTS objectForKey:VERSION_KEY] isEqualToString:[NSBundle mainBundle].infoDictionary[APP_VERSION_KEY]];
}

+ (void)clearOldVersionData {
    
    [[NSFileManager defaultManager] removeItemAtPath:[AiMiApplication pathForCachesWithFileName:bannerPath] error:nil];
    [[NSFileManager defaultManager] removeItemAtPath:[AiMiApplication pathForCachesWithFileName:recommendPath] error:nil];
    [[NSFileManager defaultManager] removeItemAtPath:[AiMiApplication pathForCachesWithFileName:productsPath] error:nil];
    
    [[NSURLCache sharedURLCache] removeAllCachedResponses];
}
+ (void)updateAppLasestVersion {
    
    [USERDEFAULTS setObject:[NSBundle mainBundle].infoDictionary[APP_VERSION_KEY] forKey:VERSION_KEY];
    [USERDEFAULTS synchronize];
}

@end
