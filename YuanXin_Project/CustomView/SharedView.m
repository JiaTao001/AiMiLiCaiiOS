//
//  SharedView.m
//  YuanXin_Project
//
//  Created by Yuanin on 15/11/3.
//  Copyright © 2015年 yuanxin. All rights reserved.
//

#import "SharedView.h"
#import "HorizontalCollectionViewLayout.h"
#import <TencentOpenAPI/QQApiInterface.h>
#import "WXApi.h"


@interface CollectionInfo : NSObject

@property (strong, nonatomic) NSString *sharedType;
@property (strong, nonatomic) NSString *imageName;
@property (strong, nonatomic) NSString *title;

+ (instancetype)sharedType:(NSString *)sharedType;
- (instancetype)initWithSharedType:(NSString *)sharedType;
@end

@implementation CollectionInfo

+ (instancetype)sharedType:(NSString *)sharedType {
    
    return [[CollectionInfo alloc] initWithSharedType:sharedType];
}
- (instancetype)initWithSharedType:(NSString *)sharedType {
    
    if (self = [super init]) {
        _sharedType = sharedType;
        
        if ([sharedType isEqualToString:kSharedQQ]) {
            _imageName = @"shared_qq";
            _title = @"QQ好友";
        } else if ([sharedType isEqualToString:kSharedQzone]) {
            _imageName = @"shared_qzone";
            _title = @"QQ空间";
        } else if ([sharedType isEqualToString:kSharedWechat]) {
            _imageName = @"shared_wx";
            _title = @"微信好友";
        } else if ([sharedType isEqualToString:kSharedWechatFriend]) {
            _imageName = @"shared_timeline";
            _title = @"微信朋友圈";
        }
    }
    return self;
}

@end




#define TITLE_HEIGHT 20
#define TOP_MARGIN 5
#define COLLECTION_IDENTIFIER @"CollectionCell"
@interface CollectionCell : UICollectionViewCell

@property (strong, nonatomic) UIImageView *imageView;
@property (strong, nonatomic) UILabel *title;

- (void)loadCellWithInfo:(CollectionInfo *)info;
@end

@implementation CollectionCell

- (instancetype)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.contentView.clipsToBounds = NO;
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    CGPoint center = CGPointMake(CGRectGetWidth(self.frame)/2, CGRectGetHeight(self.frame)/2);
    center.y = center.y - TITLE_HEIGHT/2;
    self.imageView.center = center;
    
    center.y = CGRectGetMaxY(self.imageView.frame) + TOP_MARGIN + TITLE_HEIGHT/2;
    self.title.center = center;
}

- (void)loadCellWithInfo:(CollectionInfo *)info {
    
    self.imageView.image = [UIImage imageNamed:info.imageName];
    self.title.text = info.title;
    
    [self.imageView sizeToFit];
    [self.title sizeToFit];
}

- (UIImageView *)imageView {
    if (!_imageView) {
        _imageView = [[UIImageView alloc] init];
        
        [self addSubview:_imageView];
    }
    return _imageView;
}
- (UILabel *)title {
    
    if (!_title) {
        _title = [[UILabel alloc] init];
        
        _title.textAlignment = NSTextAlignmentCenter;
        _title.font = [UIFont systemFontOfSize:MIN_FONT_SIZE];
        
        [self addSubview:_title];
    }
    return _title;
}

- (NSString *)description {
    
    return [NSString stringWithFormat:@"title --- %@", self.title];
}

@end


//////////////////////////////
////////// SharedView
/////////////////////////
#define ANIMATION_DISTANCE 0.25f
#define Cancel_Height 40

@interface SharedView() <UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@property (strong, nonatomic) UIView *backgroundView;
@property (strong, nonatomic) UIView *bottomView;
@property (strong, nonatomic) UICollectionView *collectionView;
@property (strong, nonatomic) UIButton *cancel;

@property (strong, nonatomic) NSArray *showItems;

@property (strong, nonatomic) NSString *url, *title, *aDescription;
@property (strong, nonatomic) NSData *thumbImageData;
@end

@implementation SharedView

