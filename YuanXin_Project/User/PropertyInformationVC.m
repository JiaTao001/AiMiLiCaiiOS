//
//  PropertyInformationVC.m
//  YuanXin_Project
//
//  Created by Yuanin on 15/10/16.
//  Copyright © 2015年 yuanxin. All rights reserved.
//

#import "PropertyInformationVC.h"

#import "ProductDetailVC.h"
#import "PropertyDetailVC.h"

#import "StateTableView.h"
#import "PropertyInformationCell.h"
#import "MJRefresh.h"
#import "DownPickerView.h"

#import "ExclusiveButton.h"
#import "PropertyViewModel.h"



@interface PropertyInformationVC () <UITableViewDataSource, UITableViewDelegate, DownPickerViewDataSource>

@property (strong, nonatomic) NSURLSessionTask *task;

@property (strong, nonatomic) PropertyViewModel *propertyInfo;
@property (strong, nonatomic) DownPickerView    *propertyTypePicker;
@property (strong, nonatomic) NSArray           *types;
@property (weak, nonatomic  ) IBOutlet UIButton           *titleButton;
@property (weak, nonatomic  ) IBOutlet UIImageView        *downMore;
@property (weak, nonatomic  ) IBOutlet NSLayoutConstraint *lineX;
@property (strong, nonatomic) IBOutlet ExclusiveButton    *exclusiveButtons;

@property (weak, nonatomic  ) IBOutlet StateTableView *propertyInfomationTable;
@end

@implementation PropertyInformationVC

#pragma mark - life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self layoutNavigationLeftButtonWithImage:[UIImage imageNamed:Nav_Back_Image] block:^(PropertyInformationVC *viewController) {
        
        if (viewController.callBack) {
            viewController.callBack();
        } else {
            [viewController.navigationController popViewControllerAnimated:YES];
        }
    }];
    
    [self.propertyInfomationTable.header beginRefreshing];
}
- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    
    [self.task cancel];
}


#pragma mark - UITableView dataSource & delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.propertyInfo.allPropertyInfo.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    PropertyInformationCell *cell = [tableView dequeueReusableCellWithIdentifier:Property_Informatrion_Identifier];
    
    [cell loadCellWithModel:self.propertyInfo.allPropertyInfo[indexPath.section]];
    cell.inThePayment = 1 == self.exclusiveButtons.invalidButton.tag;
    switch (self.exclusiveButtons.invalidButton.tag) {
        case 1:
        case 4:
            cell.timeTitle.text = @"到期时间：";
            break;
        case 2:
            cell.timeTitle.text = @"截止时间：";
            break;
        case 3:
            cell.timeTitle.text = @"流标时间：";
            break;
    }
    
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return MARGIN_DISTANCE;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
        
    dispatch_async(dispatch_get_main_queue(), ^{
        
        [AlertViewManager showInViewController:self title:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet clickedButtonAtIndex:^(id alertView, NSInteger buttonIndex) {
                        
            if (1 == buttonIndex) {
                ProductDetailVC *vc    = [AiMiApplication obtainControllerForMainStoryboardWithID:PRODUCT_DETAIL_STORYBOARD_ID];
                vc.needShowPastProject = NO;
                vc.productInfo         = self.propertyInfo.allPropertyInfo[indexPath.section];
                [self.navigationController pushViewController:vc animated:YES];
            } else if (2 == buttonIndex) {
                PropertyDetailVC *vc = [AiMiApplication obtainControllerForMainStoryboardWithID:NSStringFromClass([PropertyDetailVC class])];
                vc.info = self.propertyInfo.allPropertyInfo[indexPath.section];
                [self.navigationController pushViewController:vc animated:YES];
            }
        } cancelButtonTitle:NSLocalizedString(@"cancel", nil) otherButtonTitles:@"资产详情", @"订单详情", nil];
    });
}

//************************** DwonPickerViewDataSource
- (NSInteger)numberOfRowsInDownPickerView:(DownPickerView *)pickerView {
    return self.types.count;
}
- (NSString *)downPickerView:(DownPickerView *)pickerView titleAtRow:(NSInteger)row {
    return self.types[row];
}
- (CGSize)collectionViewsizeForItemAtIndexPath{
    return CGSizeMake([UIScreen mainScreen].bounds.size.width/2.0, 60);
}


#pragma mark - private method

