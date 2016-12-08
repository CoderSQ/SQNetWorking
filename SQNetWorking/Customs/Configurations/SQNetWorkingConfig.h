//
//  SQNetWorkingConfig.h
//  SQNetWorking
//
//  Created by apple on 16/7/21.
//  Copyright © 2016年 zsq. All rights reserved.
//  网络层相关配置

#ifndef SQNetWorkingConfig_h
#define SQNetWorkingConfig_h

extern NSString * const kSQServiceTypeHYLH;


/** 5分钟的cache过期时间 */
static NSTimeInterval kSQCacheOutdateTimeSeconds = 300;

/** 是否缓存 */
static BOOL kSQShouldCache                       = YES;

/** 线上线下标识*/
static BOOL kSQServiceIsOnline                   = YES;

/** 超时时间 */
static NSInteger kRequestTimeoutInterval         = 20;

/** 缓存数据最大条数 */
static NSInteger kSQCacheCountMaxNumber          = 1000;

#endif /* SQNetWorkingConfig_h */
