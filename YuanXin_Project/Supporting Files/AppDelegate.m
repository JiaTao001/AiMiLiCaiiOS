//
//  AppDelegate.m
//  YuanXin_Project
//
//  Created by Sword on 15/9/14.
//  Copyright (c) 2015年 yuanxin. All rights reserved.
//

#import "AppDelegate.h"

#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_10_0
#import <UserNotifications/UserNotifications.h>
#endif

#import "AimiTabbarController.h"
#import "GesturePasswordVC.h"
#import "LoginNavigationController.h"

#import "AiMiGuidePage.h"

#import "UserinfoManager.h"
#import "GestureFinishedAnimation.h"

#import <TencentOpenAPI/TencentOAuth.h>
#import "WXApi.h"
//#import "MobClick.h"
#import "UMMobClick/MobClick.h"
#import "UMessage.h"

#import "AiMiAdverView.h"
#import "WebVC.h"
#import "UserTouchIDVC.h"

@interface AppDelegate ()

@property (strong, nonatomic) UIApplicationShortcutItem *shortcutItem;

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    [AiMiApplication initializeApplicationWithOptions:launchOptions];
    
    
    
    [self registerRemoteNotification];
     AiMiAdverView *aimiAdverVC = [[AiMiAdverView alloc]init];
    [NetworkContectManager sessionPOSTWithMothed:@"intro" params:nil success:^(NSURLSessionTask *task, id result) {
        if (result[@"result"] != 0) {
//            AiMiAdverView *aimiAdverVC = [[AiMiAdverView alloc]init];
            aimiAdverVC.data = result[@"data"];
            [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"adverShow"];
            [[NSUserDefaults standardUserDefaults] setObject: result[@"data"][0][@"list"] forKey:@"conList"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            
        }else{
            

        }
        
    } failure:^(NSURLSessionTask *task, id result, NSString *errorDescription) {
        if (result[@"data"]) {
            [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"adverShow"];
            [[NSUserDefaults standardUserDefaults] setObject: result[@"data"][0][@"list"] forKey:@"conList"];
            [[NSUserDefaults standardUserDefaults] synchronize];
        }else{
            [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"adverShow"];
            [[NSUserDefaults standardUserDefaults] synchronize];
        }
        
        
        
    }];

    
    if ([AiMiGuidePage canShow] ) {
        [self chooseTheRootViewControllerWithADIsShow:NO];
 
    }else{
       
        if ([AiMiAdverView canShow]  &&! self.shortcutItem) {
//                    AiMiAdverView *aimiAdverVC = [[AiMiAdverView alloc]init];
                    self.window.rootViewController = aimiAdverVC;
                    [self.window makeKeyAndVisible];
                    aimiAdverVC.completionBlock = ^(BOOL ADIsShow){
                        
                        [self chooseTheRootViewControllerWithADIsShow:ADIsShow];
                   
                    };
                    
                }else{
                    [self chooseTheRootViewControllerWithADIsShow:NO];
            
                }
                
                
        
            
    
            
        }
//    [NetworkContectManager sessionPOSTWithMothed:@"version_ios" params:nil success:^(NSURLSessionTask *task, id result) {
//        [AlertViewManager showInViewController:self.window.rootViewController title:@"提示" message:@"有新版本需要更新，您是否马上去更新" clickedButtonAtIndex:^(id alertView, NSInteger buttonIndex) {
//            if (1 == buttonIndex) {
//                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"itms-apps://itunes.apple.com/app/id1055223837"]];
//            }
//        } cancelButtonTitle:@"暂不更新" otherButtonTitles:@"去更新", nil];
//    } failure:nil];

    NSUserDefaults*shared = [[NSUserDefaults alloc]initWithSuiteName:@"group.com.yuanin.widge"];
    //是否显示widge
    if ([[UserinfoManager sharedUserinfo] logined]) {
       [shared setBool:YES forKey:IS_LOG];
        NSString *amount = [UserinfoManager sharedUserinfo].userInfo.amount;
        [shared setObject:amount forKey:@"amount"];
        NSString *balance = [UserinfoManager sharedUserinfo].userInfo.balance;
        [shared setObject:balance forKey:@"balance"];
        NSString *interest = [UserinfoManager sharedUserinfo].userInfo.interest;
        [shared setObject:interest forKey:@"interest"];
    }else{
          [shared setBool:NO forKey:IS_LOG];
        [shared setObject:nil forKey:@"amount"];
        
        [shared setObject:nil forKey:@"balance"];
        
        [shared setObject:nil forKey:@"interest"];
    }
     [shared synchronize];
    


    return YES;
}

- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application {
    
    [[NSURLCache sharedURLCache] removeAllCachedResponses];
}
- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    
}

