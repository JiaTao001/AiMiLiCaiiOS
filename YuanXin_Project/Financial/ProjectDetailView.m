//
//  ProjectDetailView.m
//  YuanXin_Project
//
//  Created by Yuanin on 16/1/13.
//  Copyright © 2016年 yuanxin. All rights reserved.
//

#import "ProjectDetailView.h"


@implementation ProductDetailCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        if ([self respondsToSelector:@selector(layoutMargins)]) {
            self.layoutMargins = UIEdgeInsetsMake(0, BIG_MARGIN_DISTANCE, 0, BIG_MARGIN_DISTANCE);
        }
//        [self.contentView addSubview:self.title];
//        [self.contentView addSubview:self.detail];
        [self addSubviews];
//        [self.contentView setNeedsUpdateConstraints];
//        [self.contentView updateConstraintsIfNeeded];
    }
    
    return self;
}
- (void)addSubviews{
    
    
    [self.contentView addSubview:self.title];
    
    [self.contentView addSubview:self.detail];
    
    [self.contentView addSubview:self.icon];

    [self.contentView addSubview:self.type];

    
     [self.contentView addSubview:self.jiange];
    
    
    
}
- (void)updateConstraints {
    [super updateConstraints];
//
////    if (self.title.translatesAutoresizingMaskIntoConstraints) {
////        self.title.translatesAutoresizingMaskIntoConstraints = self.detail.translatesAutoresizingMaskIntoConstraints = NO;
////        
////        NSArray *hCon = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(margin)-[_title]-(>=margin)-[_detail]-(margin)-|" options:0 metrics:@{@"margin":@(BIG_MARGIN_DISTANCE)} views:NSDictionaryOfVariableBindings(_detail, _title)];
      NSArray *hCon = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(margin)-[_detail]-(margin)-|" options:0 metrics:@{@"margin":@(BIG_MARGIN_DISTANCE)} views:NSDictionaryOfVariableBindings(_detail)];
     NSArray *hCon2 = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-[_title]-(margin)-[_detail]-|" options:0 metrics:@{@"margin":@(BIG_MARGIN_DISTANCE)} views:NSDictionaryOfVariableBindings(_detail, _title)];
//
////        NSLayoutConstraint *vDetailCon = [NSLayoutConstraint constraintWithItem:_detail attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeCenterY multiplier:1.0f constant:0];
////        NSLayoutConstraint *vTitleCon = [NSLayoutConstraint constraintWithItem:_title attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeCenterY multiplier:1.0f constant:0];
////        
////        
//        [self.contentView addConstraints:hCon];
////      [self.contentView addConstraints:hCon2];
////        [self.contentView addConstraint:vDetailCon];
////        [self.contentView addConstraint:vTitleCon];
////    }
}

- (void)configCellWithKeyInfo:(NSDictionary *)keyInfo dictionary:(NSDictionary *)aDic {
    
    self.title.text  = keyInfo[PRODUCT_DETAIL_TITLE];
    self.detail.text = [CommonTools convertToStringWithObject:aDic[keyInfo[PRODUCT_DETAIL_KEY]]];
    
    if ([@"maxbuyvote" isEqualToString:keyInfo[PRODUCT_DETAIL_KEY]] & (0 == self.detail.text.integerValue)) {
        self.detail.text = @"不限";
    }
    
//    [self.title sizeToFit];
//    [self.detail sizeToFit];
}
- (void)configCellWithdictionary:(NSDictionary *)aDic {
    
    
    
    //    [self.title sizeToFit];
    //    [self.detail sizeToFit];
}

