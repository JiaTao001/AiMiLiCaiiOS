//
//  OptimizationEntrustVC.m
//  YuanXin_Project
//
//  Created by Yuanin on 16/5/4.
//  Copyright © 2016年 yuanxin. All rights reserved.
//

#import "OptimizationEntrustVC.h"

#import "WebVC.h"

#import "LimitTextField.h"
#import "PickerAccessoryView.h"
#import "SinglePickerView.h"
#import "MJRefresh.h"
#import "BaseViewModel.h"
#import "AutoEntrustCell.h"
#import "StateTableView.h"

@interface OptimizationEntrustVC ()<UITableViewDelegate,UITableViewDataSource>

@property (strong, nonatomic) NSMutableArray *dataArr;
@property (assign,nonatomic)NSInteger page;
@property (strong, nonatomic) BaseViewModel *baseViewModel;

//@property (weak, nonatomic) IBOutlet StateTableView *tableView;

@property (weak, nonatomic) IBOutlet StateTableView *tableView;


@end

@implementation OptimizationEntrustVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _page = 1;
    _dataArr = [NSMutableArray arrayWithCapacity:0];
    [self layoutNavigationLeftButtonWithImage:[UIImage imageNamed:Nav_Back_Image] block:^(__kindof UIViewController *viewController) {
        [viewController.navigationController popViewControllerAnimated:YES];
    }];
    
    [self fetchOptimizationEntrustInfo];
}
- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    
    [self.baseViewModel cancelFetchOperation];
}

#pragma mark - action



#pragma mark - private
- (void)fetchOptimizationEntrustInfo {

    NSMutableDictionary *params = [[UserinfoManager sharedUserinfo] increaseUserParams:nil];
    [params setObject:@"15" forKey:@"pageqty"];
    [params setObject:[NSString stringWithFormat:@"%li",_page] forKey:@"currentpage"];

    [BaseIndicatorView showInView:self.view  maskType:kIndicatorNoMask];
    @weakify(self)
    [self.baseViewModel postMethod:@"auto_log_list" params:params success:^(id result) {
        @strongify(self)
        
        [BaseIndicatorView hideWithAnimation:self.didShow];
        [self.dataArr addObjectsFromArray: result[RESULT_DATA]];
        self.tableView.type = 0 == self.dataArr.count ? kTableStateNoInfo : kTableStateNormal;
        [self.tableView.header endRefreshing];
        [self.tableView.footer endRefreshing];
        [self.tableView reloadData];
    } failure:^(id result, NSString *errorDescription) {
        @strongify(self)
        [self.tableView.header endRefreshing];
        [self.tableView.footer endRefreshing];
        [BaseIndicatorView hideWithAnimation:self.didShow];
        [SpringAlertView showMessage:errorDescription];
    }];
}
- (void)setTableView:(StateTableView *)tableView{
    _tableView = tableView;
    
    
    @weakify(self)
    tableView.header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        @strongify(self)
        [ self.dataArr removeAllObjects];
        _page = 1;
        [self fetchOptimizationEntrustInfo];
//        [self.regularEntrust beginFetchEntrustWithSuccess:^(id result) {
//            @strongify(self)
//            
//            //            self.entrustTableView.type = 0 == [self showEntrust].entrustInfo.count ? kTableStateNoInfo : kTableStateNormal;
//            [self.entrustTableView.header endRefreshing];
//            [self.entrustTableView reloadData];
//        } failure:^(NSString *errorDescription) {
//            @strongify(self)
//            
//            //            self.entrustTableView.type = ( errorDescription && 0 == [self showEntrust].entrustInfo.count) ? kTableStateNetworkError : kTableStateNormal;
////            [self.entrustTableView.header endRefreshing];
////            [SpringAlertView showMessage:errorDescription];
//        }];
    }];
        tableView.footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
            @strongify(self)
            _page += 1;
            [self fetchOptimizationEntrustInfo];
//            [self.regularEntrust fetchNextPageEntrustWithSuccess:^(id result) {
//                @strongify(self)
//    
//                [self.entrustTableView.footer endRefreshing];
//                [self.entrustTableView reloadData];
//            } failure:^(NSString *errorDescription) {
//                @strongify(self)
//    
//                [self.entrustTableView.footer endRefreshing];
//                [SpringAlertView showMessage:errorDescription];
//            }];
        }];
    
//    [tableView setClickCallBack:^{
//        @strongify(self)
//        
//        [self.entrustTableView.header beginRefreshing];
//    }];
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArr.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    AutoEntrustCell *cell = [tableView dequeueReusableCellWithIdentifier:@"AutoEntrustCell"];
    
    [cell loadInterfaceWithDictionary:self.dataArr[indexPath.row]];
    
    return cell;
}

#pragma mark - getter
- (BaseViewModel *)baseViewModel {
    if (!_baseViewModel) {
        _baseViewModel = [[BaseViewModel alloc] init];
    }
    return _baseViewModel;
}
@end