- (void)application:(UIApplication *)application performActionForShortcutItem:(UIApplicationShortcutItem *)shortcutItem completionHandler:(void (^)(BOOL))completionHandler
{
    if ([self.window.rootViewController isKindOfClass:[UITabBarController class]]) {
        [(AimiTabBarController *)self.window.rootViewController presentViewControllWithStoryboardID:shortcutItem.type];
    } else {
        self.shortcutItem = shortcutItem;
    }
}

//URL Scheme
- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    
    return [TencentOAuth HandleOpenURL:url];
}

- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url {
    
    return [TencentOAuth HandleOpenURL:url] && [WXApi handleOpenURL:url delegate:Nil];;
}


#pragma mark -  APNS Service
//注册远程通知
- (void)registerRemoteNotification {
    
    if ( SYSTEM_VERSION_GREATER_THAN_10) {
        
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_10_0
        //请求通知权限, 本地和远程共用
        UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
        [center requestAuthorizationWithOptions:UNAuthorizationOptionBadge | UNAuthorizationOptionSound | UNAuthorizationOptionAlert completionHandler:^(BOOL granted, NSError * _Nullable error) {
            NSLog(@"completionHandler");
            
            //注册远程通知
            [[UIApplication sharedApplication] registerForRemoteNotifications];
            
            //设置通知的代理
//            center.delegate = self;

        }];
#endif
    } else if ( SYSTEM_VERSION_GREATER_THAN_8 ) {
        UIUserNotificationType myTypes = UIUserNotificationTypeBadge | UIUserNotificationTypeSound | UIUserNotificationTypeAlert;
        UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:myTypes categories:nil];
        
        [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
        
    } else {
        UIRemoteNotificationType myTypes = UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeSound;
        
        [[UIApplication sharedApplication] registerForRemoteNotificationTypes:myTypes];
    }
}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    // Required
    [UMessage registerDeviceToken:deviceToken];
    NSLog(@"------%@",deviceToken);
    
    if ([[UserinfoManager sharedUserinfo] logined]) {
        [UMessage setAlias:[UserinfoManager sharedUserinfo].userInfo.userid type:UM_Alias_Type response:nil];
    }
}
//iOS 8.0即以上
- (void)application:(UIApplication *)application didRegisterUserNotificationSettings:(UIUserNotificationSettings *)notificationSettings {

    [[UIApplication sharedApplication] registerForRemoteNotifications];
}
- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    
    NSLog(@"%s error -- %@", __func__, error);
}
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    
    if (UIApplicationStateActive != [UIApplication sharedApplication].applicationState) {
        [UMessage didReceiveRemoteNotification:userInfo];
    }
}
//- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
//    
//    // IOS 7 Support Required
//    [APService handleRemoteNotification:userInfo];
//    completionHandler(UIBackgroundFetchResultNewData);
//}


//禁止第三方键盘
- (BOOL)application:(UIApplication *)application shouldAllowExtensionPointIdentifier:(NSString *)extensionPointIdentifier {
    
    return NO;
}

