//
//  SQAppContenxt.m
//  SQNetWorking
//
//  Created by apple on 16/7/19.
//  Copyright © 2016年 zsq. All rights reserved.
//

#import "SQAppContext.h"
#import "AFNetworkReachabilityManager.h"

#import "SQBaseApiManager.h"

@interface SQAppContext ()

// 用户的token管理
@property (nonatomic, copy, readwrite) NSString *accessToken;
@property (nonatomic, copy, readwrite) NSString *refreshToken;
@property (nonatomic, assign, readwrite) NSTimeInterval lastRefreshTime;

@property (nonatomic, copy, readwrite) NSString *sessionId; // 每次启动App时都会新生成,用于日志标记


@end

@implementation SQAppContext

+ (instancetype)sharedInstance {
    
    static SQAppContext *context = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        context = [[SQAppContext alloc] init];
        [[AFNetworkReachabilityManager sharedManager] startMonitoring];
    });
    
    return context;
}

- (void)updateAccessToken:(NSString *)accessToken refreshToken:(NSString *)refreshToken {
    self.accessToken = accessToken;
    self.refreshToken = refreshToken;
    
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:kAccessToken];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:kRefreshToken];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:kUserInfo];

}

- (void)cleanUserInfo {
    self.accessToken = nil;
    self.refreshToken = nil;
    self.userInfo = nil;
    
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:kAccessToken];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:kRefreshToken];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:kUserInfo];
}

- (void)appStarted {

}


- (void)appEnded {

}

#pragma mark - getter
- (BOOL)isReachable {
    
    if ([AFNetworkReachabilityManager sharedManager].networkReachabilityStatus == AFNetworkReachabilityStatusUnknown) {
        return YES;
    } else {
        return [[AFNetworkReachabilityManager sharedManager] isReachable];
    }
}


@end