- (UILabel *)title {
    
    if (!_title) {
        UILabel *title  = [[UILabel alloc] initWithFrame:CGRectMake(50, 20, 64, 16)];
        title.font      = [UIFont systemFontOfSize:Button_Font_Size];
        title.textColor = Font_Normal_Gray;
//        [title setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
//        title.backgroundColor = [UIColor blueColor];
        _title = title;
    }
    return _title;
}
- (UILabel *)type{
    if (!_type) {
        _type = [[UILabel alloc]initWithFrame:CGRectMake(144, 20, 100, 16)];
//        _type.backgroundColor = [UIColor cyanColor];
        _type.font      = [UIFont systemFontOfSize:Button_Font_Size];
        _type.textColor = Theme_Color;
    }
    return _type;
}
- (UILabel *)detail {
    
    if (!_detail) {
        UILabel *detail      = [[UILabel alloc] initWithFrame:CGRectMake(20, 50, [UIScreen mainScreen].bounds.size.width - 40, 0)];

        detail.font          = [UIFont systemFontOfSize:MIN_FONT_SIZE];
        detail.textColor     = Font_Shallow_Gray;

        detail.numberOfLines = 0;
        _detail.backgroundColor = [UIColor redColor];
        _detail.userInteractionEnabled = NO;
        _detail = detail;
    }
    return _detail;
}
- (UILabel *)jiange{
    if (!_jiange) {
        _jiange = [[UILabel alloc]initWithFrame:CGRectMake(124, 18, 10, 16)];
        _jiange.text = @"|";
        _jiange.textColor     = Font_Shallow_Gray;
    }
    return _jiange;
}

- (UIImageView *)icon{
    if (!_icon ) {
        _icon = [[UIImageView alloc]initWithFrame:CGRectMake(20, 17, 20, 20)];
        _icon.image = [UIImage imageNamed:@"anquan_"];
        
    }
    return _icon;
}
@end




//@interface ProjectDetailView() <UITableViewDataSource, UITableViewDelegate>
//
////@property (strong, nonatomic) UITableView    *tableView;
////@property (strong, nonatomic) NSMutableArray *productKeyInfo;
//@end
//
//@implementation ProjectDetailView

