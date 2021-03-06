//
//  SinglePickerView.m
//  YuanXin_Project
//
//  Created by Yuanin on 16/5/4.
//  Copyright © 2016年 yuanxin. All rights reserved.
//

#import "SinglePickerView.h"

@interface SinglePickerView () <UIPickerViewDataSource, UIPickerViewDelegate>

@property (strong, nonatomic) UIPickerView *pickerView;
@property (assign,nonatomic)NSInteger i;

@end

@implementation SinglePickerView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    
    if (self) {
        _i = 0;
        [self addSubview:self.pickerView];
        self.translatesAutoresizingMaskIntoConstraints = YES;
    }
    return self;
}
- (void)layoutSubviews {
    [super layoutSubviews];
 
    self.pickerView.frame = self.bounds;
}

- (NSInteger)components {
    
    if (self.pickerInfo) {
        
        if ([self haveMultiComponents]) {
            return self.pickerInfo.count;
        } else {
            return 1;
        }
    } else {
        return 0;
    }
}
- (BOOL)haveMultiComponents {
    
    return [[self.pickerInfo firstObject] isKindOfClass:[NSSet class]]
    || [[self.pickerInfo firstObject] isKindOfClass:[NSArray class]];
}
//- (void)setSelectedInfo:(NSArray *)selectedInfo{
//    for (int i = 0; i<[self.pickerInfo[0] count]; i++) {
//        if ([selectedInfo[0] isEqualToString:self.pickerInfo[0][i] ]) {
//            [self.pickerView selectRow:i inComponent:0 animated:YES];
//             [self.pickerView reloadComponent:1];
//        }
////        [self.pickerView reloadComponent:1];
//    }
//    for (int i = 0; i<[self.pickerInfo[1] count]; i++) {
//        if ([selectedInfo[1] isEqualToString:self.pickerInfo[1][i] ]) {
//            [self.pickerView selectRow:i inComponent:1 animated:YES];
//        }
//       
//    }
//}

- (NSArray *)selectedInfo {
    if (!self.pickerInfo) return nil;
    
    NSMutableArray *result = [NSMutableArray array];
    if ([self haveMultiComponents]) {
        for (NSInteger i = 0; i < self.pickerView.numberOfComponents; i++) {

            if (i==0) {
                [result addObject:self.pickerInfo[i][[self.pickerView selectedRowInComponent:i]]];

            }else{
                NSInteger j = [self.pickerView selectedRowInComponent:i];
                NSInteger k = [self.pickerView selectedRowInComponent:0];
                [result addObject:self.pickerInfo[i][j+k]];
 
            }
            
            
         
        }
    } else {
        
        [result addObject:self.pickerInfo[[self.pickerView selectedRowInComponent:0]]];
    }
    
    return result;
}

#pragma mark - UIPickerViewDataSource, UIPickerViewDelegate
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    
    return [self components];
}
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    
    if ([self haveMultiComponents]) {
        if (component == 0) {
             return [self.pickerInfo[component] count];
        }else{

           
            
            return [self.pickerInfo[component] count] - _i;
        }
       
    } else {
        
        return self.pickerInfo.count ;
    }
}


- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    
    if ([self haveMultiComponents]) {
        if (component == 0) {
            return self.pickerInfo[component][row];
        }else{

            return self.pickerInfo[component] [row + _i];
        }
        
    } else {
      
            return self.pickerInfo[row];
       
        }
    
}
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    if (component == 0) {
        _i = [self.pickerView selectedRowInComponent:component];
        [self.pickerView reloadComponent:1];
        [self.pickerView selectRow:0 inComponent:1 animated:YES];
    }
    
}



#pragma mark - getter
- (UIPickerView *)pickerView {
    
    if (!_pickerView) {
        UIPickerView *pickerView = [[UIPickerView alloc] init];
        pickerView.dataSource = self;
        pickerView.delegate = self;
        
        _pickerView = pickerView;
    }
    return _pickerView;
}

#pragma mark - setter
- (void)setPickerInfo:(NSArray *)pickerInfo {
    _pickerInfo = pickerInfo;
    
    [self.pickerView reloadAllComponents];
}


@end
