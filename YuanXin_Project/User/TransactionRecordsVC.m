//
//  TransactionRecordsVC.m
//  YuanXin_Project
//
//  Created by Yuanin on 15/10/13.
//  Copyright © 2015年 yuanxin. All rights reserved.
//

#import "TransactionRecordsVC.h"
#import "StateTableView.h"
#import "TransactionRecordsCell.h"
#import "TransactionRecordsViewModel.h"

#import "DownPickerView.h"

#import "UserinfoManager.h"
#import "MJRefresh.h"

//userid（用户id）、mobile（手机号码）、timetype（0表示不限、1表示7天以内、2表示1个月以内、3表示3个月以内、4表示6个月以内、5表示一年以内、6表示一年以外）、fundtype（类型 0表示所有、1表示购买定期、2表示充值、3表示体现）、status（状态；0表示不限、1表示已完成，2表示未完成）、pageqty（每页显示数量）、currentpage（当前索引页

@interface TransactionRecordsVC () <UITableViewDataSource, UITableViewDelegate, DownPickerViewDataSource>

@property (strong, nonatomic, readwrite) TransactionRecordsViewModel *transactionRecords;
@property (strong, nonatomic, readwrite) NSURLSessionTask *task;

@property (weak, nonatomic) IBOutlet StateTableView *transactionRecordsTable;

@property (strong, nonatomic) DownPickerView *timePickerView;
@property (strong, nonatomic) NSArray *times;
@property (weak, nonatomic) IBOutlet UILabel *time;
@property (strong, nonatomic) DownPickerView *statePickerView;
@property (strong, nonatomic) NSArray *state;
@property (weak, nonatomic) IBOutlet UILabel *tradeState;

@end

@implementation TransactionRecordsVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
        
    [self layoutNavigationLeftButtonWithImage:[UIImage imageNamed:Nav_Back_Image] block:^(UIViewController *viewController) {
        [viewController.navigationController popViewControllerAnimated:YES];
    }];
    
    [self.transactionRecordsTable.header beginRefreshing];
}
- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    
    [self.task cancel];
}

#pragma mark - dataSource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.transactionRecords.allTransactionRecordsInfo.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return [self.transactionRecords.allTransactionRecordsInfo[section][@"list"] count];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    TransactionRecordsCell *cell = [tableView dequeueReusableCellWithIdentifier:JOURNAL_ACCOUN_IDENTIFIER];
    NSDictionary *dict = self.transactionRecords.allTransactionRecordsInfo[indexPath.section];
    NSDictionary *data = dict[@"list"][indexPath.row];
    
    
    [cell loadCellWithModel:[TransactionRecordsInfo TransactionRecordsInfoWithDictaionary:data]];
    
    return cell;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    UIView *tmpView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.width, 40)];
    tmpView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    UILabel *lable = [[UILabel alloc]initWithFrame:CGRectMake(20, 10, 100, 20)];
     NSDictionary *dict = self.transactionRecords.allTransactionRecordsInfo[section];
    lable.text = dict[@"year"];
    lable.font = [UIFont systemFontOfSize:14.0];
    [tmpView addSubview:lable];
    return tmpView;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return 40;
}

//DownPickerViewDataSource
- (NSInteger)numberOfRowsInDownPickerView:(DownPickerView *)pickerView {
    
    NSArray *content = [self contentWithTag:pickerView.tag];
    
    return content.count;
}
- (NSString *)downPickerView:(DownPickerView *)pickerView titleAtRow:(NSInteger)row {
    
    NSArray *content = [self contentWithTag:pickerView.tag];
    
    return content[row];
}
- (CGSize)collectionViewsizeForItemAtIndexPath{
    return CGSizeMake([UIScreen mainScreen].bounds.size.width/3.0, 60);
}

#pragma mark - action
- (IBAction)filter:(UIButton *)sender {
    
    DownPickerView *picker = [self pickerViewWithTag:sender.tag];
    
    if (sender.tag == picker.tag && picker.isShowing) {
        
        [picker hideWithAnimation:YES];
    } else {
        
        [self.timePickerView hide];
        [self.statePickerView hide];
        
        @weakify(self)
        [picker showInAnchorView:sender.superview clickRow:^(DownPickerView *pickerView, NSInteger row) {
            @strongify(self)
            
            NSArray *content = [self contentWithTag:pickerView.tag];
            UILabel *lable = [self lableWithTag:pickerView.tag];
            
            lable.text = content[row];
            
            [self.transactionRecords.allTransactionRecordsInfo removeAllObjects];
            [self.transactionRecordsTable reloadData];
            [self.transactionRecordsTable.header beginRefreshing]; //切换状态。。视作刷新
        }];
    }
}


