//
//  SQCache.m
//  SQNetWorking
//
//  Created by apple on 16/7/19.
//  Copyright © 2016年 zsq. All rights reserved.
//

#import "SQCache.h"
#import "SQCachedObject.h"
#import "NSDictionary+SQNetWorkingMethods.h"

#import "SQNetWorkingConfig.h"

@interface SQCache ()

@property (nonatomic, strong) NSCache *cache;

@end

@implementation SQCache

#pragma mark -  life cylce
+ (instancetype)sharedInstance {
    
    static dispatch_once_t onceToken;
    static SQCache * cache = nil;
    dispatch_once(&onceToken, ^{
        cache = [[SQCache alloc] init];
    });
    
    return cache;
}

#pragma mark -  public methods
- (NSData *) fetchCachedDataWithMethodName:(NSString *) methodName requestParams:(NSDictionary *)params {

    NSString *key = [self keyWithMethodName:methodName requestParams:params];
    return [self fetchCachedDataWithKey:key];
}





- (void)saveCacheWithData:(NSData *)cachedData
               methodName:(NSString *)methodName
            requestParams:(NSDictionary *)requestParams {
    
    NSString *key = [self keyWithMethodName:methodName requestParams:requestParams];
    [self saveCacheWithData:cachedData key:key];

}

- (void)deleteCacheWithMethodName:(NSString *)methodName
                    requestParams:(NSDictionary *)requestParams {
    
    NSString *key = [self keyWithMethodName:methodName requestParams:requestParams];
    [self deleteCacheWithKey:key];
}


- (NSData *)fetchCachedDataWithKey:(NSString *)key {
    
    SQCachedObject *obj = [self.cache objectForKey:key];
    if (obj.isOutdate || obj.content == nil) {
        
        if (obj.isOutdate) { // 过期的主动移除
            [self.cache removeObjectForKey:key];
        }
        return nil;
    } else {
        return obj.content;
    }
}

- (void)saveCacheWithData:(NSData *)cachedData key:(NSString *)key {
    
    SQCachedObject *obj = [self.cache objectForKey:key];
    if (obj == nil) {
        obj = [[SQCachedObject alloc] init];
    }
    
    [obj updateContent:cachedData];
    [self.cache setObject:obj forKey:key];
}

- (void)deleteCacheWithKey:(NSString *)key {
    
    [self.cache removeObjectForKey:key];
}

- (void)clean {
    [self.cache removeAllObjects];
}

#pragma mark -  private methods
// 根据请求方法和请求参数生成Key
- (NSString *)keyWithMethodName:(NSString *)methodName
                  requestParams:(NSDictionary *)requestParams {
    return [NSString stringWithFormat:@"%@%@", methodName, [requestParams sq_urlParamsStringSignature:NO]];
}


#pragma mark - getter 

- (NSCache *)cache {
    
    if (_cache == nil) {
        _cache = [[NSCache alloc] init];
        _cache.countLimit = kSQCacheCountMaxNumber;
    }
    
    return _cache;
}

@end
