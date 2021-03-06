//
//  UserinfoHeadCell.h
//  YuanXin_Project
//
//  Created by Yuanin on 15/12/25.
//  Copyright © 2015年 yuanxin. All rights reserved.
//

#import <UIKit/UIKit.h>

#define Refresh_Height 64.0
typedef void (^TapWarmingBtn)(int status);
@interface UserinfoHeaderView : UICollectionReusableView

@property (assign, nonatomic) NSInteger stretchingHeight;
@property (nonatomic, copy) TapWarmingBtn tapWarming;

- (void)reloadWarmingView;
@end
