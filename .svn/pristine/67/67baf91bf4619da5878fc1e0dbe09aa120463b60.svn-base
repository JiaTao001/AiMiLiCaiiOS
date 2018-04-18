//
//  DownPickerView.h
//  YuanXin_Project
//
//  Created by Yuanin on 15/10/12.
//  Copyright © 2015年 yuanxin. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DownPickerView;
@protocol DownPickerViewDataSource <NSObject>

@optional
- (NSInteger)numberOfRowsInDownPickerView:(DownPickerView *) pickerView;
- (NSString *)downPickerView:(DownPickerView *)pickerView titleAtRow:(NSInteger)row;
- (CGSize)collectionViewsizeForItemAtIndexPath;
@end

@interface DownPickerView : UIView

@property (weak) id<DownPickerViewDataSource> dataSource;
@property (strong, nonatomic, readonly) UICollectionView *pickerTableView;
@property (strong, nonatomic, readonly) UIView *anchorView;
@property (assign, nonatomic) float tableHeight;
@property (assign, readonly, getter = isShowing) BOOL showing;
@property (assign, nonatomic) NSInteger selectedRow;
@property (copy, nonatomic) void(^complete)();


- (void)showInAnchorView:(UIView *)anchorView clickRow:( void(^)(DownPickerView *pickerView, NSInteger row) ) clickBlock;//animation
- (void)showInView:(UIView *)view rect:(CGRect)frame clickRow:( void(^)(DownPickerView *pickerView, NSInteger row) ) clickBlock;
- (void)hide;
- (void)hideWithAnimation:(BOOL)animation;
@end
