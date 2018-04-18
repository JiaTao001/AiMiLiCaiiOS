//
//  AccumulatedIncomeVC.m
//  YuanXin_Project
//
//  Created by Yuanin on 15/10/12.
//  Copyright © 2015年 yuanxin. All rights reserved.
//

#import "AccumulatedIncomeVC.h"

#import "AccumulatedIncomeViewModel.h"
#import "IncomeTableCell.h"
#import "StateTableView.h"
#import "MJRefresh.h"

#import "ExclusiveButton.h"


@interface AccumulatedIncomeVC () <UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) NSURLSessionTask *task;

@property (strong, nonatomic) IBOutlet ExclusiveButton *exclusive;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *lineX;

@property (strong, nonatomic) AccumulatedIncomeViewModel *waitAcceptIncome;
@property (strong, nonatomic) AccumulatedIncomeViewModel *didAcceptIncome;

@property (weak, nonatomic) IBOutlet UILabel *waitAcceptInterest;
@property (weak, nonatomic) IBOutlet UILabel *didAcceptInterest;

@property (strong, nonatomic) AccumulatedIncomeViewModel *showAcceptIncome;

@property (assign, nonatomic) NSInteger type;/**< 0 待收， 1已收 */
@property (weak, nonatomic) IBOutlet StateTableView *incomeList;
@end

@implementation AccumulatedIncomeVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
        
    [self layoutNavigationLeftButtonWithImage:[UIImage imageNamed:Nav_Back_Image] block:^(__kindof UIViewController *viewController) {
        [viewController.navigationController popViewControllerAnimated:YES];
    }];
    
    self.type = 0;
}
- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    
    [self.task cancel];
}

#pragma mark - dataSource & delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
        
    return self.showAcceptIncome.allIncomeInfo.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    IncomeTableCell *cell = [tableView dequeueReusableCellWithIdentifier:INCOME_IDENTIFIER];
    
    [cell loadCellWithModel:self.showAcceptIncome.allIncomeInfo[indexPath.section]];
    
    return cell;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    UIView *tmpView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.width, tableView.sectionHeaderHeight)];
    tmpView.backgroundColor = [UIColor clearColor];
    return tmpView;
}

#pragma mark - action
- (void)fetchAccunulatedIncomeInfoWithType:(NSInteger)type refresh:(BOOL)refresh {
    
    @weakify(self)
    self.task = [self.showAcceptIncome fetchAccumulatedIncomeInfoWithParams:@{KEY_STATUS:@(type)} refresh:refresh result:^(id result, BOOL success,NSString *errorDescription) {
        @strongify(self)
        
        [self.incomeList.header endRefreshing];
        [self.incomeList.footer endRefreshing];
        
        [self.incomeList reloadData];
        if (success) {
            if (refresh && [result[RESULT_DATA] count]) {
                
                NSDictionary *tmpInfo = [result[RESULT_DATA] firstObject];
                self.waitAcceptInterest.text = [CommonTools convertToStringWithObject:tmpInfo[@"waitinterest"]];
                self.didAcceptInterest.text  = [CommonTools convertToStringWithObject:tmpInfo[@"receivedinterest"]];
            }
            
            self.incomeList.type = 0 == self.showAcceptIncome.allIncomeInfo.count ? kTableStateNoInfo : kTableStateNormal;
        } else  {
            [SpringAlertView showInWindow:self.view.window message:errorDescription];
            
            self.incomeList.type = (errorDescription && 0 == self.showAcceptIncome.allIncomeInfo.count) ? kTableStateNetworkError : kTableStateNormal;;
        }
    }];
}

#pragma mark - setter & getter
- (void)setIncomeList:(StateTableView *)incomeList {
    _incomeList = incomeList;
    
    incomeList.tableFooterView = [UIView new];
    incomeList.separatorInset = UIEdgeInsetsZero;
    if ([incomeList respondsToSelector:@selector(layoutMargins)])
        incomeList.layoutMargins = UIEdgeInsetsZero;
    
    @weakify(self)
    incomeList.header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        @strongify(self)
        
        [self.task cancel];
        [self fetchAccunulatedIncomeInfoWithType:self.type refresh:YES];
    }];
    incomeList.footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        @strongify(self)
        
        [self.task cancel];
        [self fetchAccunulatedIncomeInfoWithType:self.type refresh:NO];
    }];
    [incomeList setClickCallBack:^{
        @strongify(self)
        
        [self.incomeList.header beginRefreshing];
    }];
}
- (void)setExclusive:(ExclusiveButton *)exclusive {
    _exclusive = exclusive;
    
    @weakify(self)
    exclusive.invalidButtonWillChangeBlock = ^(UIButton *newInvalidButton) {
        @strongify(self)
        self.lineX.constant = CGRectGetMinX(newInvalidButton.frame);
        self.type = newInvalidButton.tag;
    };
}
- (void)setType:(NSInteger)type {
    _type = type;
    
    dispatch_async(dispatch_get_main_queue(), ^{
        self.showAcceptIncome = 0 == type ? self.waitAcceptIncome : self.didAcceptIncome;
    });
}
-(void)setShowAcceptIncome:(AccumulatedIncomeViewModel *)showAcceptIncome {
    
    if (!showAcceptIncome || [_showAcceptIncome isEqual: showAcceptIncome]) return;
    
    _showAcceptIncome = showAcceptIncome;
    
    [self.incomeList reloadData];
    
    if (0 == showAcceptIncome.allIncomeInfo.count) {
        [self.incomeList.header beginRefreshing];
    } else {
        self.incomeList.type = kTableStateNormal;
    }
}


- (AccumulatedIncomeViewModel *)waitAcceptIncome {
    
    if (!_waitAcceptIncome) {
        _waitAcceptIncome = [[AccumulatedIncomeViewModel alloc] init];
    }
    return _waitAcceptIncome;
}
- (AccumulatedIncomeViewModel *)didAcceptIncome {
    
    if (!_didAcceptIncome) {
        _didAcceptIncome = [[AccumulatedIncomeViewModel alloc] init];
    }
    return _didAcceptIncome;
}

@end