- (void)fetchPropertyInfo:(BOOL)refresh {
    
    [self.task cancel];

    @weakify(self)
    self.task = [self.propertyInfo fetchPropertyInfoWithParams:@{ Key_Type:@(self.propertyTypePicker.selectedRow), Key_Status:@(self.exclusiveButtons.invalidButton.tag/*从1开始*/) }  refresh:refresh result:^(id result, BOOL success, NSString *errorDescription) {
        @strongify(self)
        if (NSURLSessionTaskStateRunning != self.task.state) {
            [self endRefreshing];
        }
        
        if (success) {
            
            [self.propertyInfomationTable reloadData];
            self.propertyInfomationTable.type = 0 == self.propertyInfo.allPropertyInfo.count ? kTableStateNoInfo : kTableStateNormal;
        } else if (errorDescription)  {
            [SpringAlertView showInWindow:self.view.window message:errorDescription];
            
            if (!self.propertyInfo.allPropertyInfo.count && errorDescription) { //没有数据时
                self.propertyInfomationTable.type = kTableStateNetworkError;
            }
        }
    }];
}

- (IBAction)changePropertyType:(UIButton *)sender {
    
    if (self.propertyTypePicker.showing) {
        [self.propertyTypePicker hideWithAnimation:YES];

    } else {
        @weakify(self)
        [self.propertyTypePicker showInView:self.view rect:CGRectMake(0, 64, self.view.width, self.view.height) clickRow:^(DownPickerView *pickerView, NSInteger row) {
            @strongify(self)
            
            self.propertyType = row;
        }];
        
        self.propertyTypePicker.complete = ^{
            @strongify(self)
            
            [UIView animateWithDuration:NORMAL_ANIMATION_DURATION animations:^{
                self.downMore.transform = CGAffineTransformIdentity;
            }];
        };
        
        [UIView animateWithDuration:NORMAL_ANIMATION_DURATION animations:^{
            self.downMore.transform = CGAffineTransformRotate(self.downMore.transform,0.000001 - M_PI);//CGAffineTransformRotate(self.downMore.transform, M_PI);
        }];
    }
}
- (IBAction)changePropertyState {
    
    [self endRefreshing];
    [self.propertyInfo.allPropertyInfo removeAllObjects];
    [self.propertyInfomationTable reloadData];
    [self.propertyInfomationTable.header beginRefreshing];
}
- (void)endRefreshing {
    
    [self.propertyInfomationTable.header endRefreshing];
    [self.propertyInfomationTable.footer endRefreshing];
}

#pragma mark - setter & getter
- (void)setPropertyInfomationTable:(StateTableView *)propertyInfomationTable {
    
    _propertyInfomationTable = propertyInfomationTable;
    
    propertyInfomationTable.sectionFooterHeight = 0;
    propertyInfomationTable.separatorInset = UIEdgeInsetsZero;
    if ([propertyInfomationTable respondsToSelector:@selector(layoutMargins)]) {
        propertyInfomationTable.layoutMargins = UIEdgeInsetsZero;
    }
    
    @weakify(self)
    propertyInfomationTable.header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        @strongify(self)
        [self fetchPropertyInfo:YES];
    }];
    propertyInfomationTable.footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        @strongify(self)
        [self fetchPropertyInfo:NO];
    }];
    [propertyInfomationTable setClickCallBack:^{
        @strongify(self)
        [self.propertyInfomationTable.header beginRefreshing];
    }];
}
- (void)setExclusiveButtons:(ExclusiveButton *)exclusiveButtons {
    _exclusiveButtons = exclusiveButtons;
    
    @weakify(self)
    exclusiveButtons.invalidButtonWillChangeBlock = ^(UIButton *newInvalidButton) {
        @strongify(self)
        
        self.lineX.constant = CGRectGetMinX(newInvalidButton.frame);
        [self changePropertyState];
    };
}

- (void)setPropertyType:(PropertyType)propertyType {
    _propertyType = propertyType;
    
    self.propertyTypePicker.selectedRow = propertyType;
    [self.titleButton setTitle:self.types[propertyType] forState:UIControlStateNormal];
    
    [self changePropertyState];
}

- (DownPickerView *)propertyTypePicker {
    
    if (!_propertyTypePicker) {
        _propertyTypePicker = [[DownPickerView alloc] init];
        
        _propertyTypePicker.tag = 200;
        _propertyTypePicker.tableHeight = 60;
        _propertyTypePicker.dataSource = self;
    }
    return _propertyTypePicker;
}
- (NSArray *)types {
    
    if (!_types) {
        _types = @[@"爱米定期", @"爱米优选"];
    }
    return _types;
}
- (PropertyViewModel *)propertyInfo {
    
    if (!_propertyInfo) {
        _propertyInfo = [[PropertyViewModel alloc] init];
    }
    return _propertyInfo;
}

@end
