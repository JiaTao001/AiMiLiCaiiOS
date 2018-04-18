//
//  ProductSectionHeader.h
//  YuanXin_Project
//
//  Created by Yuanin on 16/4/20.
//  Copyright © 2016年 yuanxin. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, ProductType) {
    
    kRegularProduct,
    kOptizimationProduct
};

@interface ProductSectionHeader : UITableViewHeaderFooterView

@property (assign, nonatomic) ProductType type;
@end