//- (instancetype)initWithFrame:(CGRect)frame {
//    self = [super initWithFrame:frame];
//    if (self) {
//
//        [self configureDefaultValue];
//    }
//    return self;
//}
//- (instancetype)initWithCoder:(NSCoder *)aDecoder {
//    self = [super initWithCoder:aDecoder];
//    if (self) {
//
//        [self configureDefaultValue];
//    }
//    return self;
//}
//
//- (void)configureDefaultValue {
//
//    [self addSubview:self.tableView];
//}
//- (void)layoutSubviews {
//    [super layoutSubviews];
//
//    self.tableView.frame = self.bounds;
//}
//
//
//#pragma mark - UITableView dataSource & delegate
//- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//
//    return 3;
//}
//- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
//
//    ProductDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:PRODUCT_CELL_IDENTIFIER];
//
//
//
//    if (indexPath.row == 0) {
//        cell.icon.image = [UIImage imageNamed:@"anquan_"];
//        cell.title.text = @"保障方式";
//        cell.type.text = self.projectInfo[@"guarantee_method"];
//        cell.detail.text = self.projectInfo[@"guarantee_con"];
//
//    }
//    if (indexPath.row == 1) {
//        cell.icon.image = [UIImage imageNamed:@"xiangmu_"];
//        cell.title.text = @"项目类型";
//        cell.type.text = self.projectInfo[@"debtstype"];
//        cell.detail.text = self.projectInfo[@"debtstype_con"];
//
//    }
//    if (indexPath.row == 2) {
//        cell.icon.image = [UIImage imageNamed:@"huankuan_"];
//        cell.title.text = @"还款方式";
//        cell.type.text = self.projectInfo[@"repay_method"];
//        cell.detail.text = self.projectInfo[@"repay_con"];
//
//    }
//
//    CGFloat height =  [self sizeWithFont:[UIFont systemFontOfSize:13.0] maxW:[UIScreen mainScreen].bounds.size.width - 40 withContent:cell.detail.text];
//    cell.detail.frame = CGRectMake(20, 50, [UIScreen mainScreen].bounds.size.width - 40, height);
//
//
//    cell.rowHeight = height + 70;
//
//
//
//
//
//
//
//
//
//    return cell;
//}
//-(CGFloat)sizeWithFont:(UIFont *)font maxW:(CGFloat) maxW withContent:(NSString *)testStr{
//
//    NSDictionary *textAttrs = @{NSFontAttributeName : font};
//    CGSize size = CGSizeMake(maxW, MAXFLOAT);
//    return [testStr boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin attributes:textAttrs context:nil].size.height;
//}
//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
//    ProductDetailCell *cell = (ProductDetailCell *)[self tableView:tableView cellForRowAtIndexPath:indexPath];
//    return cell.rowHeight;
//}
//
//
//- (UITableView *)tableView {
//
//    if (!_tableView) {
//        UITableView *tableView = [[UITableView alloc] initWithFrame:self.bounds style:UITableViewStylePlain];
//
//        [tableView registerClass:[ProductDetailCell class] forCellReuseIdentifier:PRODUCT_CELL_IDENTIFIER];
//
//        tableView.showsVerticalScrollIndicator = NO;
//        tableView.tableFooterView = [UIView new];
////        tableView.rowHeight = 135;
//        tableView.separatorColor  = Single_Line_Gray;
//        tableView.separatorInset  = UIEdgeInsetsZero;
//        if ([tableView respondsToSelector:@selector(layoutMargins)]) {
//            tableView.layoutMargins = UIEdgeInsetsZero;
//        }
//
//        tableView.delegate   = self;
//        tableView.dataSource = self;
//
//        _tableView = tableView;
//    }
//    return _tableView;
//}
//
//- (NSMutableArray *)productKeyInfo {
//
//    if (!_productKeyInfo) {
//        NSString *path = [[NSBundle mainBundle] pathForResource:PRODUCT_KEY_PLIST ofType:nil];
//        _productKeyInfo = [[NSMutableArray alloc] initWithContentsOfFile:path];
//    }
//    return _productKeyInfo;
//}
//
//
//- (void)setProjectInfo:(NSDictionary *)projectInfo {
//    _projectInfo = projectInfo;
//
//    if (![projectInfo[@"guaranteecompany"] length]) {
//
//        [self.productKeyInfo removeObjectAtIndex:5];
//    }
//    if (![projectInfo[@"debtstype"] length]) {
//
//        [self.productKeyInfo removeObjectAtIndex:3];
//    }
//    if (![projectInfo[@"collateral"] length]) {
//
//        [self.productKeyInfo removeObjectAtIndex:2];
//    }
//
//    [self.tableView reloadData];
//}
//
//  ProjectInformationView.m
//  YuanXin_Project
//
//  Created by Yuanin on 16/9/23.
//  Copyright © 2016年 yuanxin. All rights reserved.
//



@interface ProjectDetailView () <UIWebViewDelegate>

@property (strong, nonatomic, readwrite) UIWebView *projectInfoView;
@end

@implementation ProjectDetailView

- (void)layoutSubviews
{
    [super layoutSubviews];
    self.projectInfoView.frame = self.bounds;
}

#pragma mark - UIWebView delegate
- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    webView.tag = NO;
    [USERDEFAULTS setInteger:0 forKey:@"WebKitCacheModelPreferenceKey"];
}

- (void)beginRefresh
{
    if (self.projectInfoView.tag) {
        NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@html/project_details.php?productid=%@", hostUrl, self.productID]];
        [self.projectInfoView loadRequest:[NSURLRequest requestWithURL:url]];
    }
}
- (void)stopRefreshing
{
    [self.projectInfoView stopLoading];
}

#pragma mark - Getter
- (UIWebView *)projectInfoView
{
    if (!_projectInfoView) {
        _projectInfoView = [[UIWebView alloc] init];
        
        _projectInfoView.scrollView.delegate = self;
        _projectInfoView.backgroundColor = [UIColor whiteColor];
        _projectInfoView.delegate = self;
        _projectInfoView.tag = YES; //YES 代表需要刷新
        _projectInfoView.scrollView.showsVerticalScrollIndicator = NO;
        
        [self addSubview:_projectInfoView];
    }
    return _projectInfoView;
}

@end



