//
//  SQService.m
//  SQNetWorking
//
//  Created by apple on 16/7/19.
//  Copyright © 2016年 zsq. All rights reserved.
//

#import "SQService.h"

@implementation SQService


- (instancetype)init
{
    self = [super init];
    if (self) {
        if ([self conformsToProtocol:@protocol(SQServiceProtocal)]) {
            self.child = (id<SQServiceProtocal>)self;
        }
    }
    return self;
}

#pragma mark - getters and setters
- (NSString *)privateKey
{
    return self.child.isOnline ? self.child.onlinePrivateKey : self.child.offlinePrivateKey;
}

- (NSString *)publicKey
{
    return self.child.isOnline ? self.child.onlinePublicKey : self.child.offlinePublicKey;
}

- (NSString *)apiBaseUrl
{
    return self.child.isOnline ? self.child.onlineApiBaseUrl : self.child.offlineApiBaseUrl;
}

- (NSString *)apiVersion
{
    return self.child.isOnline ? self.child.onlineApiVersion : self.child.offlineApiVersion;
}

+ (instancetype)sharedInstance {
    
    static SQService *service = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        service = [[SQService alloc] init];
    });
    
    return service;
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


