//
//  ProductShowVC.h
//  YuanXin_Project
//
//  Created by Yuanin on 16/3/28.
//  Copyright © 2016年 yuanxin. All rights reserved.
//

#import <UIKit/UIKit.h>

#define Regular_Title @"爱米定期"
#define Optimization_Title @"爱米优选"
#define New_Title @"新手标"

@class SingleProductInfo;
@protocol FinanicalViewClickedDelegate <NSObject>

@required
- (void)finanicalView:(nonnull __kindof UIView* )view checkTheDetailInfomationWithProductInfo:(nonnull SingleProductInfo* )productInfo;
- (void)finanicalView:(nonnull __kindof UIView* )view buyFinanicalItemWithProductInfo:(nonnull SingleProductInfo* )productInfo;
@end

@interface SingleProductInfo : NSObject <NSCoding>

@property (nonnull, strong, nonatomic, readonly) NSString* productID;
@property (nonnull, strong, nonatomic, readonly) NSString *productName;

@property (nonnull, strong, nonatomic, readonly) NSString* productTitle;
@property (assign, nonatomic, readonly) BOOL isRegular;          /**< default is NO */


- (nonnull instancetype)initWithProductID:(nonnull NSString* )productID productName:(nullable NSString *)productName;
+ (nonnull instancetype)singleProductInfoWithProductID:(nonnull NSString* )productID productName:(nullable NSString *)productName;
@end
