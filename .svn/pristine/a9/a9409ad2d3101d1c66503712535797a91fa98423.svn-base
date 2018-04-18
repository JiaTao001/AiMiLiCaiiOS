//
//  PickerAccessoryView.m
//  YuanXin_Project
//
//  Created by Yuanin on 16/5/3.
//  Copyright © 2016年 yuanxin. All rights reserved.
//

#import "PickerAccessoryView.h"

@interface PickerAccessoryView ()

@property (copy, nonatomic) void(^doneBlock)();
@property (copy, nonatomic) void(^cancelBlock)();
@end

@implementation PickerAccessoryView

+ (instancetype)pickerAccessoryViewWithDoneBlock:( void(^)())doneBlock cancelBlock:( void(^)())cancelBlock {
    
    PickerAccessoryView *result = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([PickerAccessoryView class]) owner:nil options:nil] firstObject];
    
    if (![result isKindOfClass:[PickerAccessoryView class]]) return nil;
    
    result.doneBlock = doneBlock;
    result.cancelBlock = cancelBlock;
    return result;
}
- (IBAction)cancel:(id)sender {
    
    if (self.cancelBlock) {
        self.cancelBlock();
    }
}
- (IBAction)done:(id)sender {
    
    if (self.doneBlock) {
        self.doneBlock();
    }
}



@end
