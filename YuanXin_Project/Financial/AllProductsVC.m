//
//  AllProductVC.m
//  YuanXin_Project
//
//  Created by Yuanin on 16/4/20.
//  Copyright © 2016年 yuanxin. All rights reserved.
//

#import "AllProductsVC.h"

#import "LoginNavigationController.h"
#import "BuyFinanicalItemVC.h"
#import "ProductDetailVC.h"

#import "MJRefresh.h"
#import "ProductCell.h"
#import "ProductSectionHeader.h"

#import "ProductViewModel.h"

static const NSInteger Regular_Number = 4;

@interface AllProductsVC () <UITableViewDataSource, UITableViewDelegate,UIScrollViewDelegate>

@property (assign, nonatomic) BOOL needRefreshProduct;
@property (strong, nonatomic) RACDisposable *enterForegroundDisposable;

@property (weak, nonatomic) IBOutlet UITableView *productTableView;

@property (strong, nonatomic) ProductViewModel *viewModel;
@property (strong,nonatomic)UIButton *clickToTopIV;
@end

@implementation AllProductsVC

#pragma mark - life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.needRefreshProduct = YES;
    @weakify(self)
    [[[NSNotificationCenter defaultCenter] rac_addObserverForName:UIApplicationDidEnterBackgroundNotification object:nil] subscribeNext:^(id x) {
        @strongify(self)
        self.needRefreshProduct = YES;
    }];
    [[[NSNotificationCenter defaultCenter] rac_addObserverForName:kProductDidBuyNotification object:nil] subscribeNext:^(id x) {
        @strongify(self)
        self.needRefreshProduct = YES;
    }];

}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    if (self.needRefreshProduct) {
        [self refreshProductInfo];
    }
    
    //进入时需要进入前台通知
    @weakify(self)
    self.enterForegroundDisposable = [[[NSNotificationCenter defaultCenter] rac_addObserverForName:UIApplicationWillEnterForegroundNotification object:nil] subscribeNext:^(id x) {
        @strongify(self)
        
        [self performSelector:@selector(refreshProductInfo) withObject:nil];
    }];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
       [self dissBtnToTop];
    //退出此页面是清除进入前台通知
    [self.enterForegroundDisposable dispose];
}
- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    
    [self.viewModel cancelFetchOperation];
}



#pragma mark - UITableViewDataSource & UITableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (self.viewModel.productInfo.count < Regular_Number) return 0;
    
    return 0 == section ? Regular_Number : self.viewModel.productInfo.count - Regular_Number;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    ProductCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([ProductCell class])];
    
    [cell loadInterfactInfoWithProductInfo:[self productInfoWithIndexPath:indexPath]];
    
    @weakify(self)
    cell.purchaseProduct = ^{
        @strongify(self)
        
        if ([UserinfoManager sharedUserinfo].logined) {
            
            BuyFinanicalItemVC *vc  = [AiMiApplication obtainControllerForMainStoryboardWithID:BUY_FINANICAL_STORYBOARD_ID];
            vc.productInfo          = [self productInfoWithIndexPath:indexPath];
            vc.canIntoProductDetail = YES;
            [self.navigationController pushViewController:vc animated:YES];
        } else {
            
            [self.tabBarController presentViewController:[AiMiApplication obtainControllerForStoryboard:LOGIN_STORYBOARD_NAME controller:LOGIN_NAVIGARION_STORYBOARD_ID] animated:YES completion:nil];
        }
    };
    
    return cell;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    ProductSectionHeader *header = [tableView dequeueReusableHeaderFooterViewWithIdentifier:NSStringFromClass([ProductSectionHeader class])];
    header.type = 0 == section ? kRegularProduct : kOptizimationProduct;
    
    return header;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 48;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    ProductDetailVC *vc    = [AiMiApplication obtainControllerForMainStoryboardWithID:PRODUCT_DETAIL_STORYBOARD_ID];
    vc.needShowPastProject = YES;
    vc.productInfo         = [self productInfoWithIndexPath:indexPath];
    [self.navigationController pushViewController:vc animated:YES];
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    //动态修改headerView的位置
    if (scrollView.header.isRefreshing) {
//        if (scrollView.contentOffset.y >= -scrollView.contentInset.top && scrollView.contentOffset.y < 0) {
        if (scrollView.contentOffset.y >= -scrollView.header.mj_h && scrollView.contentOffset.y < 0) {
            //注意:修改scrollView.contentInset时，若使当前界面显示位置发生变化，会触发scrollViewDidScroll:，从而导致死循环。
            //因此此处scrollView.contentInset.top必须为-scrollView.contentOffset.y
            scrollView.contentInset = UIEdgeInsetsMake(-scrollView.contentOffset.y, 0, scrollView.contentInset.bottom, 0);
        } else if (scrollView.contentOffset.y >= 0 && !UIEdgeInsetsEqualToEdgeInsets(scrollView.contentInset, UIEdgeInsetsMake(0, 0, scrollView.contentInset.bottom, 0))) {//到0说明headerView已经在tableView最上方，不需要再修改了
            scrollView.contentInset = UIEdgeInsetsMake(0, 0, scrollView.contentInset.bottom, 0);
        }
    }
    
    if (scrollView.contentOffset.y>([UIScreen mainScreen].bounds.size.height + 180)) {
        
        [self showBtnToTop];
        
    }else{
        [self dissBtnToTop];
    }
}
-(void)showBtnToTop{
    [[UIApplication sharedApplication].keyWindow addSubview:self.clickToTopIV];
}
- (void)dissBtnToTop{
    [self.clickToTopIV removeFromSuperview];
}


