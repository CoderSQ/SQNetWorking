//
//  SQLogger.h
//  SQNetWorking
//
//  Created by apple on 16/7/22.
//  Copyright © 2016年 zsq. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "SQService.h"
#import "SQURLResponse.h"


@interface SQLogger : NSObject


+ (void)logDebugInfoWithRequest:(NSURLRequest *)request apiName:(NSString *)apiName service:(SQService *)service requestParams:(id)requestParams httpMethod:(NSString *)httpMethod;


+ (void)logDebugInfoWithResponse:(NSHTTPURLResponse *)response resposeString:(NSString *)responseString request:(NSURLRequest *)request error:(NSError *)error;

+ (void)logDebugInfoWithCachedResponse:(SQURLResponse *)response methodName:(NSString *)methodName serviceIdentifier:(SQService *)service;

@end