- (instancetype)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}
- (void)layoutSubviews {
    [super layoutSubviews];
    
    if (!CGSizeEqualToSize(self.backgroundView.frame.size, self.frame.size)) {
        self.backgroundView.frame = self.bounds;
    }
    
    NSInteger line = [self.collectionView numberOfItemsInSection:0] > EACH_LINE_NUM ? 2 : 1;
    CGFloat collectionHeight = (self.width/EACH_LINE_NUM + TITLE_HEIGHT) * line ;
    
    CGSize size = CGSizeMake(self.width, collectionHeight + Cancel_Height + BIG_MARGIN_DISTANCE);
    
    if (!CGSizeEqualToSize(size, self.bottomView.frame.size)) {
        self.bottomView.frame = CGRectMake(0, CGRectGetHeight(self.frame) - size.height, size.width, size.height);
        self.collectionView.frame = CGRectMake(0, 0, size.width, collectionHeight);
        self.cancel.frame = CGRectMake(BIG_MARGIN_DISTANCE, size.height - Cancel_Height - BIG_MARGIN_DISTANCE, size.width - 2*BIG_MARGIN_DISTANCE, Cancel_Height);
    }
}

+ (instancetype)sharedWithURL:(NSString *)url title:(NSString *)title description:(NSString *)description thumbImagePath:(NSString *)thumbImagePath type:(NSArray *)types {
    
    SharedView *shared = [[SharedView alloc] init];
    shared.url = url;
    shared.title = title;
    shared.aDescription = description;
    [self loadImageWithImagePath:thumbImagePath complete:^(UIImage *image) {
        shared.thumbImageData = UIImageJPEGRepresentation(image, 1);
    }];

    NSMutableArray *mutArr = [[NSMutableArray alloc] init];
    for (NSInteger i = 0; i < types.count; ++i) {
        
        NSString *type = types[i];
        if ([self typeCanShow:type]) {
            [mutArr addObject:[[CollectionInfo alloc] initWithSharedType:type]];
        }
    }
    
    shared.showItems = mutArr;
    
    return shared;
}

+ (void)loadImageWithImagePath:(NSString *)imagePath complete:(void(^)(UIImage *image))complete {
    
    if (![[NSFileManager defaultManager] fileExistsAtPath:[AiMiApplication pathForCachesWithFileName:[[imagePath componentsSeparatedByString:@"/"] lastObject]]]) {
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            
            NSData *imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:imagePath]];
            [imageData writeToFile:[AiMiApplication pathForCachesWithFileName:[[imagePath componentsSeparatedByString:@"/"] lastObject]] atomically:YES];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                !complete ? : complete([UIImage imageWithData:imageData]);
            });
            NSLog(@"%@", imageData ? @"有图片" : @"无图片");
        });
    } else {
        NSData *imageData = [NSData dataWithContentsOfFile:[AiMiApplication pathForCachesWithFileName:[[imagePath componentsSeparatedByString:@"/"] lastObject]]];
        !complete ? : complete([UIImage imageWithData:imageData]);
    }
}

+ (BOOL)canShared {
    
    return [WXApi isWXAppInstalled] || [QQApiInterface isQQInstalled];
}
+ (BOOL)canShareWechatBonus {
    
    return [WXApi isWXAppInstalled];
}

+ (BOOL)typeCanShow:(NSString *)type {
    
    return ( ([type isEqualToString:kSharedQQ] || [type isEqualToString:kSharedQzone] ) && [QQApiInterface isQQInstalled] )
        || ( ([type isEqualToString:kSharedWechat] || [type isEqualToString:kSharedWechatFriend]) && [WXApi isWXAppInstalled] );
}

- (void)showInWindow:(UIWindow *)window {
    
    if (!self.showItems.count) return;
    
    if (!self.superview) {
        self.frame = window.bounds;
        [window addSubview:self];
        
        [self layoutIfNeeded];
        
        self.bottomView.frame = CGRectMake(0, self.height, self.bottomView.width, self.bottomView.height);
        self.backgroundView.frame = CGRectMake(0, -self.backgroundView.height, self.backgroundView.width, self.backgroundView.height);
        self.backgroundView.alpha = DEFAULT_ALPHA;
        
        [UIView animateWithDuration:ANIMATION_DISTANCE animations:^{
            
            self.bottomView.frame = CGRectMake(0, self.height - self.bottomView.height, self.bottomView.width, self.bottomView.height);
            self.backgroundView.frame = self.bounds;
        }];
    }
}
- (void)hide {
    
    [self hideWithAnimation:NO];
}
- (void)hideWithAnimation:(BOOL)animation {
    
    if (animation) {
        
        [UIView animateWithDuration:ANIMATION_DISTANCE animations:^{
            
            self.backgroundView.alpha = 0;
            self.bottomView.frame = CGRectMake(0, self.height, self.bottomView.width, self.bottomView.height);
        } completion:^(BOOL finished) {
            
            if (self.superview) {
                [self removeFromSuperview];
            }
        }];
    } else {
        if (self.superview) {
            [self removeFromSuperview];
        }
    }
}

