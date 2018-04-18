//
//  InviteFriendsVC.m
//  YuanXin_Project
//
//  Created by Yuanin on 16/1/20.
//  Copyright © 2016年 yuanxin. All rights reserved.
//

#import "InviteFriendsVC.h"

#import "InviteFriendsCell.h"
#import "MJRefresh.h"
#import "SharedView.h"

#import "UIImageView+WebCache.h"

@interface InviteFriendsVC () <UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) NSURLSessionTask *task;

@property (weak, nonatomic  ) IBOutlet UITableView *tableView;
@property (weak, nonatomic  ) IBOutlet UIButton    *inviteButton;
@property (strong, nonatomic) UIImageView *headerImage;

@property (assign, nonatomic) NSInteger      page;
@property (strong, nonatomic) NSMutableArray *allInviteFriends;
@property (strong, nonatomic) UILabel        *listTitle;
@property (strong, nonatomic) UIView         *headerView;
@end

@implementation InviteFriendsVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self layoutNavigationLeftButtonWithImage:[UIImage imageNamed:Nav_Back_Image] block:^(__kindof UIViewController *viewController) {
        [viewController.navigationController popViewControllerAnimated:YES];
    }];
    
    self.page = 1;
    
    [self configureHeaderImage];
    [self fetchInviteFriendList];
}


#pragma mark - UITableView delegate datesource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.allInviteFriends.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    InviteFriendsCell *cell = [tableView dequeueReusableCellWithIdentifier:INVITE_FRIENDS_IDENTIFIER];
    
    NSDictionary *cellInfo = self.allInviteFriends[indexPath.row];
    cell.name.text  = cellInfo[@"mobile"];
    cell.time.text  = cellInfo[@"created"];
    cell.money.text = [NSString stringWithFormat:@"%@元", cellInfo[@"amount"]];
    
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return ROW_HEIGHT;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    return self.headerView;
}

- (void)fetchInviteFriendList {
    
    NSMutableDictionary *params = [[UserinfoManager sharedUserinfo] increaseUserParams:nil];
    [params setValue:@(Each_Page_Num) forKey:@"pageqty"];
    [params setValue:@(self.page) forKey:@"currentpage"];
    
    @weakify(self)
    self.task = [NetworkContectManager sessionPOSTWithMothed:@"getinvitefriendslist" params:params success:^(NSURLSessionTask *task, id result) {
        @strongify(self)
        
        NSArray *resultArr = result[RESULT_DATA];
        if (!resultArr) return;
        
        self.page++;
        [self.allInviteFriends addObjectsFromArray:resultArr];
        
        if (0 == self.allInviteFriends.count) {
            self.listTitle.text = @"暂无邀请记录";
        } else {
            self.listTitle.text = @"我邀请的人";
        }
        
        [self.tableView.footer endRefreshing];
        [self.tableView reloadData];
    } failure:^(NSURLSessionTask *task, id result, NSString *errorDescription) {
        @strongify(self)
        
        self.listTitle.text = @"本次加载失败";
        [self.tableView.footer endRefreshing];
        [SpringAlertView showMessage:errorDescription];
    }];
}

- (void)configureHeaderImage {
    
    @weakify(self)
    [self.headerImage loadImageWithPath:self.headerImagePath placeholderImage:nil complete:^(UIImage *image, NSError *error) {
        @strongify(self)
        
        if (image && !error) {
            self.headerImage.bounds = /*CGRectMake(0, 0, self.tableView.width, height);//*/CGRectMake(0, 0, UISCREEN_WIDTH, UISCREEN_WIDTH*image.size.height /image.size.width);
            self.tableView.tableHeaderView = self.headerImage;
        }
    }];
}


#pragma mark - setter & getter
- (void)setTableView:(UITableView *)tableView {
    _tableView = tableView;
    
    tableView.tableFooterView = [UIView new];
    tableView.separatorInset = UIEdgeInsetsZero;
    if ([tableView respondsToSelector:@selector(layoutMargins)]) {
        tableView.layoutMargins = UIEdgeInsetsZero;
    }
    
    @weakify(self)
    tableView.footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        @strongify(self)
        [self fetchInviteFriendList];
    }];
}
- (void)setInviteButton:(UIButton *)inviteButton {
    _inviteButton = inviteButton;
    
    if (![SharedView canShared]) {
        [inviteButton setTitle:@"您未安装可分享软件" forState:UIControlStateNormal];
        inviteButton.enabled = NO;
    }
}
- (void)setHeaderImagePath:(NSString *)headerImagePath {
    _headerImagePath = headerImagePath;
    
    if (self.headerImage) {
        [self configureHeaderImage];
    }
}


- (UIView *)headerView {
    
    if (!_headerView) {
        UIView *tmpView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, 44)];
        
        UILabel *centerLable = [[UILabel alloc] init];
        centerLable.translatesAutoresizingMaskIntoConstraints = NO;
        centerLable.text = @"刷新中...";
        centerLable.font = [UIFont systemFontOfSize:NORMAL_FONT_SIZE];
        centerLable.textColor = Font_Normal_Gray;
        
        UIImageView *leftLine = [[UIImageView alloc] initWithImage:[CommonTools singleImageFromColor:RGB(0x666666)]];
        leftLine.translatesAutoresizingMaskIntoConstraints = NO;
        UIImageView *rightLine = [[UIImageView alloc] initWithImage:[CommonTools singleImageFromColor:RGB(0x666666)]];
        rightLine.translatesAutoresizingMaskIntoConstraints = NO;
        
        [tmpView addSubview:self.listTitle = centerLable];
        [tmpView addSubview:leftLine];
        [tmpView addSubview:rightLine];
        
        NSArray *hCon = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-20-[leftLine]-10-[centerLable]-10-[rightLine(==leftLine)]-20-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(centerLable, leftLine, rightLine)];
        NSLayoutConstraint *centerVCon = [NSLayoutConstraint constraintWithItem:centerLable attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:tmpView attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:0];
        NSLayoutConstraint *leftVCon = [NSLayoutConstraint constraintWithItem:leftLine attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:tmpView attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:0];
        NSLayoutConstraint *rightVCon = [NSLayoutConstraint constraintWithItem:rightLine attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:tmpView attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:0];
        
        [tmpView addConstraints:hCon];
        [tmpView addConstraint:centerVCon];
        [tmpView addConstraint:leftVCon];
        [tmpView addConstraint:rightVCon];
        tmpView.backgroundColor = self.tableView.backgroundColor;
        
        _headerView = tmpView;
    }
    return _headerView;
}
- (IBAction)inviteFriends:(UIButton *)sender {
    
    [self.sharedView showInWindow:self.view.window];
}
- (NSMutableArray *)allInviteFriends {
    
    if (!_allInviteFriends) {
        _allInviteFriends = [[NSMutableArray alloc] init];
    }
    return _allInviteFriends;
}

- (UIImageView *)headerImage {
    
    if (!_headerImage) {
        _headerImage = [[UIImageView alloc] init];
        _headerImage.contentMode = UIViewContentModeScaleAspectFit;
    }
    return _headerImage;
}
@end
