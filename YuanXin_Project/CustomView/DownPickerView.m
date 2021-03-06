//
//  DownPickerView.m
//  YuanXin_Project
//
//  Created by Yuanin on 15/10/12.
//  Copyright © 2015年 yuanxin. All rights reserved.
//

#import "DownPickerView.h"


#define PICKER_IDENTIFIER @"PickerCell"

@interface PickerCell : UICollectionViewCell

@property (assign, nonatomic) BOOL isSelected;

@property (strong, nonatomic, readwrite) UIImageView *line;
@property (strong, nonatomic) UIImage *redLine;
@property (strong, nonatomic) UIImage *grayLine;
@property (strong, nonatomic) UILabel *textLB;
@end


@implementation PickerCell

//- (instancetype)initWithStyle:(UICollectionViewCell)style reuseIdentifier:(NSString *)reuseIdentifier {
//    
//    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
//        [self initializePickerCell];
//    }
//    return self;
//}
- (void)awakeFromNib {
    [super awakeFromNib];
    
    [self initializePickerCell];
}

- (void)initializePickerCell {
    
    self.textLB.font = [UIFont systemFontOfSize:NORMAL_FONT_SIZE];
    self.textLB.textColor = Font_Normal_Gray;
//    self.selectionStyle = UITableViewCellSelectionStyleNone;
    [self.contentView addSubview:self.line];
    
    [self addSubview:self.textLB];
    UILabel *Lb = [[UILabel alloc]initWithFrame:CGRectMake(0, 10, 100, 30)];
    Lb.backgroundColor = [UIColor blackColor];
    [self.contentView addSubview:Lb];
    self.textLB.center = self.contentView.center;
    
    [self.contentView setNeedsUpdateConstraints];
}

- (void)updateConstraints {
    [super updateConstraints];
    
//    if (self.line.translatesAutoresizingMaskIntoConstraints) {
//        self.line.translatesAutoresizingMaskIntoConstraints = NO;
//        
//        NSArray *hConstraint = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(0)-[_line]-(0)-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_line)];
//        NSArray *vConstraint = [NSLayoutConstraint constraintsWithVisualFormat:@"V:[_line(==height)]-(0)-|" options:0 metrics:@{@"height":@(UISCREEN_SCALE)} views:NSDictionaryOfVariableBindings(_line)];
//        
//        [self.contentView addConstraints:hConstraint];
//        [self.contentView addConstraints:vConstraint];
//    }
}

- (void)setIsSelected:(BOOL)isSelected {
    _isSelected = isSelected;
    
    self.line.image = [self thePresentImage:isSelected];
    self.textLB.textColor = [self thePresentTextColor:isSelected];
}

- (UIImage *)thePresentImage:(BOOL)selected {
    
    return selected ? self.redLine : self.grayLine;
}
- (UIColor *)thePresentTextColor:(BOOL)selected {
    
    return selected ? Theme_Color : [UIColor lightGrayColor];
}

- (UIImageView *)line {
    if (!_line) {
        _line = [[UIImageView alloc] init];
    }
    return _line;
}
- (UIImage *)redLine {
    if (!_redLine) {
        _redLine = [CommonTools singleImageFromColor:Theme_Color];
    }
    return _redLine;
}
- (UIImage *)grayLine {
    if (!_grayLine) {
        _grayLine = [CommonTools singleImageFromColor:Single_Line_Gray];
    }
    return _grayLine;
}
- (UILabel *)textLB{
    if (!_textLB) {
        _textLB = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 100, 20)];
        _textLB.font = [UIFont systemFontOfSize:14.0];
        _textLB.textAlignment = 1;
        _textLB.textColor = [UIColor lightGrayColor];
        
    }
    return _textLB;
}
@end








@interface DownPickerView() <UICollectionViewDelegateFlowLayout, UICollectionViewDataSource,UICollectionViewDelegate>

@property (strong, nonatomic, readwrite) UICollectionView *pickerTableView;
@property (strong, nonatomic, readwrite) UIView      *backgroundView;
@property (strong, nonatomic, readwrite) UIView      *anchorView;
@property (copy, nonatomic, readwrite) void(^clickBlock)(DownPickerView *pickerView, NSInteger row);
@property (assign, readwrite) BOOL showing;
@end

@implementation DownPickerView

#define ANIMATION_DURATION 0.2f
#define NORMAL_CELL_HEIGHT 44
#define CONTENT_HEIFHT_ATRIO (3/4.0)


