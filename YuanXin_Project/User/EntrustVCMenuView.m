//
//  EntrustVCMenuView.m
//  YuanXin_Project
//
//  Created by Yuanin on 17/2/9.
//  Copyright © 2017年 yuanxin. All rights reserved.
//

#import "EntrustVCMenuView.h"
@interface EntrustVCMenuView ()<UITableViewDelegate,UITableViewDataSource>
{
    
}
@end
@implementation EntrustVCMenuView
+ (void)show{

}
- (void)dissMiss{
    [self removeFromSuperview];
}
- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        
        [self addSubviews];
    }
    return self;
}
- (void)addSubviews{

    
    UIButton *clickbtn = [[UIButton alloc]initWithFrame:CGRectMake(self.bounds.size.width - 120, 64, 110, 89)];
    clickbtn.backgroundColor = [UIColor clearColor];
    [clickbtn setImage: [UIImage imageNamed:@"116-2"] forState:UIControlStateNormal];
//    [clickbtn setBackgroundColor:[UIColor colorWithRed:255/255.0 green:78/255.0 blue:80/255.0 alpha:1]];

    clickbtn.tag = 1;
    [clickbtn addTarget:self action:@selector(btnCliced:) forControlEvents:UIControlEventTouchUpInside];

    [clickbtn addSubview:self.tableView];
    [self addSubview:clickbtn];
    
    
}
- (UITableView *)tableView{
    if (!_tableView) {
        UITableView *tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 9, 110, 79)];
        _tableView = tableView;
        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.rowHeight = 40;
        _tableView.delegate = self;
        _tableView.dataSource = self;
    }
    return _tableView;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 2;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
   
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    UIImageView *imageview = [[UIImageView alloc]initWithFrame:CGRectMake(10, 10, 20, 20)];
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(40, 10, 70, 20)];
    

    
    [label setFont:[UIFont systemFontOfSize:15.0]];
    [label setTextColor: [UIColor whiteColor]];
    [cell addSubview:imageview];
    [cell addSubview:label];
    cell.backgroundColor = [UIColor clearColor];
    if (indexPath.row == 0) {
        label.text = @"规则说明";
          imageview.image = [UIImage imageNamed:@"113"];
        
    }else{
        label.text = @"出借记录";
         imageview.image = [UIImage imageNamed:@"112"];
        
    }
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.changeStateBlock) {
    self.changeStateBlock(indexPath.row );
    }
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self removeFromSuperview];
}
@end
