//
//  ViewController.m
//  YuanXin_Project
//
//  Created by Sword on 15/9/14.
//  Copyright (c) 2015年 yuanxin. All rights reserved.
//

#import "HomepageVC.h"

#import "LoginNavigationController.h"
#import "ProductDetailVC.h"
#import "BannerWebVC.h"
#import "RuleWebVC.h"
#import "BuyFinanicalItemVC.h"
#import "AnnouncementDetailVC.h"
#import "AnnouncementsVC.h"

#import "BonusEventVC.h"

#import "BannerShufflingView.h"
#import "AiMiGuidePage.h"
#import "HomepageItemView.h"
#import "RecommendProductCell.h"
#import "JitterImageView.h"
#import "MJRefresh.h"

#import "RecommendProductViewModel.h"

#import "UINavigationBar+BackgroundColor.h"

#import <TencentOpenAPI/QQApiInterface.h>
#import "WXApi.h"

#define HREF_KEY @"href"
#define SORT_KEY @"sort"
#define SRC_KEY  @"src"

#define BANNER_INTO_REGULAR @"1"
#define Background_View_Xib_Nime @"BackgroundView"

static const CGFloat banner_ratio = 25.0/11;

@interface HomepageVC () <BannerShufflingViewDataSource, UITableViewDelegate, UITableViewDataSource,UIScrollViewDelegate>

@property (assign, nonatomic) BOOL needRefreshRecommend;
@property (strong, nonatomic) RACDisposable *enterForegroundDisposable; /**< 用于进入前台通知的  disposal work */

@property (strong, nonatomic) RecommendProductViewModel *recommendViewModel;

@property (weak, nonatomic) IBOutlet UITableView *superTableview;
@property (strong, nonatomic) HomepageItemView    *itemView;
@property (strong, nonatomic) BannerShufflingView *bannerView;
@property (strong, nonatomic) JitterImageView *jitterImageView;

@property (strong, nonatomic) NSArray *bannerList;

@property (strong, nonatomic) NSArray *recommendedProductList;
@end

@implementation HomepageVC

#pragma mark - life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    [NetworkContectManager sessionPOSTWithMothed:@"version_ios" params:nil success:^(NSURLSessionTask *task, id result) {
        [AlertViewManager showInViewController:self title:@"提示" message:@"有新版本需要更新，您是否马上去更新" clickedButtonAtIndex:^(id alertView, NSInteger buttonIndex) {
            if (1 == buttonIndex) {
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"itms-apps://itunes.apple.com/app/id1055223837"]];
            }
        } cancelButtonTitle:@"暂不更新" otherButtonTitles:@"去更新", nil];
    } failure:nil];
    
    //   self.navigationController.navigationBar.alpha  =0;
    [self changeNavigationBarAlpha:0];
    self.bannerList = [[NSArray alloc] initWithContentsOfFile:[AiMiApplication pathForCachesWithFileName:bannerPath]];
    
    self.needRefreshRecommend = YES;
    
    @weakify(self)
    [[[NSNotificationCenter defaultCenter] rac_addObserverForName:UIApplicationDidEnterBackgroundNotification object:nil] subscribeNext:^(id x) {
        @strongify(self)
        self.needRefreshRecommend = YES;
    }];
    [[[NSNotificationCenter defaultCenter] rac_addObserverForName:kRecommendShouldChangeNotification object:nil] subscribeNext:^(NSDictionary *userinfo) {
        @strongify(self)
        self.needRefreshRecommend = YES;
    }];
    if (@available(iOS 11.0, *)) {
        self.superTableview.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        self.superTableview.contentInset = UIEdgeInsetsMake(64, 0, 49, 0);
        self.superTableview.scrollIndicatorInsets = self.superTableview.contentInset;
    }
    [RACObserve([UserinfoManager sharedUserinfo], logined) subscribeNext:^(NSNumber *x) {
        @strongify(self)
        
        
        [self.itemView referceUIWithIslog:x];
        [self.superTableview reloadData];
        
    }];
    
    
    [self fetchBanner];
    //    [self fetchNotice];
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.enterForegroundDisposable dispose];
    @weakify(self)
    self.enterForegroundDisposable = [[[NSNotificationCenter defaultCenter] rac_addObserverForName:UIApplicationWillEnterForegroundNotification object:nil] subscribeNext:^(id x) {
        @strongify(self)
        
        [self performSelector:@selector(refreshRecommendProductInfo) withObject:nil];
    }];
    if (self.needRefreshRecommend) {
        [self refreshRecommendProductInfo];
    }
    if (!self.bannerList.count) {
        [self fetchBanner];
    }
    
    [self.itemView referceUIWithIslog:[[UserinfoManager sharedUserinfo] logined] ];
    
}
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [self.bannerView startScroll];
    self.navigationController.navigationBar.userInteractionEnabled = NO;
}
- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    
    [self.bannerView stopScroll];
    [self.recommendViewModel cancelFetchOperation];
    [self.enterForegroundDisposable dispose];
    self.navigationController.navigationBar.userInteractionEnabled = YES;
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    if (self.superTableview.contentOffset.y > 0 && self.superTableview.contentOffset.y < 64) {
        [self changeNavigationBarAlpha:self.superTableview.contentOffset.y/64.0];
        //        self.navigationController.navigationBar.alpha  =self.superTableview.contentOffset.y/64.0;
        self.navigationItem.title = @"首页";
    }else if(self.superTableview.contentOffset.y >= 64){
        [self changeNavigationBarAlpha:1];
        //        self.navigationController.navigationBar.alpha  =1;
        self.navigationItem.title = @"首页";
    }else{
        [self changeNavigationBarAlpha:0];
        //        self.navigationController.navigationBar.alpha  =0;
        self.navigationItem.title = nil;
    }
}

