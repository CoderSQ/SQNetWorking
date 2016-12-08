//
//  HYLHService.m
//  Huiyin
//
//  Created by apple on 16/7/26.
//  Copyright © 2016年 7ien. All rights reserved.
//

#import "HYLHService.h"
#import "SQAppContext.h"
#import "SQNetWorkingConfig.h"

@implementation HYLHService


#pragma mark - SQServiceProtocal

- (BOOL)isOnline {
    // TODO: 测试环境下返回NO， 测试结束后用下面的方法统一所有接口的线上线下状态
    return kSQServiceIsOnline;
    //    return [[SQAppContext sharedInstance] isOnline];
}

#pragma mark - online 配置
- (NSString *)onlineApiBaseUrl {
    return @"http://app.lehumall.com"; // 正式环境
}

- (NSString *)onlineApiVersion {
    return nil;
}

- (NSString *)onlinePublicKey {
    return nil;
}

- (NSString *)onlinePrivateKey {
    return nil;
}

#pragma mark - offline 配置
- (NSString *)offlineApiBaseUrl {
    return @"http://192.168.19.22:8082"; //测试环境
}

- (NSString *)offlineApiVersion {
    return nil;
}

- (NSString *)offlinePublicKey {
    return nil;
}

- (NSString *)offlinePrivateKey {
    return nil;
}

@end
