//
//  RepaymentView.m
//  YuanXin_Project
//
//  Created by Yuanin on 16/9/22.
//  Copyright © 2016年 yuanxin. All rights reserved.
//

#import "RepaymentView.h"

#import "StateTableView.h"

@interface RepaymentCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *numberOfPeriods;
@property (weak, nonatomic) IBOutlet UILabel *money;
@property (weak, nonatomic) IBOutlet UILabel *time;
@property (weak, nonatomic) IBOutlet UILabel *repaymentState;
@end

@implementation RepaymentCell

- (void)awakeFromNib {
    // Initialization code
    [super awakeFromNib];
    
    self.separatorInset = UIEdgeInsetsMake(0, BIG_MARGIN_DISTANCE, 0, BIG_MARGIN_DISTANCE);
    if ([self respondsToSelector:@selector(layoutMargins)]) {
        self.layoutMargins = UIEdgeInsetsZero;//UIEdgeInsetsMake(0, MARGIN_DISTANCE, 0, MARGIN_DISTANCE);
    }
}
@end

@interface RepaymentHeaderView : UIView

@property (strong, nonatomic) UILabel *numberOfPeriods, *money, *time, *repaymentState;
@end

@implementation RepaymentHeaderView

- (instancetype)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    
    if (self) {
        
        [self addSubview:self.numberOfPeriods];
        [self addSubview:self.money];
        [self addSubview:self.time];
        [self addSubview:self.repaymentState];
        
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
    
    if (self.numberOfPeriods.translatesAutoresizingMaskIntoConstraints) {
        self.numberOfPeriods.translatesAutoresizingMaskIntoConstraints = self.money.translatesAutoresizingMaskIntoConstraints = self.time.translatesAutoresizingMaskIntoConstraints = self.repaymentState.translatesAutoresizingMaskIntoConstraints = NO;
        
        NSArray *hCon = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(bigDisance)-[_numberOfPeriods]-0-[_money(==_numberOfPeriods)]-0-[_time(==_numberOfPeriods)]-0-[_repaymentState(==_numberOfPeriods)]-(bigDisance)-|" options:0 metrics:@{@"bigDisance":@(BIG_MARGIN_DISTANCE)} views:NSDictionaryOfVariableBindings(_numberOfPeriods, _money, _time, _repaymentState)];
        NSArray *vPCon = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[_numberOfPeriods]-0-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_numberOfPeriods)];
        NSArray *vMCon = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[_money]-0-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_money)];
        NSArray *vTCon = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[_time]-0-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_time)];
        NSArray *vRCon = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[_repaymentState]-0-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_repaymentState)];
        
        [self addConstraints:hCon];
        [self addConstraints:vPCon];
        [self addConstraints:vMCon];
        [self addConstraints:vTCon];
        [self addConstraints:vRCon];
    }
}


- (UILabel *)numberOfPeriods {
    
    if (!_numberOfPeriods) {
        _numberOfPeriods = [self labelWithText:@"期数"];
        _numberOfPeriods.textAlignment = NSTextAlignmentLeft;
    }
    return _numberOfPeriods;
}
- (UILabel *)money {
    
    if (!_money) {
        _money = [self labelWithText:@"还款金额"];
        _money.textAlignment = NSTextAlignmentLeft;
    }
    return _money;
}
- (UILabel *)time {
    
    if (!_time) {
        _time = [self labelWithText:@"还款时间"];
    }
    return _time;
}
- (UILabel *)repaymentState
{
    if (!_repaymentState) {
        _repaymentState = [self labelWithText:@"还款状态"];
        _repaymentState.textAlignment = NSTextAlignmentRight;
    }
    return _repaymentState;
}
@end


@interface RepaymentView() <UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) NSURLSessionTask *task;

@property (strong, nonatomic) StateTableView *tableView;
@property (strong, nonatomic) RepaymentHeaderView *headerView;

@property (strong, nonatomic) NSArray *allRepayment;
@end


@implementation RepaymentView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        
        [self addSubview:self.tableView];
    }
    return self;
}
- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        
        [self addSubview:self.tableView];
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    self.tableView.frame = self.bounds;
}



#pragma mark - UITableView dataSource & delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.allRepayment.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    RepaymentCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([RepaymentCell class])];
    
    cell.numberOfPeriods.text = self.allRepayment[indexPath.row][@"periodqty"];
    cell.money.text = [NSString stringWithFormat:@"%@元", self.allRepayment[indexPath.row][@"paymentprice"]];
    cell.time.text  = self.allRepayment[indexPath.row][@"paymentdate"];
    cell.repaymentState.text = self.allRepayment[indexPath.row][@"status"];
    cell.repaymentState.textColor = RGB(strtoul([[self.allRepayment[indexPath.row][@"color"] stringByReplacingOccurrencesOfString:@"#" withString:@"0x"] UTF8String], 0, 0));
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return nil;
}

- (void)fetchRepaymentInfo
{
    @weakify(self)
    self.task = [NetworkContectManager sessionPOSTWithMothed:@"get_repay_plan" params:@{@"productid":self.productID} success:^(NSURLSessionTask *task, id result) {
        @strongify(self)
        
        self.allRepayment = result[RESULT_DATA];
    } failure:^(NSURLSessionTask *task, id result, NSString *errorDescription) {
        @strongify(self)
        
        self.tableView.type = (errorDescription && 0 == self.allRepayment.count) ? kTableStateNetworkError : kTableStateNormal;
        [SpringAlertView showInWindow:self.window message:errorDescription];
    }];
}

#pragma mark - public action
- (void)beginRefresh {
    
    if (!self.allRepayment.count) {
        [self fetchRepaymentInfo];
    }
}
- (void)stopRefreshing {
    
    [self.task cancel];
}

#pragma mark - Getter 
- (StateTableView *)tableView {
    
    if (!_tableView) {
        _tableView = [[StateTableView alloc] initWithFrame:self.bounds style:UITableViewStylePlain];
        
        [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([RepaymentCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([RepaymentCell class])];
        
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.tableFooterView = [UIView new];
        _tableView.rowHeight = 120;
        _tableView.separatorColor  = Single_Line_Gray;
        _tableView.separatorInset  = UIEdgeInsetsZero;
        if ([_tableView respondsToSelector:@selector(layoutMargins)]) {
            _tableView.layoutMargins = UIEdgeInsetsZero;
        }
        _tableView.delegate   = self;
        _tableView.dataSource = self;
        _tableView.noInfoDescription = @"暂无还款计划";
        
        @weakify(self)
        [_tableView setClickCallBack:^{
            @strongify(self)
            [self fetchRepaymentInfo];
        }];
    }
    return _tableView;
}
- (RepaymentHeaderView *)headerView {
    
    if (!_headerView) {
        _headerView = [[RepaymentHeaderView alloc] init];
    }
    return _headerView;
}

#pragma mark - Setter
- (void)setAllRepayment:(NSArray *)allRepayment
{
    _allRepayment = allRepayment;
    
    self.tableView.type = 0 == allRepayment.count ? kTableStateNoInfo : kTableStateNormal;
    [self.tableView reloadData];
}

@end