#pragma mark - action
- (ProductInfo *)productInfoWithIndexPath:(NSIndexPath *)indexPath {
    
    return self.viewModel.productInfo[indexPath.row + (0 == indexPath.section ? 0 : Regular_Number)];
}

- (void)refreshProductInfo {
    
    if (self.viewModel.productInfo.count) {
        @weakify(self)
        [self refreshProductInfoWithSuccess:^{
            @strongify(self)
            [self.productTableView reloadData];
        } failure:nil];
    } else {
        [self.productTableView.header beginRefreshing];
    }
}

- (void)refreshProductInfoWithSuccess:(void(^)())success failure:(void(^)())failure {
    
    @weakify(self)
    [self.viewModel beginFetchProductInfoWithSuccess:^(id result) {
        @strongify(self)
        
        self.needRefreshProduct = NO;
        PerformEmptyParameterBlock(success);
    } failure:^(NSString *errorDescription) {
        
        [SpringAlertView showMessage:errorDescription];
        PerformEmptyParameterBlock(failure);
    }];
}

#pragma mark - setter
- (void)setProductTableView:(UITableView *)productTableView {
    _productTableView = productTableView;
    
    productTableView.separatorInset = UIEdgeInsetsZero;
    if ([productTableView respondsToSelector:@selector(layoutMargins)]) {
        productTableView.layoutMargins = UIEdgeInsetsZero;
    }
    
    [productTableView registerNib:[UINib nibWithNibName:NSStringFromClass([ProductSectionHeader class]) bundle:nil] forHeaderFooterViewReuseIdentifier:NSStringFromClass([ProductSectionHeader class])];
    @weakify(self)
    productTableView.header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        @strongify(self)
        
        [self refreshProductInfoWithSuccess:^{
            @strongify(self)
            
            [self.productTableView.header endRefreshing];
            [self.productTableView reloadData];
            
        } failure:^{
            @strongify(self)
            
            [self.productTableView.header endRefreshing];
        }];
    }];
    productTableView.footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        @strongify(self)
        
        [self.viewModel fetchNextPageProductInfoWithSuccess:^(id result) {
            @strongify(self)
            
            [self.productTableView.footer endRefreshing];
            [self.productTableView reloadData];
        } failure:^(NSString *errorDescription) {
            @strongify(self)
            
            [self.productTableView.footer endRefreshing];
            [SpringAlertView showMessage:errorDescription];
        }];
    }];
}

#pragma mark - getter
- (ProductViewModel *)viewModel {
    
    if (!_viewModel) {
        _viewModel = [[ProductViewModel alloc] init];
    }
    return _viewModel;
}
- (UIButton *)clickToTopIV{
    if (!_clickToTopIV) {
        _clickToTopIV = [[UIButton alloc]initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width - 70, [UIScreen mainScreen].bounds.size.height - 120, 50, 50)];
        [_clickToTopIV addTarget:self action:@selector(ClickToTop) forControlEvents:UIControlEventTouchUpInside];
        [_clickToTopIV setImage:[UIImage imageNamed:@"XS"] forState:UIControlStateNormal];
        _clickToTopIV.backgroundColor = [UIColor clearColor];
    }
    return _clickToTopIV;
}
- (void)ClickToTop{
    [self.productTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionNone animated:YES] ;
}
@end