#pragma mark - dataSource
- (void)imageLoop:(BannerShufflingView *)scrollView visiableImageView:(UIImageView *)imageView imageForRow:(NSInteger)row {
    
    [imageView  loadImageWithPath:self.bannerList[row][SRC_KEY]];
}
- (NSInteger)imageLoopNumberOfRow:(BannerShufflingView *)scrollView {
    
    return self.bannerList.count;
}

//UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return  self.recommendViewModel.recommendProductInfo.count-1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    RecommendProductCell *cell = [tableView dequeueReusableCellWithIdentifier:Recommend_Product_Identifier];
    
    [cell loadInterfactInfoWithProductInfo:self.recommendViewModel.recommendProductInfo[indexPath.row +1]];
    
    
    @weakify(self)
    cell.purchaseProduct = ^{
        @strongify(self)
        
        if ([UserinfoManager sharedUserinfo].logined) {
            
            BuyFinanicalItemVC *vc = [AiMiApplication obtainControllerForMainStoryboardWithID:BUY_FINANICAL_STORYBOARD_ID];
            
            vc.productInfo   = self.recommendViewModel.recommendProductInfo[indexPath.row+1];
            vc.canIntoProductDetail = YES;
            [self.navigationController pushViewController:vc animated:YES];
        } else {
            
            [self intoLoginViewController];
        }
    };
    
    
    //
    return cell;
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    ProductDetailVC *vc = [AiMiApplication obtainControllerForMainStoryboardWithID:PRODUCT_DETAIL_STORYBOARD_ID];
    
    vc.needShowPastProject = YES;
    vc.productInfo   = self.recommendViewModel.recommendProductInfo[indexPath.row+1];
    [self.navigationController pushViewController:vc animated:YES];
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    float height;
    if ([[UserinfoManager sharedUserinfo] logined]) {
        height = 445 - 74;
    }else{
        height = 445 - 80;
    }
    
    return 0 == section ? height : 0;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 50;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 50)];
    UILabel *lable = [[UILabel alloc]initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width/2 -100, 10,200 , 20)];
    lable.font  = [UIFont systemFontOfSize:14.0f];
    lable.textColor = [UIColor orangeColor];
    lable.textAlignment = NSTextAlignmentCenter;
    lable.text = @"市场有风险,出借需谨慎";
    [view addSubview:lable];
 
    return view;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    return 0 == section ? self.itemView : nil;
}

#pragma mark - private

- (void)fetchBanner {
    
    @weakify(self)
    [NetworkContectManager sessionPOSTWithMothed:@"bannernotice_new" params:nil success:^(NSURLSessionTask *task, id result) {
        @strongify(self)
        
        self.bannerList = result[RESULT_DATA];
    } failure:^(NSURLSessionTask *task, id result, NSString *errorDescription) {
        
        [SpringAlertView showMessage:errorDescription];
    }];
}



