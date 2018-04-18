//
//  TransactionRecordsCell.h
//  YuanXin_Project
//
//  Created by Yuanin on 15/10/13.
//  Copyright © 2015年 yuanxin. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "TransactionRecordsInfo.h"

#define JOURNAL_ACCOUN_IDENTIFIER @"TransactionRecordsCell"

@interface TransactionRecordsCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *typeName;
@property (weak, nonatomic) IBOutlet UILabel *tradeState;
@property (weak, nonatomic) IBOutlet UILabel *money;
@property (weak, nonatomic) IBOutlet UILabel *operationTime;

- (void)loadCellWithModel:(TransactionRecordsInfo *)info;
@end
