//
//  HorizontalCollectionViewLayout.m
//  YuanXin_Project
//
//  Created by Yuanin on 15/11/4.
//  Copyright © 2015年 yuanxin. All rights reserved.
//

#import "HorizontalCollectionViewLayout.h"

@implementation HorizontalCollectionViewLayout

- (instancetype)init {
    
    if (self = [super init]) {
        self.minimumInteritemSpacing = 0;
        self.minimumLineSpacing = 0;
        self.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    }
    return self;
}


//+ (Class)layoutAttributesClass; // override this method to provide a custom class to be used when instantiating instances of UICollectionViewLayoutAttributes
//+ (Class)invalidationContextClass NS_AVAILABLE_IOS(7_0); // override this method to provide a custom class to be used for invalidation contexts
//
//// The collection view calls -prepareLayout once at its first layout as the first message to the layout instance.
//// The collection view calls -prepareLayout again after layout is invalidated and before requerying the layout information.
//// Subclasses should always call super if they override.
//- (void)prepareLayout;
//
//// UICollectionView calls these four methods to determine the layout information.
//// Implement -layoutAttributesForElementsInRect: to return layout attributes for for supplementary or decoration views, or to perform layout in an as-needed-on-screen fashion.
//// Additionally, all layout subclasses should implement -layoutAttributesForItemAtIndexPath: to return layout attributes instances on demand for specific index paths.
//// If the layout supports any supplementary or decoration view types, it should also implement the respective atIndexPath: methods for those types.


//- (nullable UICollectionViewLayoutAttributes *)layoutAttributesForSupplementaryViewOfKind:(NSString *)elementKind atIndexPath:(NSIndexPath *)indexPath;
//- (nullable UICollectionViewLayoutAttributes *)layoutAttributesForDecorationViewOfKind:(NSString*)elementKind atIndexPath:(NSIndexPath *)indexPath;
//
//- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds; // return YES to cause the collection view to requery the layout for geometry information
//- (UICollectionViewLayoutInvalidationContext *)invalidationContextForBoundsChange:(CGRect)newBounds NS_AVAILABLE_IOS(7_0);
//
//- (BOOL)shouldInvalidateLayoutForPreferredLayoutAttributes:(UICollectionViewLayoutAttributes *)preferredAttributes withOriginalAttributes:(UICollectionViewLayoutAttributes *)originalAttributes NS_AVAILABLE_IOS(8_0);
//- (UICollectionViewLayoutInvalidationContext *)invalidationContextForPreferredLayoutAttributes:(UICollectionViewLayoutAttributes *)preferredAttributes withOriginalAttributes:(UICollectionViewLayoutAttributes *)originalAttributes NS_AVAILABLE_IOS(8_0);
//
//- (CGPoint)targetContentOffsetForProposedContentOffset:(CGPoint)proposedContentOffset withScrollingVelocity:(CGPoint)velocity; // return a point at which to rest after scrolling - for layouts that want snap-to-point scrolling behavior
//- (CGPoint)targetContentOffsetForProposedContentOffset:(CGPoint)proposedContentOffset NS_AVAILABLE_IOS(7_0); // a layout can return the content offset to be applied during transition or update animations
//
- (CGSize)collectionViewContentSize {
    
    NSInteger page = [self.collectionView numberOfItemsInSection:0]/(CGFloat)(2*EACH_LINE_NUM) + ( [self.collectionView numberOfItemsInSection:0]%(2*EACH_LINE_NUM) ? 1 : 0);
    CGFloat contentWidth = page*self.collectionView.width;
    
    return CGSizeMake(contentWidth, self.collectionView.height);
}

- (nullable NSArray<__kindof UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect {
    
    NSMutableArray *attributes = [[NSMutableArray alloc] init];
    
    NSInteger cellCount = [self.collectionView numberOfItemsInSection:0];
    for (NSInteger i = 0; i < cellCount; ++i) {
        NSIndexPath *indexPath =  [NSIndexPath indexPathForItem:i inSection:0];
        
        UICollectionViewLayoutAttributes *attr = [self layoutAttributesForItemAtIndexPath:indexPath];
        
        [attributes addObject:attr];
    }
    
    return attributes;
}
- (nullable UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    UICollectionViewLayoutAttributes *attributes = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
    
    NSInteger currentPage = [self pageWithRow:indexPath.row];//从0开始
    
    CGSize size = CGSizeZero;
    
    if ([self.collectionView.delegate respondsToSelector:@selector(collectionView:layout:sizeForItemAtIndexPath:)]) {
        id<UICollectionViewDelegateFlowLayout> delegate = (id<UICollectionViewDelegateFlowLayout>)self.collectionView.delegate;
        
        size = [delegate collectionView:self.collectionView layout:self sizeForItemAtIndexPath:indexPath];
    }
    
    if (indexPath.row % (2*EACH_LINE_NUM) < EACH_LINE_NUM) {
        attributes.frame = CGRectMake(currentPage*self.collectionView.width + (indexPath.row%EACH_LINE_NUM)*size.width, 0,
                                      size.width, size.height);
    } else {
        attributes.frame = CGRectMake(currentPage*self.collectionView.width + (indexPath.row%EACH_LINE_NUM)*size.width, size.height,
                                      size.width, size.height);
    }
    
//    NSLog(@"%@", NSStringFromCGRect(attributes.frame));
    
    return attributes;
}

///////所在的页码 从 0 开始
- (NSInteger)pageWithRow:(NSInteger)row {
    
    NSInteger page = row/(CGFloat)(2*EACH_LINE_NUM);

    return page;
}
- (NSInteger)totalPage {
    
    return [self pageWithRow:[self.collectionView numberOfItemsInSection:0] - 1] + 1;
}
@end
