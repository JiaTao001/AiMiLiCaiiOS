//
//  PropertyDetailVC.m
//  YuanXin_Project
//
//  Created by Yuanin on 16/7/14.
//  Copyright © 2016年 yuanxin. All rights reserved.
//

#import "PropertyDetailVC.h"
#import "BonusEventVC.h"

#import "PropertyDetailUpCell.h"
#import "PropertyDetailMidCell.h"
#import "PropertyDetailDownCell.h"

#import "JitterImageView.h"
#import "WebVC.h"
@interface PropertyDetailVC () <UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) NSURLSessionTask *task;
@property (strong, nonatomic) NSDictionary *propertyInfo;

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UILabel *productName;
@property (weak, nonatomic) IBOutlet UILabel *propertyState;
@property (weak, nonatomic) IBOutlet UIImageView *propertySign;

@property (strong, nonatomic) PropertyDetailUpCell *upCell;
@property (strong, nonatomic) PropertyDetailMidCell *midCell;
@property (strong, nonatomic) PropertyDetailDownCell *downCell;
@property (weak, nonatomic) IBOutlet UIButton *hetongBtn;
@property (strong, nonatomic) JitterImageView *jitterImageView;
@end

@implementation PropertyDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initializePropertyDetailVC];
}
- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    
    [self.task cancel];
}

- (void)fetchPropertyDetailInfo {
    if (!self.info.investID) return;
    
    [BaseIndicatorView showInView:self.view maskType:kIndicatorNoMask];
    @weakify(self)
    self.task = [NetworkContectManager sessionPOSTWithMothed:@"getinvestdetail" params:[[UserinfoManager sharedUserinfo] increaseUserParams:@{@"invest_id":self.info.investID}] success:^(NSURLSessionTask *task, id result) {
        @strongify(self)
        
        [BaseIndicatorView hideWithAnimation:self.didShow];
        self.propertyInfo = [result[RESULT_DATA] firstObject];
    } failure:^(NSURLSessionTask *task, id result, NSString *errorDescription) {
        @strongify(self)
        
        [BaseIndicatorView hideWithAnimation:self.didShow];
        [SpringAlertView showMessage:errorDescription];
    }];
}

#pragma mark - UITableViewDataSource, UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    if (self.propertyInfo) {
        return 3;
    }
    return 0;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.section) {
        case 0:
            return self.upCell.height;
            break;
        case 1:
            return self.midCell.height;
            break;
        case 2:
            return self.downCell.height;
            break;
        default:
            return 0;
            break;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return MARGIN_DISTANCE;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    UIView *header = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.width, tableView.sectionHeaderHeight)];
    header.backgroundColor = [UIColor clearColor];
    return header;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    switch (indexPath.section) {
        case 0:
            [self.upCell configureCellWithDictionary:self.propertyInfo];
            return self.upCell;
            break;
        case 1:
            [self.midCell configureCellWithDictionary:self.propertyInfo];
            return self.midCell;
            break;
        case 2:
            [self.downCell configureCellWithDictionary:self.propertyInfo];
            return self.downCell;
            break;
        default:
            return [UITableViewCell new];
            break;
    }
}

- (IBAction)checkHetong:(UIButton *)sender {
    
    WebVC *vc = [[WebVC alloc] initWithWebPath:self.propertyInfo[@"ele_contact_link"] ];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - Action
- (void)initializePropertyDetailVC {
    
    self.productName.text = self.info.productName;
    self.propertyState.text = self.info.propertyState;
    self.propertySign.image = [UIImage imageNamed:self.info.propertySignImageName];
    
    self.hetongBtn.layer.borderColor = [[UIColor orangeColor]CGColor];
    self.hetongBtn.layer.borderWidth = 0.5f;
    self.hetongBtn.layer.cornerRadius = 3;
    self.hetongBtn.layer.masksToBounds = YES;
    [self fetchPropertyDetailInfo];
    
    [self layoutNavigationLeftButtonWithImage:[UIImage imageNamed:Nav_Back_Image] block:^(__kindof UIViewController *viewController) {
        [viewController.navigationController popViewControllerAnimated:YES];
    }];
}


#pragma mark - Setter
- (void)setTableView:(UITableView *)tableView {
    _tableView = tableView;
    
    tableView.sectionFooterHeight = 0;
}
- (void)setInfo:(PropertyInfo *)info {
    _info = info;
    
    if (self.tableView) {
        [self initializePropertyDetailVC];
    }
}
- (void)setPropertyInfo:(NSDictionary *)propertyInfo {
    _propertyInfo = propertyInfo;
    
    [self.tableView reloadData];
    if (propertyInfo[@"ele_contact_link"] && ![propertyInfo[@"ele_contact_link"] isEqualToString:@""]) {

        self.hetongBtn.hidden = NO;
    }else{
        self.hetongBtn.hidden = YES;
    }
    if ((1 == [propertyInfo[Have_Red_Key] integerValue])) {
        
        @weakify(self)
        [self.jitterImageView showInView:self.view withAnimation:NO  clickImage:^{
            @strongify(self)
            BonusEventVC *vc = [[BonusEventVC alloc] init];
            vc.investID = self.info.investID;
             vc.red_type = propertyInfo[@"red_type"];
            [self.navigationController pushViewController:vc animated:YES];
        }];
        self.tableView.contentInset = UIEdgeInsetsMake(0, 0, self.jitterImageView.height + BIG_MARGIN_DISTANCE, 0);
    }
}


#pragma mark - Getter
- (PropertyDetailUpCell *)upCell {
    if (!_upCell) {
        _upCell = [self.tableView dequeueReusableCellWithIdentifier:NSStringFromClass([PropertyDetailUpCell class])];
    }
    return _upCell;
}
- (PropertyDetailMidCell *)midCell {
    if (!_midCell) {
        _midCell = [self.tableView dequeueReusableCellWithIdentifier:NSStringFromClass([PropertyDetailMidCell class])];
    }
    return _midCell;
}
- (PropertyDetailDownCell *)downCell {
    if (!_downCell) {
        _downCell = [self.tableView dequeueReusableCellWithIdentifier:NSStringFromClass([PropertyDetailDownCell class])];
    }
    return _downCell;
}
- (JitterImageView *)jitterImageView {
    if (!_jitterImageView) {
        _jitterImageView = [[JitterImageView alloc] init];
    }
    return _jitterImageView;
}

@end
