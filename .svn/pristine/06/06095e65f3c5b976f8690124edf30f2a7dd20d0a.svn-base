//
//  PastProjuctsVC.m
//  YuanXin_Project
//
//  Created by Yuanin on 16/1/6.
//  Copyright © 2016年 yuanxin. All rights reserved.
//

#import "PastProductsVC.h"

#import "ProductDetailVC.h"

#import "StateTableView.h"
#import "PastProductsCell.h"
#import "MJRefresh.h"

@interface PastProductsVC () <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet StateTableView *tableView;

@property (strong, nonatomic) NSMutableArray   *allPastProjucts;
@property (strong, nonatomic) NSURLSessionTask *task;
@property (assign, nonatomic) NSInteger        page;
@end

@implementation PastProductsVC

#pragma mark - life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.page = 1;
    [self layoutNavigationLeftButtonWithImage:[UIImage imageNamed:Nav_Back_Image] block:^(__kindof UIViewController *viewController) {
        [viewController.navigationController popViewControllerAnimated:YES];
    }];
    
    [self fetchPastProjuctsWithRefresh:YES];
}
- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    
    [self.task cancel];
}


#pragma mark - UITableView dataSource & delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return self.allPastProjucts.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    PastProductsCell *cell = [tableView dequeueReusableCellWithIdentifier:PAST_PROJUCTS_REUSE_IDENTIFIER];
    
    [cell configureCellInfo:self.allPastProjucts[indexPath.section]];
    return cell;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    UIView *tmpView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.width, tableView.sectionHeaderHeight)];
    tmpView.backgroundColor = [UIColor clearColor];
    return tmpView;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    ProductDetailVC *vc = [AiMiApplication obtainControllerForMainStoryboardWithID:PRODUCT_DETAIL_STORYBOARD_ID];
    
    vc.needShowPastProject = NO;
    vc.productInfo = [SingleProductInfo singleProductInfoWithProductID:self.allPastProjucts[indexPath.section][@"id"] productName:@"project_name"];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - action
- (void)fetchPastProjuctsWithRefresh:(BOOL)refresh {
    
//    if (!self.allPastProjucts.count && !self.tableView.header.isRefreshing) {
        [BaseIndicatorView showInView:self.view maskType:kIndicatorNoMask];
//    }
    
    NSInteger currentPage = refresh ? 1 : self.page + 1;
    
    @weakify(self)
    self.task = [NetworkContectManager sessionPOSTWithMothed:@"periodproject" params:@{@"productid":self.productID, @"pageqty":@(Each_Page_Num), @"currentpage":@(currentPage)} success:^(NSURLSessionTask *task, id result) {
        @strongify(self)
        
        [BaseIndicatorView hideWithAnimation:self.didShow];
        
        [self.tableView.header endRefreshing];
        [self.tableView.footer endRefreshing];
        
        self.page = currentPage;
        if (refresh) {
            [self.allPastProjucts removeAllObjects];
            self.tableView.type = [result[RESULT_DATA] count] ? kTableStateNormal : kTableStateNoInfo;
        }
        
        [self.allPastProjucts addObjectsFromArray:result[RESULT_DATA]];
        [self.tableView reloadData];
       
    } failure:^(NSURLSessionTask *task, id result, NSString *errorDescription) {
        @strongify(self)
        
        [BaseIndicatorView hideWithAnimation:self.didShow];
        
        [self.tableView.header endRefreshing];
        [self.tableView.footer endRefreshing];
        
        if (!self.allPastProjucts.count && errorDescription) {
            self.tableView.type = kTableStateNetworkError;
        }
        [SpringAlertView showMessage:errorDescription];
    }];
}

#pragma mark - getter
- (NSMutableArray *)allPastProjucts {
    
    if (!_allPastProjucts) {
        _allPastProjucts = [[NSMutableArray alloc] init];
    }
    return _allPastProjucts;
}

- (void)setTableView:(StateTableView *)tableView {
    _tableView = tableView;
    
    UIView *tmpView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.width, tableView.sectionHeaderHeight)];
    tmpView.backgroundColor = [UIColor clearColor];
    tableView.tableFooterView = tmpView;
    
    @weakify(self)
    tableView.header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        @strongify(self)
        
        [self.task cancel];
        [self fetchPastProjuctsWithRefresh:YES];
    }];
    tableView.footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        @strongify(self)
        
        [self.task cancel];
        [self fetchPastProjuctsWithRefresh:NO];
    }];
    [tableView setClickCallBack:^{
        @strongify(self)
        
        [self.tableView.header beginRefreshing];
    }];
}
@end
