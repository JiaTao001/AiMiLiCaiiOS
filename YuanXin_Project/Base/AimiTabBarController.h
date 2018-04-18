//
//  AimiTabBarController.h
//  YuanXin_Project
//
//  Created by Yuanin on 16/9/23.
//  Copyright © 2016年 yuanxin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AimiTabBarController : UITabBarController
- (void) presentAdViewController;
- (void)presentViewControllWithStoryboardID:(NSString *)storyboardID;
@end
