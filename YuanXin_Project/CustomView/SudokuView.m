//
//  SudokuView.m
//  GesturePassword
//
//  Created by Yuanin on 15/10/21.
//  Copyright © 2015年 Yuanin. All rights reserved.
//

#import "SudokuView.h"

#define POINT_NUM 9
#define LINE_COUNT (POINT_NUM/3)
#define POINT_DISTANCE_RATIO (1/10.0)

@implementation SudokuView

@synthesize hightColor = _hightColor, normalColor = _normalColor;

- (instancetype)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        [self setupSudokuView];
    }
    return self;
}
- (void)awakeFromNib {
    [super awakeFromNib];
    
    [self setupSudokuView];
}

- (void)setupSudokuView {
    
    self.backgroundColor = [UIColor clearColor];
}

- (void)prepareForInterfaceBuilder {
    
    [self setupSudokuView];
}

- (void)setHightLightPoints:(NSArray *)hightLightPoints {
    
    if (hightLightPoints.count > POINT_NUM)  return;
    
    _hightLightPoints = hightLightPoints;
    
    [self setNeedsDisplay];
}
- (void)setHightColor:(UIColor *)hightColor {
    
    _hightColor = hightColor;
    
    [self setNeedsDisplay];
}
- (UIColor *)hightColor {
    
    if (!_hightColor) {
        _hightColor = [UIColor whiteColor];
    }
    return _hightColor;
}
- (void)setNormalColor:(UIColor *)normalColor {
    
    _normalColor = normalColor;
    
    [self setNeedsDisplay];
}
- (UIColor *)normalColor {
    if (!_normalColor) {
        _normalColor = [UIColor whiteColor];
    }
    return _normalColor;
}

- (CGRect)calculateRectOfPoint:(NSInteger)index {
    
    CGRect square = [self squareOfAspectFit];
    NSInteger distance = POINT_DISTANCE_RATIO*CGRectGetWidth(square);
    NSInteger length = ( CGRectGetWidth(square) - distance*(LINE_COUNT + 1) )/LINE_COUNT;
    
    CGRect frame = CGRectMake( ( index%(NSInteger)LINE_COUNT)*(length + distance) + distance + square.origin.x,
                               ( index/(NSInteger)LINE_COUNT)*(length + distance) + distance + square.origin.y,
                                length, length );
    return frame;
}

- (CGRect)squareOfAspectFit {
    
    CGFloat minLength = ( CGRectGetWidth(self.frame) >= CGRectGetHeight(self.frame) ) ? CGRectGetHeight(self.frame) : CGRectGetWidth(self.frame);
    
    return CGRectMake((CGRectGetWidth(self.frame) - minLength)/2, (CGRectGetHeight(self.frame) - minLength)/2,
                      minLength, minLength);
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
    NSMutableArray *hight = [[NSMutableArray alloc] init];
    NSMutableArray *nomal = [[NSMutableArray alloc] init];
    
    for (NSInteger i = 0; i < POINT_NUM; ++i) {
        
        CGMutablePathRef path = CGPathCreateMutable();
        CGPathAddEllipseInRect(path, NULL, [self calculateRectOfPoint:i]);
        
        BOOL containsNumber = NO;
        for (NSNumber *number in self.hightLightPoints) {
            if ([number isEqualToNumber:@(i)]) {
                [hight addObject:(__bridge_transfer id)path];
                containsNumber = YES;
                break;
            }
        }
        
        if (!containsNumber)  [nomal addObject:(__bridge_transfer id)path];
    }
    
    //画高亮的线
    CGContextSaveGState(ctx);
    
    CGContextSetFillColorWithColor(ctx, self.hightColor.CGColor);
    for (id path in hight) {
        CGPathRef cPath = (__bridge_retained CGPathRef)path;
        CGContextAddPath(ctx, cPath);
        CGPathRelease(cPath);
    }
    CGContextDrawPath(ctx, kCGPathEOFill);
    CGContextRestoreGState(ctx);
    
    //画普通的
    CGContextSaveGState(ctx);
    
    CGContextSetStrokeColorWithColor(ctx, self.normalColor.CGColor);
    for (id path in nomal) {
        CGPathRef cPath = (__bridge_retained CGPathRef)path;
        CGContextAddPath(ctx, cPath);
        CGPathRelease(cPath);
    }
    CGContextDrawPath(ctx, kCGPathStroke);
    CGContextRestoreGState(ctx);
}

@end
