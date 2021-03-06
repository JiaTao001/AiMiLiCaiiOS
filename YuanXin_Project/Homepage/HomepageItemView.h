//
//  FixedHomepageItem.h
//  YuanXin_Project
//
//  Created by Yuanin on 16/4/19.
//  Copyright © 2016年 yuanxin. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "AnnouncementInfo.h"
#import "RecommendProductInfo.h"

IB_DESIGNABLE @interface FixedHomepageItem : UIView

@property (strong, nonatomic) IBOutlet UIView *view;

@property (copy, nonatomic) IBInspectable NSString *imageName;
@property (copy, nonatomic) IBInspectable NSString *title;
@property (copy, nonatomic) IBInspectable NSString *subheading;
@end

@interface HomepageItemView : UIView
@property (weak, nonatomic) IBOutlet UIView *zichanView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *zichanviewHeight;
@property (weak, nonatomic) IBOutlet UIView *zhuceView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *zhuceViewheigth;
@property (weak, nonatomic) IBOutlet UILabel *xinshouLB;

@property (weak, nonatomic) IBOutlet UILabel *zhuceLB;

@property (weak, nonatomic) IBOutlet UILabel *reteLB;

@property (weak, nonatomic) IBOutlet UILabel *moneyLB;
@property (weak, nonatomic) IBOutlet UILabel *timeLB;

@property (copy, nonatomic) AnnouncementInfo *announcementInfo;
@property (copy, nonatomic) RecommendProductInfo *aInfo;

@property (strong, nonatomic) NSMutableArray *announcementInfos;
@property (copy, nonatomic) void(^checkSpecificAnnoucement)(AnnouncementInfo *aInfo);
@property (copy, nonatomic) void(^checkAllAnnoucemtes)();
//@property (assign,nonatomic)float ViewHeight;
+ (instancetype)homepageItemViewWithIsLogin:(BOOL)islogin ProductInfo:(RecommendProductInfo *)aInfo  SelectBlock:(void(^)(NSInteger index)) selectBlock;
- (void)referceUIWithIslog:(BOOL)isLog;

@end
