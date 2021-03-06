//
//  AimiTabBarController.m
//  YuanXin_Project
//
//  Created by Yuanin on 16/9/23.
//  Copyright © 2016年 yuanxin. All rights reserved.
//

#import "AimiTabBarController.h"

#import "AuthenticationVC.h"
#import "RuleWebVC.h"
#import "WebVC.h"
#import "AiMiAdverView.h"

@interface AimiTabBarController ()

@end

@implementation AimiTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.tabBar.tintColor = Theme_Color;
    
}
- (void) presentAdViewController{
    if ([self.selectedViewController isKindOfClass:[UINavigationController class]]) {
        
        [(UINavigationController *)self.selectedViewController pushViewController:[WebVC webVCWithWebPath: [USERDEFAULTS objectForKey:@"adverImageHref"] ] animated:YES];
    } else {
        UINavigationController *nv = [[UINavigationController alloc] initWithRootViewController:[WebVC webVCWithWebPath: [USERDEFAULTS objectForKey:@"adverImageHref"] ]];
        [self presentViewController:nv animated:YES completion:nil];
    }
}

- (void)presentViewControllWithStoryboardID:(NSString *)storyboardID
{
    if ([self.selectedViewController isKindOfClass:[UINavigationController class]]) {
        
        [(UINavigationController *)self.selectedViewController pushViewController:[self presentViewControll:storyboardID] animated:YES];
    } else {
        UINavigationController *nv = [[UINavigationController alloc] initWithRootViewController:[self presentViewControll:storyboardID]];
        [self presentViewController:nv animated:YES completion:nil];
    }
}

- (UIViewController *)presentViewControll:(NSString *)storyboardID
{
    if ([NSStringFromClass([RuleWebVC class]) isEqualToString:storyboardID]) {
        return [[RuleWebVC alloc] init];
    } else {
        if (![UserinfoManager sharedUserinfo].userInfo.certifierstate) {
            return [[AuthenticationVC alloc] init];
        } else {
            return [AiMiApplication obtainControllerForMainStoryboardWithID:storyboardID];
        }
    }
}

@end
