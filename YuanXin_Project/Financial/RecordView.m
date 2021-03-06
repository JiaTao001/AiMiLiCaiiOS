//
//  RecordView.m
//  YuanXin_Project
//
//  Created by Yuanin on 16/1/13.
//  Copyright © 2016年 yuanxin. All rights reserved.
//

#import "RecordView.h"

#import "StateTableView.h"
#import "MJRefresh.h"

#define RECORD_CELL_XIB_NAME @"RecordCell"

@interface RecordCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *phone;
@property (weak, nonatomic) IBOutlet UILabel *money;
@property (weak, nonatomic) IBOutlet UILabel *time;
@end

@implementation RecordCell

- (void)awakeFromNib {
    // Initialization code
    [super awakeFromNib];
    
    self.separatorInset = UIEdgeInsetsMake(0, BIG_MARGIN_DISTANCE, 0, BIG_MARGIN_DISTANCE);
    if ([self respondsToSelector:@selector(layoutMargins)]) {
        self.layoutMargins = UIEdgeInsetsZero;//UIEdgeInsetsMake(0, MARGIN_DISTANCE, 0, MARGIN_DISTANCE);
    }
}
@end

@interface RecordHeaderView : UIView

@property (strong, nonatomic) UILabel *phone, *money, *time;
@end

@implementation RecordHeaderView

- (instancetype)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    
    if (self) {
        
        [self addSubview:self.phone];
        [self addSubview:self.money];
        [self addSubview:self.time];
        
        [self setNeedsUpdateConstraints];
    }
    return self;
}

- (UILabel *)labelWithText:(NSString *)text {
    
    UILabel *label = [[UILabel alloc] init];
    
    label.backgroundColor = [UIColor whiteColor];
    label.font            = [UIFont systemFontOfSize:MIN_FONT_SIZE];
    label.textColor       = Font_Shallow_Gray;
    label.text            = text;
    label.textAlignment   = NSTextAlignmentCenter;
    
    return label;
}
- (void)updateConstraints {
    [super updateConstraints];
    
    if (self.phone.translatesAutoresizingMaskIntoConstraints) {
        self.phone.translatesAutoresizingMaskIntoConstraints = self.money.translatesAutoresizingMaskIntoConstraints = self.time.translatesAutoresizingMaskIntoConstraints = NO;
        
        NSArray *hCon = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(bigDisance)-[_phone]-0-[_money(==_phone)]-0-[_time(==_phone)]-(bigDisance)-|" options:0 metrics:@{@"bigDisance":@(BIG_MARGIN_DISTANCE)} views:NSDictionaryOfVariableBindings(_phone, _money, _time)];
        NSArray *vPCon = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[_phone]-0-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_phone)];
        NSArray *vMCon = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[_money]-0-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_money)];
        NSArray *vTCon = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[_time]-0-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_time)];
        
        [self addConstraints:hCon];
        [self addConstraints:vPCon];
        [self addConstraints:vMCon];
        [self addConstraints:vTCon];
    }
}


- (UILabel *)phone {
    
    if (!_phone) {
        _phone = [self labelWithText:@"出借账号"];
        _phone.textAlignment = NSTextAlignmentLeft;
    }
    return _phone;
}
- (UILabel *)money {
    
    if (!_money) {
        _money = [self labelWithText:@"出借金额"];
    }
    return _money;
}
- (UILabel *)time {
    
    if (!_time) {
        _time = [self labelWithText:@"出借时间"];
        _time.textAlignment = NSTextAlignmentRight;
    }
    return _time;
}
@end


@interface RecordView() <UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) NSURLSessionTask *task;

@property (strong, nonatomic) StateTableView *tableView;
@property (strong, nonatomic) RecordHeaderView *headerView;

@property (strong, nonatomic) NSMutableArray *allRecord;
@property (assign, nonatomic) NSInteger page;
@end


@implementation RecordView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        
        [self configureDefaultValue];
    }
    return self;
}
- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        
        [self configureDefaultValue];
    }
    return self;
}