#pragma mark - private method

- (void)fetchTransactionRecordsInfo:(BOOL)refresh {
    
    @weakify(self)
    self.task = [self.transactionRecords fetchTransactionRecordsInfoWithParams:@{KEY_TIMETYPE:@(self.timePickerView.selectedRow), KEY_FUNDTYPE:@0, KEY_STATES:@(self.statePickerView.selectedRow)} refresh:refresh result:^(id result, BOOL success, NSString *errorDescription) {
        @strongify(self)
        
        [self.transactionRecordsTable.header endRefreshing];
        [self.transactionRecordsTable.footer endRefreshing];
        
        [self.transactionRecordsTable reloadData];

        if (success) {
            self.transactionRecordsTable.type = 0 == self.transactionRecords.allTransactionRecordsInfo.count ? kTableStateNoInfo : kTableStateNormal;
        } else  {
            [SpringAlertView showInWindow:self.view.window message:errorDescription];
            
            if (!self.transactionRecords.allTransactionRecordsInfo.count && errorDescription) { //没有数据时
                self.transactionRecordsTable.type = kTableStateNetworkError;
            }
        }
    }];
}
- (DownPickerView *)pickerViewWithTag:(NSInteger)tag {
    
    DownPickerView *picker;
    
    switch (tag) {
        case 100:
            picker = self.timePickerView;
            break;
            
        case 300:
            picker = self.statePickerView;
            break;
    }
    
    return picker;
}
- (NSArray *)contentWithTag:(NSInteger)tag {
    
    NSArray *result;
    
    switch (tag) {
        case 100:
            result = self.times;
            break;
            
        case 300:
            result = self.state;
            break;
    }
    
    return result;
}
- (UILabel *)lableWithTag:(NSInteger)tag {
    
    UILabel *result;
    
    switch (tag) {
        case 100:
            result = self.time;
            break;
            
        case 300:
            result = self.tradeState;
            break;
    }
    return result;
}

#pragma mark - setter & getter
- (void)setTransactionRecordsTable:(StateTableView *)transactionRecordsTable {
    _transactionRecordsTable = transactionRecordsTable;
    
    transactionRecordsTable.tableFooterView = [UIView new];
    transactionRecordsTable.separatorInset = UIEdgeInsetsZero;
    if ([transactionRecordsTable respondsToSelector:@selector(layoutMargins)]) {
        transactionRecordsTable.layoutMargins = UIEdgeInsetsZero;
    }
    
    @weakify(self)
    transactionRecordsTable.header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        @strongify(self)
        
        [self.task cancel];
        [self fetchTransactionRecordsInfo:YES];
    }];
    transactionRecordsTable.footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        @strongify(self)
        
        [self.task cancel];
        [self fetchTransactionRecordsInfo:NO];
    }];
    [transactionRecordsTable setClickCallBack:^{
        @strongify(self)
        
        [self.transactionRecordsTable.header beginRefreshing];
    }];
}


- (TransactionRecordsViewModel *)transactionRecords {
    
    if (!_transactionRecords) {
        _transactionRecords = [[TransactionRecordsViewModel alloc] init];
    }
    return _transactionRecords;
}
- (DownPickerView *)timePickerView {
    
    if (!_timePickerView) {
        _timePickerView = [[DownPickerView alloc] init];
        _timePickerView.tag = 100;
        _timePickerView.tableHeight = 120;
        _timePickerView.dataSource = self;
    }
    return _timePickerView;
}
- (NSArray *)times {
    
    if (!_times) {
        _times = @[@"全部", @"7天以内", @"一个月以内", @"三个月以内", @"六个月以内", @"一年以内"];
    }
    return _times;
}
- (DownPickerView *)statePickerView {
    
    if (!_statePickerView) {
        _statePickerView = [[DownPickerView alloc] init];
        _statePickerView.tag = 300;
        _statePickerView.tableHeight = 120;
        _statePickerView.dataSource = self;
    }
    return _statePickerView;
}
- (NSArray *)state {
    
    if (!_state) {
        _state = @[@"全部", @"交易成功", @"交易失败", @"处理中"];
    }
    return _state;
}

@end
