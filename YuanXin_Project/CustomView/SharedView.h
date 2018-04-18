//
//  SharedView.h
//  YuanXin_Project
//
//  Created by Yuanin on 15/11/3.
//  Copyright © 2015年 yuanxin. All rights reserved.
//

#import <UIKit/UIKit.h>
//    is_red
//    share_url
//    share_img
//    share_title
//    share_description

#define Share_Url         @"share_url"
#define Share_Image       @"share_img"
#define Share_Title       @"share_title"
#define Share_Description @"share_description"


static NSString *kSharedQQ = @"qq";
static NSString *kSharedWechat = @"wechat";
static NSString *kSharedQzone = @"sms";
static NSString *kSharedWechatFriend = @"wechatfriend";

@interface SharedView : UIView

+ (instancetype)sharedWithURL:(NSString *)url title:(NSString *)title description:(NSString *)description thumbImagePath:(NSString *)thumbImagePath type:(NSArray *)types;

+ (void)loadImageWithImagePath:(NSString *)imagePath complete:(void(^)(UIImage *image))complete;

+ (BOOL)canShared;
+ (BOOL)canShareWechatBonus;

- (void)showInWindow:(UIWindow *)window;
- (void)hide;
- (void)hideWithAnimation:(BOOL)animation;
@end
