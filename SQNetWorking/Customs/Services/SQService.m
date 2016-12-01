//
//  SQService.m
//  SQNetWorking
//
//  Created by apple on 16/7/19.
//  Copyright © 2016年 zsq. All rights reserved.
//

#import "SQService.h"

@implementation SQService

+ (instancetype)sharedInstance {
    
    static SQService *service = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        service = [[SQService alloc] init];
    });
    
    return service;
}

- (NSString *)publicKey {
    return @"";
}

- (NSString *)privateKey {
    return @"";
}

- (NSString *)apiBaseUrl {
//    return @"http://restapi.amap.com";
    return @"http://192.168.19.22:8082";
}

- (NSString *)apiVersion {
    return @"";
}


/** 根据方法名返回访问该方法的Url字符串 */
- (NSString *) urlStringWithMethodName:(NSString *) methodName {
    
    NSString *urlStr = nil;
    if (self.apiVersion.length) {
        urlStr = [NSString stringWithFormat:@"%@/%@/%@", self.apiBaseUrl, self.apiVersion, methodName];
    } else {
        urlStr = [NSString stringWithFormat:@"%@/%@", self.apiBaseUrl, methodName];
    }
    
    return urlStr;
}

@end
