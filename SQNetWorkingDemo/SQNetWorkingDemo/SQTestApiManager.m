//
//  SQTestApiManager.m
//  SQNetWorking
//
//  Created by apple on 16/7/21.
//  Copyright © 2016年 zsq. All rights reserved.
//

#import "SQTestApiManager.h"

@interface SQTestApiManager () <SQApiManagerValidator>

@end

@implementation SQTestApiManager

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.validator = self;
    }
    return self;
}

#pragma mark - SQApiManager
- (NSString *)methodName {
//    return @"geocode/regeo";
    
    return @"forge/register.do";
}

- (NSString *)serviceType {
    return nil;
}

- (SQApiManagerRequestType)requestType {
    return SQApiManagerRequestTypeGet;
}

- (BOOL)shouldCache {
    return YES;
}


#pragma mark - SQApiManagerValidator
- (BOOL)manager:(SQBaseApiManager *)manager isCorrectWithParamsData:(NSDictionary *)data {
    NSLog(@"验证请求参数是否合法");
    return YES;
}

- (BOOL)manager:(SQBaseApiManager *)manager isCorrectWithCallBackData:(NSDictionary *)data {
    NSLog(@"验证回调结果数据是否合法");
    return YES;

}

@end
