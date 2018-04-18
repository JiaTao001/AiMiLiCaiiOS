//
//  ProductDetailView.h
//  YuanXin_Project
//
//  Created by Yuanin on 16/9/19.
//  Copyright © 2016年 yuanxin. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "ProjectDetailView.h"
#import "ProjectInformationView.h"
#import "RecordView.h"
#import "RepaymentView.h"

@interface ProductDetailView : UIView

+ (instancetype)productDetailView;

@property (strong, nonatomic) NSString     *productID;
@property (strong, nonatomic) NSDictionary *projectInfo;

@property (copy, nonatomic) void(^shouldChangeShowView)();

@end