- (instancetype)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        
        [self initializeDownPickerView];
    }
    return self;
}

- (void)initializeDownPickerView {
    
    self.backgroundColor = [UIColor clearColor];
    self.showing = NO;
    self.selectedRow = 0;
    
    [self addSubview:self.backgroundView];
    [self addSubview:self.pickerTableView];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.backgroundView.frame = self.bounds;
}

#pragma mark - dataSource
//- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//    
//    if ([self.dataSource respondsToSelector:@selector(numberOfRowsInDownPickerView:)]) {
//        
//        return [self.dataSource numberOfRowsInDownPickerView:self];
//    } else {
//        return 0;
//    }
//}
//- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
//    
//    PickerCell *cell = [tableView dequeueReusableCellWithIdentifier:PICKER_IDENTIFIER];
//    
//    cell.isSelected = indexPath.row == self.selectedRow;
//    
//    // cell content
//    if ([self.dataSource respondsToSelector:@selector(downPickerView:titleAtRow:)]) {
//        cell.textLabel.text = [self.dataSource downPickerView:self titleAtRow:indexPath.row];
//    } else {
//        cell.textLabel.text = [NSString stringWithFormat:@"row%@", @(indexPath.row)];
//    }
//    
//    return cell;
//}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
        PickerCell *cell = [collectionView  dequeueReusableCellWithReuseIdentifier:PICKER_IDENTIFIER forIndexPath:indexPath];
        cell.isSelected = indexPath.row == self.selectedRow;
//        cell.backgroundColor = [UIColor redColor];
        [cell.contentView addSubview:cell.textLB];
        cell.textLB.center = cell.contentView.center;
        // cell content
        if ([self.dataSource respondsToSelector:@selector(downPickerView:titleAtRow:)]) {
            cell.textLB.text = [self.dataSource downPickerView:self titleAtRow:indexPath.row];
//            cell.textLB.backgroundColor = [UIColor cyanColor];
        } else {
            cell.textLB.text = [NSString stringWithFormat:@"row%@", @(indexPath.row)];
        }
        
        return cell;
//    return nil;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
        if ([self.dataSource respondsToSelector:@selector(numberOfRowsInDownPickerView:)]) {
    
            return [self.dataSource numberOfRowsInDownPickerView:self];
        } else {
            return 0;
        }
//    return 2;
}
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    if ([self.dataSource respondsToSelector:@selector(collectionViewsizeForItemAtIndexPath)]) {
        
        return [self.dataSource collectionViewsizeForItemAtIndexPath];
    } else {
        return CGSizeMake(0, 0);
    }
    
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
        if (indexPath.row == self.selectedRow) {
            return;
        }
    
        self.selectedRow = indexPath.row;
        if (self.clickBlock) {
            self.clickBlock(self, indexPath.row);
        }
    
        [self hideAnimation];
}


#pragma mark - delegate
//- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
//    
//    if (indexPath.row == self.selectedRow) {
//        return;
//    }
//    
//    self.selectedRow = indexPath.row;
//    if (self.clickBlock) {
//        self.clickBlock(self, indexPath.row);
//    }
//    
//    [self hideAnimation];
//}

#pragma mark - public method

- (void)showInAnchorView:(UIView *)anchorView clickRow:( void(^)(DownPickerView *, NSInteger ) ) clickBlock {//animation
    
    if (anchorView.superview) {
        self.anchorView = anchorView;

        CGRect frame = CGRectMake(0, CGRectGetMaxY(anchorView.frame), CGRectGetWidth(anchorView.superview.frame), CGRectGetHeight(anchorView.superview.frame) - CGRectGetMaxY(anchorView.frame));
        [self showInView:anchorView.superview rect:frame clickRow:clickBlock];

    }
}
- (void)showInView:(UIView *)view rect:(CGRect)frame clickRow:( void(^)(DownPickerView *, NSInteger ) ) clickBlock {
    
    self.frame = frame;
    
    self.showing = YES;
    self.clickBlock = clickBlock;
    if (!self.superview) {
        [view addSubview:self];
    }
    self.pickerTableView.frame = CGRectMake(0, 0, CGRectGetWidth(self.frame), 0);
    
    [self tableViewAnimationWithShowState:YES];
}
- (void)hide {
    
    [self hideWithAnimation:NO];
}
- (void)hideWithAnimation:(BOOL)animation {
    
    if (animation) {
        
        [self tableViewAnimationWithShowState:NO];
    } else {
        
        self.showing = NO;
        self.hidden = YES;
        self.backgroundView.alpha = 0;
    }
    
    if (self.complete) {
        self.complete();
    }
}

