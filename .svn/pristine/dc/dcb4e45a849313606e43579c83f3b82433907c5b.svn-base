//
//  ProductDetailSubView.m
//  YuanXin_Project
//
//  Created by Yuanin on 16/9/23.
//  Copyright © 2016年 yuanxin. All rights reserved.
//

#import "ProductDetailSubView.h"

@implementation ProductDetailSubView

- (void)beginRefresh
{ }

- (void)stopRefreshing
{ }

-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    !self.changeContentY ? : self.changeContentY(scrollView.contentOffset.y);
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    
    if (decelerate & (scrollView.contentOffset.y <= -64)) {
        
        PerformEmptyParameterBlock(self.shouldChangeShowView);
    }
}


@end
