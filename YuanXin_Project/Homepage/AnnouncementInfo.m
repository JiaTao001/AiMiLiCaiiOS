//
//  AnnouncementInfo.m
//  YuanXin_Project
//
//  Created by Yuanin on 16/4/19.
//  Copyright © 2016年 yuanxin. All rights reserved.
//

#import "AnnouncementInfo.h"

@implementation AnnouncementInfo

- (instancetype)initWithDictionary:(NSDictionary *)aDic {
    self = [super init];
    
    if (self) {
        
        _announcementId = aDic[@"href"];
        _title = aDic[@"src"];
    }
    return self;
}
+ (instancetype)announcementInfoWithDictionary:(NSDictionary *)aDic {
    
    return [[[self class] alloc] initWithDictionary:aDic];
}
@end
