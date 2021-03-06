//
//  RewardViewModel.h
//  YuanXin_Project
//
//  Created by Yuanin on 16/4/26.
//  Copyright © 2016年 yuanxin. All rights reserved.
//

#import "BaseViewModel.h"

typedef NS_ENUM(NSInteger, RewardType) {
    kRewardBonus = 0,
    kRewardExperience
};

@interface RewardViewModel : BaseViewModel

@property (assign, nonatomic) RewardType type;
@property (assign, nonatomic) NSInteger needValid;
@property (strong, nonatomic, readonly) NSArray *rewardInfo;
@property (assign, nonatomic, readonly) NSUInteger currentPage;

- (void)beginFetchRewardWithSuccess:(void(^)(id result)) successBlock failure:(void(^)(NSString *errorDescription)) failureBlock;
- (void)fetchNextPageRewardWithSuccess:(void(^)(id result)) successBlock failure:(void(^)(NSString *errorDescription)) failureBlock;
@end