- (void)configureDefaultValue {
    
    [self addSubview:self.tableView];
    _page = 1;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    self.tableView.frame = self.bounds;
}



#pragma mark - UITableView dataSource & delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.allRecord.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    RecordCell *cell = [tableView dequeueReusableCellWithIdentifier:RECORD_CELL_XIB_NAME];
    
    NSDictionary *info = self.allRecord[indexPath.row];
    //、getproductinvestlog（投资记录）=> productid（商品id）、pageqty（每页显示数量）、currentpage（当前索引页）
    //返回值 list  mobile(不完全显示的手机号)、amount(购买金额)、created(投资时间)
    cell.phone.text = info[@"mobile"];
    cell.money.text = [NSString stringWithFormat:@"%@元", info[@"amount"]];
    cell.time.text  = info[@"created"];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 30;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return self.headerView;
}

- (void)fetchRecordInfoWithRefresh:(BOOL)refresh {
    
//    1.8、getproductinvestlog（投资记录）=> productid（商品id）、pageqty（每页显示数量）、currentpage（当前索引页）
//    返回值 list  mobile(不完全显示的手机号)、amount(购买金额)、created(投资时间)
    
    NSInteger currentPage = refresh ? 1 : self.page + 1;
    
    @weakify(self)
    self.task = [NetworkContectManager sessionPOSTWithMothed:@"getproductinvestlog" params:@{@"productid":self.productID, @"pageqty":@(Each_Page_Num), @"currentpage":@(currentPage)} success:^(NSURLSessionTask *task, id result) {
        @strongify(self)
        [self.tableView.footer endRefreshing];
        
        self.page = currentPage;
        if (refresh) {
            [self.allRecord removeAllObjects];
            self.tableView.type = 0 == [result[RESULT_DATA] count] ? kTableStateNoInfo : kTableStateNormal;
        }
        
        [self.allRecord addObjectsFromArray:result[RESULT_DATA]];
        [self.tableView reloadData];

    } failure:^(NSURLSessionTask *task, id result, NSString *errorDescription) {
        @strongify(self)
        [self.tableView.footer endRefreshing];
        self.tableView.type = ( errorDescription && 0 == self.allRecord.count) ? kTableStateNetworkError : kTableStateNormal;
        
        [SpringAlertView showInWindow:self.window message:errorDescription];
    }];
}

#pragma mark - public action
- (void)beginRefresh {
    
    if (!self.allRecord.count) {
        [self fetchRecordInfoWithRefresh:YES];
    }
}
- (void)stopRefreshing {
    
    [self.task cancel];
}


- (StateTableView *)tableView {
    
    if (!_tableView) {
        _tableView = [[StateTableView alloc] initWithFrame:self.bounds style:UITableViewStylePlain];
        
        [_tableView registerNib:[UINib nibWithNibName:RECORD_CELL_XIB_NAME bundle:nil] forCellReuseIdentifier:RECORD_CELL_XIB_NAME];
        
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.tableFooterView = [UIView new];
        _tableView.rowHeight = 44;
        _tableView.separatorColor  = Single_Line_Gray;
        _tableView.separatorInset  = UIEdgeInsetsZero;
        if ([_tableView respondsToSelector:@selector(layoutMargins)]) {
            _tableView.layoutMargins = UIEdgeInsetsZero;
        }
        _tableView.delegate   = self;
        _tableView.dataSource = self;
                        
        @weakify(self)
        _tableView.footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
            @strongify(self)
            
            [self.task cancel];
            [self fetchRecordInfoWithRefresh:NO];
        }];
        [_tableView setClickCallBack:^{
            @strongify(self)
            [self fetchRecordInfoWithRefresh:YES];
        }];
    }
    return _tableView;
}
- (RecordHeaderView *)headerView {
    
    if (!_headerView) {
        _headerView = [[RecordHeaderView alloc] init];
    }
    return _headerView;
}

- (NSMutableArray *)allRecord {
    
    if (!_allRecord) {
        _allRecord = [[NSMutableArray alloc] init];
    }
    return _allRecord;
}

@end
