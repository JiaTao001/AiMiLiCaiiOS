//
//  StateTableVIew.h
//  YuanXin_Project
//
//  Created by Yuanin on 15/10/28.
//  Copyright © 2015年 yuanxin. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, TableStateType) {
    kTableStateNormal,
    kTableStateNetworkError,
    kTableStateNoInfo
};

@interface StateTableView : UITableView

@property (strong, nonatomic) NSString *noInfoDescription;

@property (assign, nonatomic, readwrite) TableStateType type;

@property (strong, nonatomic, readwrite) UIImage *noInfoImage;     /**< default is no_info */
@property (strong, nonatomic, readwrite) UIImage *errorNetworkImage; /**< default is err_network */

- (void)setClickCallBack:( void(^)())callBack;
@end
