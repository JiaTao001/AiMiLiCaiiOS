//
//  ProductDetailView.m
//  YuanXin_Project
//
//  Created by Yuanin on 16/9/19.
//  Copyright © 2016年 yuanxin. All rights reserved.
//

#import "ProductDetailView.h"

#import "MessageForwarder.h"
#import "DemitintBehavior.h"
#import "ExclusiveButton.h"

#import "HorizontalScrollView.h"

@interface ProductDetailView () <UIScrollViewDelegate, UIWebViewDelegate>

@property (strong, nonatomic) IBOutlet MessageForwarder *messageForwarder;
@property (strong, nonatomic) IBOutlet Demitint *demitint;
@property (strong, nonatomic) IBOutlet DemitintBehavior *demitintBehavior;
@property (strong, nonatomic) IBOutlet ExclusiveButton *exclusive;

@property (weak, nonatomic) IBOutlet HorizontalScrollView *contentManager;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *xLine;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *subViewTopConstraint;

@property (strong, nonatomic, readwrite) ProjectDetailView      *projectView;
@property (strong, nonatomic, readwrite) RecordView             *recordView;
@property (strong, nonatomic, readwrite) ProjectInformationView *projectInfoView;
@property (strong, nonatomic, readwrite) RepaymentView          *repaymentView;

@end

@implementation ProductDetailView
@synthesize projectInfo = _projectInfo;

+ (instancetype)productDetailView
{
    ProductDetailView *result = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([ProductDetailView class]) owner:nil options:nil] firstObject];
    if ([result isKindOfClass:[ProductDetailView class]]) {
        
        result.contentManager.contentSubviews = @[result.projectView, result.projectInfoView, result.recordView, result.repaymentView];
        return result;
    } else {
        return nil;
    }
}

#pragma mark - Action
- (void)subviewDidChangeContentY:(CGFloat)contentY
{
    self.subViewTopConstraint.constant = contentY <= 0 ? -contentY : 0;
    
}

- (void)configureProductDetailSubView:(ProductDetailSubView *)subView
{
    @weakify(self)
    subView.changeContentY = ^(CGFloat contentY){
        @strongify(self)
        [self subviewDidChangeContentY:contentY];
    };
    subView.shouldChangeShowView = ^{
        @strongify(self)
        PerformEmptyParameterBlock(self.shouldChangeShowView);
    };
}

#pragma mark - getter
- (ProjectDetailView *)projectView
{
    if (!_projectView) {
        _projectView = [[ProjectDetailView alloc] init];
        
        [self configureProductDetailSubView:_projectView];
      
    }
    [_projectView beginRefresh];
    return _projectView;
}

- (ProjectInformationView *)projectInfoView
{
    if (!_projectInfoView) {
        _projectInfoView = [[ProjectInformationView alloc] init];
        
        [self configureProductDetailSubView:_projectInfoView];
    }
    return _projectInfoView;
}

- (RecordView *)recordView
{
    if (!_recordView) {
        _recordView = [[RecordView alloc] init];
        
        [self configureProductDetailSubView:_recordView];
    }
    return _recordView;
}

- (RepaymentView *)repaymentView
{
    if (!_repaymentView) {
        _repaymentView = [[RepaymentView alloc] init];
        
        [self configureProductDetailSubView:_repaymentView];
    }
    return _repaymentView;
}

#pragma mark - Setter
- (void)setExclusive:(ExclusiveButton *)exclusive
{
    _exclusive = exclusive;

    @weakify(self)
    exclusive.invalidButtonWillChangeBlock = ^(UIButton *newInvalidButton) {
        @strongify(self)
        
        [self.contentManager.presentingSubview stopRefreshing];
                
        self.contentManager.contentOffset = CGPointMake(self.contentManager.width*(newInvalidButton.tag - 1), 0);
        
        [self.contentManager.presentingSubview beginRefresh];
    };
}

- (void)setContentManager:(HorizontalScrollView *)contentManager
{
    _contentManager = contentManager;
    
    @weakify(self)
    [RACObserve(contentManager, contentOffset) subscribeNext:^(NSNumber *x) {
        @strongify(self)
        if (self.contentManager.subviews.count) {
            dispatch_async(dispatch_get_main_queue(), ^{
                self.xLine.constant = x.CGPointValue.x/self.contentManager.subviews.count;
            });
        }
    }];
}

- (void)setProductID:(NSString *)productID
{
    _productID = productID;
    self.projectView.productID = productID;
    self.projectInfoView.productID = productID;
    self.recordView.productID = productID;
    self.repaymentView.productID = productID;
}

- (void)setProjectInfo:(NSDictionary *)projectInfo
{
    self.projectView.projectInfo = projectInfo;
}

- (NSDictionary *)projectInfo
{
    return self.projectView.projectInfo;
}


#pragma mark - Dealloc 
- (void)dealloc
{
    [self.contentManager.presentingSubview stopRefreshing];
}
@end