#pragma mark - dateSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return self.showItems.count;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    CollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:COLLECTION_IDENTIFIER forIndexPath:indexPath];
    
    [cell loadCellWithInfo:self.showItems[indexPath.row]];
    
    return cell;
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    CGSize size = CGSizeMake(collectionView.width/EACH_LINE_NUM, collectionView.width/EACH_LINE_NUM + TITLE_HEIGHT);
    
    return size;
}

#pragma mark -  delegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    CollectionInfo *info = self.showItems[indexPath.row];
    
    if ( [self shared:(CollectionInfo *)info])  {
        
        [self hide];
    }
}
- (BOOL)shared:(CollectionInfo *)info {
    
    if ([kSharedQQ isEqualToString:info.sharedType]) {
        return [self sharedToQQOrQzone:YES];
    } else if ([kSharedQzone isEqualToString:info.sharedType]) {
        return [self sharedToQQOrQzone:NO];
    } else if ([kSharedWechat isEqualToString:info.sharedType]) {
        return [self sharedToWxOrTimeLine:YES];
    } else if ([kSharedWechatFriend isEqualToString:info.sharedType]) {
        return [self sharedToWxOrTimeLine:NO];
    } else {
        return YES;
    }
}

- (BOOL)sharedToQQOrQzone:(BOOL)isQQ {
    
    QQApiNewsObject *news = [QQApiNewsObject objectWithURL:[NSURL URLWithString:self.url] title:self.title description:self.aDescription previewImageData:self.thumbImageData];
    SendMessageToQQReq* req = [SendMessageToQQReq reqWithContent:news];

    QQApiSendResultCode sent;
    if (isQQ) sent = [QQApiInterface sendReq:req];
    else      sent = [QQApiInterface SendReqToQZone:req];
    
    return EQQAPISENDSUCESS == sent;
}
- (BOOL)sharedToWxOrTimeLine:(BOOL)isWx {
    
    WXWebpageObject *webObject = [WXWebpageObject object];
    webObject.webpageUrl = self.url;
    
    WXMediaMessage *message = [WXMediaMessage message];
    message.title = self.title;
    message.description = self.aDescription;
    message.thumbData = self.thumbImageData;
    message.mediaObject = webObject;

    SendMessageToWXReq *req = [[SendMessageToWXReq alloc] init];
    req.message = message;
    req.scene = isWx ? WXSceneSession : WXSceneTimeline;

    return [WXApi sendReq:req];
}

#pragma mark -  setter & getter
- (UIView *)backgroundView {
    
    if (!_backgroundView) {
        UIView *view = [[UIView alloc] init];
        
        view.backgroundColor = [UIColor blackColor];
        view.alpha = DEFAULT_ALPHA;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(cancelShared)];
        [view addGestureRecognizer:tap];
        view.userInteractionEnabled = YES;
        
        [self addSubview:_backgroundView = view];
        [self sendSubviewToBack:view];
    }
    return _backgroundView;
}
- (UIView *)bottomView {
    
    if (!_bottomView) {
        UIView *view = [[UIView alloc] init];
        view.backgroundColor = Background_Color;
        [self addSubview:_bottomView = view];
    }
    return _bottomView;
}
- (UICollectionView *)collectionView {
    
    if (!_collectionView) {
        
        HorizontalCollectionViewLayout *layout = [[HorizontalCollectionViewLayout alloc] init];
        
        UICollectionView *view = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        [view registerClass:[CollectionCell class] forCellWithReuseIdentifier:COLLECTION_IDENTIFIER];
        view.showsHorizontalScrollIndicator = NO;
        view.pagingEnabled = YES;
        view.backgroundColor = Background_Color;
        view.dataSource = self;
        view.delegate = self;
        
        [self.bottomView addSubview:_collectionView = view];
    }
    return _collectionView;
}
- (UIButton *)cancel {
    
    if (!_cancel) {
        UIButton *button = [[UIButton alloc] init];
        
        button.titleLabel.font = [UIFont systemFontOfSize:NORMAL_FONT_SIZE];
        [button setTitle:@"取  消" forState:UIControlStateNormal];
        [button setTitleColor:Theme_Color forState:UIControlStateNormal];
        [button setBackgroundImage:[UIImage imageNamed:@"button_border_red"] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(cancelShared) forControlEvents:UIControlEventTouchUpInside];
        
        [self.bottomView addSubview:_cancel = button];
    }
    return _cancel;
}

- (void)cancelShared {
    
    [self hideWithAnimation:YES];
}
@end