#pragma mark - private method
//- (CGFloat)tableHeight {
//    
//    NSInteger atrioHeight = CGRectGetHeight(self.frame)*CONTENT_HEIFHT_ATRIO;
//    CGFloat tableHeight   = atrioHeight - (atrioHeight)%NORMAL_CELL_HEIGHT;
//    
////    看看总的cell高度是否大于tableViewHeight
////    return tableHeight <= NORMAL_CELL_HEIGHT*[self.pickerTableView numberOfRowsInSection:0] ? tableHeight : NORMAL_CELL_HEIGHT*[self.pickerTableView numberOfRowsInSection:0];
//    return 88;
//}

- (void)tableViewAnimationWithShowState:(BOOL)show {
    
    self.showing = show;
    
    CGRect endFrame = show ? CGRectMake( 0, 0, CGRectGetWidth(self.frame),_tableHeight ) : CGRectMake(0, 0, self.frame.size.width, 0);
    CGFloat alpha = show ? DEFAULT_ALPHA : 0;
    
    if (show) self.hidden = NO;
    
    [UIView animateWithDuration:ANIMATION_DURATION animations:^{
        
        self.pickerTableView.frame = endFrame;
        self.backgroundView.alpha  = alpha;
    } completion:^(BOOL finished) {
        
        self.pickerTableView.frame = endFrame;
        self.backgroundView.alpha  = alpha;
        
        if (!show) self.hidden = YES;
    }];
    if (show) {
        [self.pickerTableView reloadData];
    }
    
}
- (void)hideAnimation {
    
    [self hideWithAnimation:YES];
}

#pragma mark - getter & setter
- (UICollectionView *)pickerTableView {
    
    if (!_pickerTableView) {
        UICollectionViewFlowLayout * layout = [[UICollectionViewFlowLayout alloc] init];
        layout.minimumInteritemSpacing = 0;
        layout.minimumLineSpacing = 0;
//        layout.sectionInset = UIEdgeInsetsMake(0, 9, 0, 9);
        layout.scrollDirection = UICollectionViewScrollDirectionVertical;
     
        UICollectionView *tableView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, 100, 80) collectionViewLayout:layout];
        tableView.backgroundColor = [UIColor clearColor];
        tableView.bounces         = NO;
        
        
     
         [tableView registerClass:[PickerCell class] forCellWithReuseIdentifier:PICKER_IDENTIFIER];
//
//        tableView.tableFooterView = [UIView new];
//       
//        tableView.rowHeight       = NORMAL_CELL_HEIGHT;
//        tableView.separatorInset  = UIEdgeInsetsZero;
//        tableView.separatorStyle  = UITableViewCellSeparatorStyleNone;
        
//        if ([tableView respondsToSelector:@selector(layoutMargins)]) {
//            [tableView setLayoutMargins:UIEdgeInsetsZero];
//        }
//
        tableView.backgroundColor = [UIColor whiteColor];
        tableView.dataSource = self;
        tableView.delegate   = self;
       
        
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideAnimation)];
        [tableView.backgroundView addGestureRecognizer:tapGesture];
        
        _pickerTableView = tableView;
    }
    return _pickerTableView;
}
- (UIView *)backgroundView {
    
    if (!_backgroundView) {
        UIView *view = [[UIView alloc] init];
        
        view.backgroundColor = [UIColor blackColor];
        view.alpha           = 0;
        
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideAnimation)];
        [view addGestureRecognizer:tapGesture];
        
        _backgroundView = view;
    }
    return _backgroundView;
}

- (void)setSelectedRow:(NSInteger)selectedRow {
    
//    PickerCell *oldSelected = [self.pickerTableView cellForItemAtIndexPath:[NSIndexPath indexPathForItem:_selectedRow inSection:0]];
//    PickerCell *newSelected = [self.pickerTableView cellForItemAtIndexPath:[NSIndexPath indexPathForItem:selectedRow inSection:0]];
//    
//    oldSelected.isSelected = NO;
//    newSelected.isSelected = YES;
//
    _selectedRow = selectedRow;
}


@end
