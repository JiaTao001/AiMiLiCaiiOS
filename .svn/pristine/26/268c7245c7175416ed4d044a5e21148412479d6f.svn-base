//
//  ProductDetailSubView.h
//  YuanXin_Project
//
//  Created by Yuanin on 16/9/23.
//  Copyright © 2016年 yuanxin. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "HorizontalScrollView.h"

@interface ProductDetailSubView : UIView <UIScrollViewDelegate, HorizontalContentViewRefresh>

@property (strong, nonatomic) NSString *productID;

@property (copy, nonatomic) void(^changeContentY)(CGFloat contentY);
@property (copy, nonatomic) void(^shouldChangeShowView)();

@end
