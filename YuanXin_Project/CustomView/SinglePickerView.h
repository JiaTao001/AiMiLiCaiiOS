//
//  SinglePickerView.h
//  YuanXin_Project
//
//  Created by Yuanin on 16/5/4.
//  Copyright © 2016年 yuanxin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SinglePickerView : UIView

@property (copy, nonatomic) NSArray *pickerInfo;
//@property (copy, nonatomic) NSArray *selectedInfo;
- (NSArray *)selectedInfo;
- (void)setSelectedInfo:(NSArray *)selectedInfo;
@end