- (void)intoNextViewControllerWithPath:(NSString *)path Is_Red:(int)is_red {
    
    if (path) {
        if ([path hasPrefix:@"http"]) {
            
            BannerWebVC *web = [[BannerWebVC alloc] init];
            web.hidesBottomBarWhenPushed = YES;
            if ([web prepareLoadWebPath:path Is_Red:is_red]) {
                [self.navigationController pushViewController:web animated:YES];
            }
        } else if ([BANNER_INTO_REGULAR isEqualToString:path]) {
            
            self.tabBarController.selectedIndex = 1;
        }
    }
}
- (void)intoLoginViewController {
    
    [self.tabBarController presentViewController:[AiMiApplication obtainControllerForStoryboard:LOGIN_STORYBOARD_NAME controller:LOGIN_NAVIGARION_STORYBOARD_ID] animated:YES completion:nil];
}

- (void)refreshRecommendProductInfo {
    
    if (self.recommendViewModel.recommendProductInfo.count) {
        @weakify(self)
        [self refreshRecommendProductInfoWithSuccess:^{
            @strongify(self)
            [self.superTableview reloadData];
        } failure:nil];
    } else {
        [self.superTableview.header beginRefreshing];
    }
}

- (void)refreshRecommendProductInfoWithSuccess:(void(^)()) success failure:(void(^)()) failure {
    
    @weakify(self)
    [self.recommendViewModel fetchRecommendProductInfoWithSuccess:^(id result) {
        @strongify(self)
        
        self.needRefreshRecommend = NO;
        PerformEmptyParameterBlock(success);
        if (self.recommendViewModel.recommendProductInfo[0]) {
           self.itemView.aInfo = self.recommendViewModel.recommendProductInfo[0] ;
        }
   
        if (1 == [[result[RESULT_DATA] firstObject][Have_Red_Key] integerValue]) {
            [self.jitterImageView showInView:self.view withAnimation:NO  clickImage:^{
                @strongify(self)
                
                if ([UserinfoManager sharedUserinfo].logined) {
                    BonusEventVC *vc = [[BonusEventVC alloc] init];
                    vc.hidesBottomBarWhenPushed = YES;
                    [self.navigationController pushViewController:vc animated:YES];
                } else {
                    [self intoLoginViewController];
                }
            }];
            self.superTableview.contentInset = UIEdgeInsetsMake(0, 0, self.jitterImageView.height + BIG_MARGIN_DISTANCE, 0);
            
            
        } else if(self.jitterImageView.superview) {
            
            [self.jitterImageView removeFromSuperview];
        }
        
    } failure:^(NSString *errorDescription) {
        @strongify(self)
        
        [SpringAlertView showInWindow:self.view.window message:errorDescription];
        PerformEmptyParameterBlock(failure);
    }];
    
}

#pragma mark -  setter
- (void)setSuperTableview:(UITableView *)superTableview {
    _superTableview = superTableview;
    
    superTableview.sectionFooterHeight = 0;
    superTableview.tableFooterView = [UIView new];
    @weakify(self)
    superTableview.header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        
        @strongify(self)
        [self refreshRecommendProductInfoWithSuccess:^{
            @strongify(self)
            
            [self.superTableview.header endRefreshing];
            [self.superTableview reloadData];
            if (!self.bannerList.count) {
                [self fetchBanner];
            }
            
        } failure:^{
            @strongify(self)
            
            [self.superTableview.header endRefreshing];
        }];
    }];
    
}
- (void)setBannerList:(NSArray *)bannerList {
    if (!bannerList.count || [bannerList isEqualToArray:_bannerList]) return;
    
    NSMutableArray *mutArr = [NSMutableArray arrayWithCapacity:0];
    NSMutableArray *mutArr2 = [NSMutableArray arrayWithCapacity:0];
    for (NSInteger i = 0; i<bannerList.count; i++) {
        NSDictionary *dict = bannerList[i];
        if ([dict[@"sort"] integerValue] == 100) {
            [mutArr2 addObject:dict];
        }else{
            [mutArr addObject:dict];
        }
    }
    [mutArr sortUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        return [obj1[SORT_KEY] compare:obj2[SORT_KEY]];
    }];
    
    //    self.itemView.announcementInfo = [AnnouncementInfo announcementInfoWithDictionary:[mutArr lastObject]];
    
    
    
    self.itemView.announcementInfos =  mutArr2;
    _bannerList = mutArr;
    [self.bannerView reloadData];
    
    if (!self.superTableview.tableHeaderView) {
        [self.superTableview beginUpdates];
        self.superTableview.tableHeaderView = self.bannerView;
        [self.superTableview endUpdates];
    }
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [bannerList writeToFile:[AiMiApplication pathForCachesWithFileName:bannerPath] atomically:YES];
    });
}