- (void )chooseTheRootViewControllerWithADIsShow:(BOOL )adverIsShow {
    if ([[UserinfoManager sharedUserinfo] logined] && [AiMiApplication haveTouchID]) {
     
        [self touchIDVCWithADIsShow:adverIsShow];
        
    }else if ([[UserinfoManager sharedUserinfo] logined] && [AiMiApplication haveGesturePassword]) {
        
//        GesturePasswordVC *gestureVC = [AiMiApplication obtainControllerForMainStoryboardWithID:GESTURE_PASSWORD_STORYBOARD_ID];
//        gestureVC.type = kGesturePasswordAuth;
//        @weakify(self)
//        [gestureVC setCompletionBlock:^(GesturePasswordVC *vc, GesturePasswordOperationType type) {
//            @strongify(self)
//            
//            self.window.rootViewController = [AiMiApplication obtainControllerForMainStoryboardWithID:NSStringFromClass([AimiTabBarController class])];
//            if (kGesturePasswordOperationSuccess != type) {
//                
//                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(NORMAL_ANIMATION_DURATION * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//                    [self.window.rootViewController presentViewController:[AiMiApplication obtainControllerForStoryboard:LOGIN_STORYBOARD_NAME controller:LOGIN_NAVIGARION_STORYBOARD_ID] animated:YES completion:nil];
//                    
//                });
//            } else {
//                [GestureFinishedAnimation beginAnimationWithView:vc.view slicingY:CGRectGetMidY(vc.markView.frame) complete:^{
//                    if (self.shortcutItem) {
//                        [(AimiTabBarController *)self.window.rootViewController presentViewControllWithStoryboardID:self.shortcutItem.type];
//                    }else if (adverIsShow) {
//                            [(AimiTabBarController *)self.window.rootViewController  presentAdViewController];
//                    }
//                }];
//            }
//        }];
//          self.window.rootViewController = gestureVC;
        [self gestureVCWithADIsShow:adverIsShow isFrometouchID:NO];
//       

    } else {
         self.window.rootViewController =[AiMiApplication obtainControllerForMainStoryboardWithID:NSStringFromClass([AimiTabBarController class])];
        
        if (adverIsShow) {
            [(AimiTabBarController *)self.window.rootViewController  presentAdViewController];

        }
    
    }
    
      [self.window makeKeyAndVisible];
    if ([AiMiGuidePage canShow]) {
        [AiMiGuidePage showWithComplete:^{
            if ([self.window.rootViewController isKindOfClass:[GesturePasswordVC class]]) {
//                [(GesturePasswordVC *)self.window.rootViewController authTouchId];
            }
        }];
    } else {
        
        if ([self.window.rootViewController isKindOfClass:[GesturePasswordVC class]]) {
//            [(GesturePasswordVC *)self.window.rootViewController authTouchId];
        }
        
        
    }
    
   

}
- (void)touchIDVCWithADIsShow:(BOOL )adverIsShow{
    UserTouchIDVC *touchIDVC = [AiMiApplication obtainControllerForMainStoryboardWithID:@"UserTouchIDVC"];
    touchIDVC.callBack = ^(NSInteger i){
        switch (i) {
            case 0:
                self.window.rootViewController = [AiMiApplication obtainControllerForMainStoryboardWithID:NSStringFromClass([AimiTabBarController class])];
                if (self.shortcutItem) {
                    [(AimiTabBarController *)self.window.rootViewController presentViewControllWithStoryboardID:self.shortcutItem.type];
                }else if (adverIsShow) {
                    [(AimiTabBarController *)self.window.rootViewController  presentAdViewController];
                }
                break;
            case 1:
                self.window.rootViewController = [AiMiApplication obtainControllerForMainStoryboardWithID:NSStringFromClass([AimiTabBarController class])];
                [self.window.rootViewController presentViewController:[AiMiApplication obtainControllerForStoryboard:LOGIN_STORYBOARD_NAME controller:LOGIN_NAVIGARION_STORYBOARD_ID] animated:YES completion:nil];
                break;
            case 2:
                [self gestureVCWithADIsShow:adverIsShow isFrometouchID:YES];
                break;
            default:
                break;
        } 
        
    };
    self.window.rootViewController = touchIDVC;
    [self.window makeKeyAndVisible];

}
- (void)gestureVCWithADIsShow:(BOOL )adverIsShow isFrometouchID:(BOOL)isfromTouchID{
            GesturePasswordVC *gestureVC = [AiMiApplication obtainControllerForMainStoryboardWithID:GESTURE_PASSWORD_STORYBOARD_ID];
            gestureVC.type = kGesturePasswordAuth;
            gestureVC.isformTouchID = isfromTouchID;
            gestureVC.touchID = ^() {
               [self touchIDVCWithADIsShow:adverIsShow];
             };
            @weakify(self)
            [gestureVC setCompletionBlock:^(GesturePasswordVC *vc, GesturePasswordOperationType type) {
                @strongify(self)
               
    
                self.window.rootViewController = [AiMiApplication obtainControllerForMainStoryboardWithID:NSStringFromClass([AimiTabBarController class])];
                if (kGesturePasswordOperationSuccess != type) {
    
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(NORMAL_ANIMATION_DURATION * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        [self.window.rootViewController presentViewController:[AiMiApplication obtainControllerForStoryboard:LOGIN_STORYBOARD_NAME controller:LOGIN_NAVIGARION_STORYBOARD_ID] animated:YES completion:nil];
    
                    });
                } else {
//                    [GestureFinishedAnimation beginAnimationWithView:vc.view slicingY:CGRectGetMidY(vc.markView.frame) complete:^{
                        if (self.shortcutItem) {
                            [(AimiTabBarController *)self.window.rootViewController presentViewControllWithStoryboardID:self.shortcutItem.type];
                        }else if (adverIsShow) {
                                [(AimiTabBarController *)self.window.rootViewController  presentAdViewController];
                        }
//                    }];
                }
             
            }];
              self.window.rootViewController = gestureVC;
             [self.window makeKeyAndVisible];
}


#pragma mark - getter
- (UIWindow *)window {
    if (!_window) {
        UIWindow *window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
        window.backgroundColor = Background_Color;
//        window.tintColor = [UIColor blackColor];
        
        _window = window;
    }
    return _window;
}

@end
