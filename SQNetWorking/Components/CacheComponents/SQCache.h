//
//  SQCache.h
//  SQNetWorking
//
//  Created by apple on 16/7/19.
//  Copyright © 2016年 zsq. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SQCache : NSObject

+ (instancetype) sharedInstance;

- (NSData *) fetchCachedDataWithMethodName:(NSString *) methodName requestParams:(NSDictionary *)params;

- (NSString *)keyWithMethodName:(NSString *)methodName
                         requestParams:(NSDictionary *)requestParams;



- (void)saveCacheWithData:(NSData *)cachedData
               methodName:(NSString *)methodName
            requestParams:(NSDictionary *)requestParams;

- (void)deleteCacheWithMethodName:(NSString *)methodName
                           requestParams:(NSDictionary *)requestParams;


- (NSData *)fetchCachedDataWithKey:(NSString *)key;
- (void)saveCacheWithData:(NSData *)cachedData key:(NSString *)key;
- (void)deleteCacheWithKey:(NSString *)key;
- (void)clean;
@end