#pragma mark - getter
- (HomepageItemView *)itemView {
    
    if (!_itemView) {
        
        @weakify(self)
        HomepageItemView *view = [HomepageItemView homepageItemViewWithIsLogin:[[UserinfoManager sharedUserinfo] logined] ProductInfo:nil  SelectBlock:^(NSInteger index) {
            @strongify(self)
            
            if (0 == index) {
                
                WebVC *vc = [[WebVC alloc] initWithWebPath:[CommonTools completeWebPathWithSubpath:Introduce_Safe]];
                [self.navigationController pushViewController:vc animated:YES];
            }
            if (2 == index) {
                
                WebVC *vc = [[WebVC alloc] initWithWebPath:[CommonTools completeWebPathWithSubpath:Introduce_Help]];
                [self.navigationController pushViewController:vc animated:YES];
            }
            if (1 == index) {
                
                if ([UserinfoManager sharedUserinfo].logined) {
                    
                    RuleWebVC *vc = [[RuleWebVC alloc] init];
                    vc.hidesBottomBarWhenPushed = YES;
                    [self.navigationController pushViewController:vc animated:YES];
                } else {
                    [self intoLoginViewController];
                }
            }
            if (3 == index) {
                
                WebVC *vc = [[WebVC alloc] initWithWebPath:[CommonTools completeWebPathWithSubpath:Data_Report]];
                [self.navigationController pushViewController:vc animated:YES];
            }
            if (4 == index) {
                LoginNavigationController *loginController = [AiMiApplication obtainControllerForStoryboard:LOGIN_STORYBOARD_NAME controller:LOGIN_NAVIGARION_STORYBOARD_ID];
                [loginController changeRootViewControllerForRegister];
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.tabBarController presentViewController:loginController animated:YES completion:nil];
                });
            }
            if (5 == index) {
                
                if ([UserinfoManager sharedUserinfo].logined) {
                    
                    //                    BuyFinanicalItemVC *vc = [AiMiApplication obtainControllerForMainStoryboardWithID:BUY_FINANICAL_STORYBOARD_ID];
                    //
                    //                    vc.productInfo   = self.recommendViewModel.recommendProductInfo[0];
                    //                    vc.canIntoProductDetail = YES;
                    //                    [self.navigationController pushViewController:vc animated:YES];
                    
                    ProductDetailVC *vc = [AiMiApplication obtainControllerForMainStoryboardWithID:PRODUCT_DETAIL_STORYBOARD_ID];
                    
                    vc.needShowPastProject = YES;
                    vc.productInfo   = self.recommendViewModel.recommendProductInfo[0];
                    [self.navigationController pushViewController:vc animated:YES];
                } else {
                    
                    [self intoLoginViewController];
                }
            }
            
        }];
        view.checkSpecificAnnoucement = ^(AnnouncementInfo *aInfo) {
            @strongify(self)
            
            AnnouncementDetailVC *vc = [[AnnouncementDetailVC alloc] init];
            vc.annoucementInfo = aInfo;
            vc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:vc animated:YES];
        };
        view.checkAllAnnoucemtes = ^{
            @strongify(self)
            
            AnnouncementsVC *vc = [AiMiApplication obtainControllerForMainStoryboardWithID:NSStringFromClass([AnnouncementsVC class])];
            vc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:vc animated:YES];
        };
        _itemView = view;
    }
    return _itemView;
}
- (BannerShufflingView *)bannerView {
    
    if (!_bannerView) {
        
        BannerShufflingView *imageLoop = [[BannerShufflingView alloc] init];
        
        imageLoop.bounds = CGRectMake(0, 0, UISCREEN_WIDTH, UISCREEN_WIDTH/banner_ratio);
        imageLoop.dataSource = self;
        
        @weakify(self)
        [imageLoop setClickImageView:^(BannerShufflingView *loopView, NSInteger index) {
            @strongify(self)
            [self intoNextViewControllerWithPath:self.bannerList[index][HREF_KEY] Is_Red:[self.bannerList[index][@"is_red"] intValue]];
        }];
        
        _bannerView = imageLoop;
    }
    return _bannerView;
}
- (RecommendProductViewModel *)recommendViewModel {
    
    if (!_recommendViewModel) {
        _recommendViewModel = [[RecommendProductViewModel alloc] init];
    }
    return _recommendViewModel;
}
- (JitterImageView *)jitterImageView {
    if (!_jitterImageView) {
        _jitterImageView = [[JitterImageView alloc] init];
    }
    return _jitterImageView;
}

@end

