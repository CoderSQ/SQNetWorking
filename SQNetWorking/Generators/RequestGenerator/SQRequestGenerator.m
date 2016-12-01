//
//  SQRequestGenerator.m
//  SQNetWorking
//
//  Created by apple on 16/7/19.
//  Copyright © 2016年 zsq. All rights reserved.
//

#import "SQRequestGenerator.h"
#import "AFNetworking.h"
#import "SQService.h"

#import "SQNetWorkingConfig.h"


@interface SQRequestGenerator ()

@property (nonatomic, strong) AFHTTPRequestSerializer *reqeustSerializer;


@end

@implementation SQRequestGenerator

+ (instancetype)sharedInstance {
    
    static SQRequestGenerator *generator = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        generator = [[SQRequestGenerator alloc] init];
    });
    
    return generator;
}


#pragma mark - getter

- (AFHTTPRequestSerializer *)reqeustSerializer {
    
    if (_reqeustSerializer == nil) {
        _reqeustSerializer = [AFHTTPRequestSerializer serializer];
        _reqeustSerializer.timeoutInterval = kRequestTimeoutInterval;
        _reqeustSerializer.cachePolicy = NSURLRequestUseProtocolCachePolicy;
    }
    
    return _reqeustSerializer;
}

#pragma mark - member methods

- (NSURLRequest *)generatorGETRequestWithParams:(NSDictionary *)params serviceIdentifier:(NSString *)servieIdentifier methodName:(NSString *)methodName {
    
    NSString *urlStr = [[SQService sharedInstance] urlStringWithMethodName:methodName];
    NSError *error = nil;
    NSMutableURLRequest *request = [self.reqeustSerializer requestWithMethod:@"GET" URLString:urlStr parameters:params error:&error];
    
    return request;
}


- (NSURLRequest *) generatorPOSTRequestWithParams:(NSDictionary *)params serviceIdentifier:(NSString *)servieIdentifier methodName:(NSString *)methodName {
    
    
    NSString *urlStr = [[SQService sharedInstance] urlStringWithMethodName:methodName];
    NSError *error = nil;
    NSMutableURLRequest *request = [self.reqeustSerializer requestWithMethod:@"POST" URLString:urlStr parameters:params error:&error];
    
    return request;
}

@end



