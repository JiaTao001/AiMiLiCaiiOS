//
//  ProjectDetailView.h
//  YuanXin_Project
//
//  Created by Yuanin on 16/1/13.
//  Copyright © 2016年 yuanxin. All rights reserved.
//

#import "ProductDetailSubView.h"

#define PRODUCT_CELL_IDENTIFIER    @"ProductDetailCell"

#define PRODUCT_DETAIL_TITLE        @"title"
#define PRODUCT_DETAIL_KEY          @"key"
#define PRODUCT_KEY_PLIST           @"product_detail_key.plist"

@interface ProductDetailCell : UITableViewCell
@property (strong, nonatomic) UIImageView *icon;
@property (strong, nonatomic) UILabel *title;
@property (strong, nonatomic) UILabel *jiange;
@property (strong, nonatomic) UILabel *type;
@property (strong, nonatomic) UILabel *detail;
@property (assign,nonatomic)CGFloat rowHeight;

- (void)configCellWithKeyInfo:(NSDictionary *)keyInfo dictionary:(NSDictionary *)aDic;
@end



@interface ProjectDetailView : ProductDetailSubView

@property (strong, nonatomic) NSDictionary *projectInfo;

@end
