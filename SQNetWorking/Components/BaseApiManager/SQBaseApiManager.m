//
//  SQBaseApiManager.m
//  SQNetWorking
//
//  Created by apple on 16/7/18.
//  Copyright © 2016年 zsq. All rights reserved.
//

#import "SQBaseApiManager.h"
#import "SQApiProxy.h"
#import "SQCache.h"
#import "SQURLResponse.h"

#import "SQAppContext.h"
#import "SQNetWorkingConfig.h"

#import "SQLogger.h"

#define SQCallAPI(REQUEST_METHOD, REQUEST_ID)                                                   \
{                                                                                               \
    __weak typeof(self) weakSelf = self;                                                        \
    REQUEST_ID = [[SQApiProxy sharedInstance] call##REQUEST_METHOD##WithParams:apiParams serviceIdentifier:self.child.                      serviceType methodName:self.child.methodName success:^(SQURLResponse *response) { \
            __strong typeof(weakSelf) strongSelf = weakSelf;                                        \
            [strongSelf successedOnCallingAPI:response];                                            \
        } fail:^(SQURLResponse *response) {                                                        \
            __strong typeof(weakSelf) strongSelf = weakSelf;                                        \
            [strongSelf failedOnCallingAPI:response withErrorType:SQAPIManagerErrorTypeDefault];    \
        }];                                                                                         \
    [self.requestIdList addObject:@(REQUEST_ID)];                                               \
}

@interface SQBaseApiManager ()

@property (nonatomic, strong, readwrite) id       fetchedRawData;
@property (nonatomic, assign, readwrite) BOOL     isLoading;
@property (nonatomic, copy,   readwrite) NSString *errorMessage;


@property (nonatomic, readwrite) SQAPIManagerErrorType errorType;
@property (nonatomic, assign   ) BOOL                  isNativeDataEmpty;
@property (nonatomic, strong   ) NSMutableArray        *requestIdList;
@property (nonatomic, strong   ) SQCache               *cache;
@property (nonatomic, readwrite) SQURLResponse         *response;

@end

@implementation SQBaseApiManager



#pragma mark - lifecycle

- (instancetype)init
{
    self = [super init];
    if (self) {
        
        _errorType = SQAPIManagerErrorTypeDefault;
        
        if ([self conformsToProtocol:@protocol(SQApiManager)]) {
            self.child = (id<SQApiManager>)self;
        }
    }
    return self;
}

- (void)dealloc {
    [self cancelAllRequests];
    self.requestIdList = nil;
}


- (id) fetchDataWithReformer:(id<SQApiManagerDataReformer>)reformer {
    return nil;
}

/**
 *  使用loadData这个方法,这个方法会通过param source来获得参数，这使得参数的生成逻辑位于controller中的固定位置
 *   @return requestID  请求标识数
 */
- (NSInteger) loadData {
    
    NSDictionary *params = [self.parmSource paramsForManager:self];
    return  [self loadDataWithParams:params];
}

- (NSInteger) loadDataWithParams:(NSDictionary *)dict {
    NSInteger requestID = 0;
    
    NSDictionary *apiParams = [self reformParams:dict];
    if ([self shouldCallApiWithParams:apiParams]) {
        
        //检查缓存有缓存内部直接返回缓存数据
        if ([self shouldCache] && [self hasCacheWithParams:apiParams]) {
            return 0;
        }
        
        if ([self isReachable]) {
            self.isLoading = YES;
            
            switch ([self.child requestType]) {
                    
                case SQApiManagerRequestTypeGet:
                    SQCallAPI(GET, requestID)
                    break;
                    
                case SQApiManagerRequestTypePost:
                    SQCallAPI(POST, requestID)
                    
                default:
                    break;
            }
            
            NSMutableDictionary *params = [apiParams mutableCopy];
            params[kSQAPIBaseManagerRequestID] = @(requestID);
            [self afterCallApiWithParams:params];
            
            return requestID;
        } else {

            [self failedOnCallingAPI:nil withErrorType:SQAPIManagerErrorTypeNoNetWork];
        }
    } else {
        [self failedOnCallingAPI:nil withErrorType:SQAPIManagerErrorTypeParamsError];
    }
    
    return requestID;
}


- (void) cancelAllRequests {
    [[SQApiProxy sharedInstance] cancelRequestWithRequestIDList:self.requestIdList];
}

- (void) cancelRequestWithRequestID:(NSInteger) requestID {
    [[SQApiProxy sharedInstance] cancelRequestWithRequestID:requestID];
}


// 拦截器方法
- (BOOL) shouldCallApiWithParams:(NSDictionary *)params {
    
    if (self.intercetor  && [self.intercetor respondsToSelector:@selector(manager:shouldCallApiWithParams:)]) {
        return [self.intercetor manager:self shouldCallApiWithParams:params];
    }
    return YES;
}

- (void) afterCallApiWithParams:(NSDictionary *)params {
    
    if (self.intercetor  && [self.intercetor respondsToSelector:@selector(manager:afterCallApiWithParams:)]) {
        [self.intercetor manager: self afterCallApiWithParams:params];
    }
}

- (BOOL) beforePerformSuccessWithResponse:(SQURLResponse *)response {
    
    if (self.intercetor && [self.intercetor respondsToSelector:@selector(manager:beforePerformSuccessWithResponse:)]) {
       return  [self.intercetor manager: self beforePerformSuccessWithResponse:response];
    }
    
    return YES;
}

- (void) afterPerformSuccessWithResponse:(SQURLResponse *)response {
    
    if (self.intercetor  && [self.intercetor respondsToSelector:@selector(manager:afterPerformSuccessWithResponse:)]) {
        [self.intercetor manager: self afterPerformSuccessWithResponse:response];
    }
}

- (BOOL) beforePerformFailWithResponse:(SQURLResponse *)response {
    
    if (self.intercetor  && [self.intercetor respondsToSelector:@selector(manager:beforePerformFailWithResponse:)]) {
       return [self.intercetor manager: self beforePerformFailWithResponse:response];
    }
    
    return YES;
}

- (void) afterPerformFailWithResponse:(SQURLResponse *)response {
    
    if (self.intercetor  && [self.intercetor respondsToSelector:@selector(manager:afterPerformFailWithResponse:)]) {
        [self.intercetor manager: self afterPerformFailWithResponse:response];
    }
}

#pragma mark - 接口统一回调位置
// SQApiManagerCallBackDelegate 协议方法 SQBaseApiManager不遵循该协议，只实现
- (void)successedOnCallingAPI:(SQURLResponse *)response {
    self.isLoading = NO;
    self.response = response;
    
    if (response.content) {
        self.fetchedRawData = response.content;
    } else {
        self.fetchedRawData = [response.responseData copy];
    }
    
    [self removeRequestIDWithRequestID:response.requestID];
    
    // 验证返回数据是否合法
    if ([self.validator manager:self isCorrectWithParamsData:response.content]) {
        
        // 缓存
        if ([self shouldCache] && !response.isCache) {
            [self.cache saveCacheWithData:response.responseData methodName:[self.child methodName] requestParams:response.requestParams];
        }
        
        // 回调
        if ([self beforePerformSuccessWithResponse:response]) {
            [self.delegate managerCallAPIDidSucced:self];
            
            [self afterPerformSuccessWithResponse:response];
        }
    } else { // 参数非法
        [self failedOnCallingAPI:response withErrorType:SQAPIManagerErrorTypeParamsError];
    }
}

- (void)failedOnCallingAPI:(SQURLResponse *)response withErrorType:(SQAPIManagerErrorType)errorType {
    
    self.isLoading = NO;
    self.response = response;
    if ([response.content[@"id"] isEqualToString:@"expired_access_token"]) {
        // token 失效
        [[NSNotificationCenter defaultCenter] postNotificationName:kUserTokenInvalidNotification
                                                            object:nil
                                                          userInfo:@{
                                                                     kUserTokenNotificationKeyRequestToContinue:[response.request mutableCopy],
                                                                     kUserTokenNotificationKeyManagerToContinue:self
                                                                     }];
    } else if ([response.content[@"id"] isEqualToString:@"illegal_access_token"]) {
        // token 无效，重新登录
        [[NSNotificationCenter defaultCenter] postNotificationName:kUserTokenIllegalNotification
                                                            object:nil
                                                          userInfo:@{
                                                                     kUserTokenNotificationKeyRequestToContinue:[response.request mutableCopy],
                                                                     kUserTokenNotificationKeyManagerToContinue:self
                                                                     }];
    } else if ([response.content[@"id"] isEqualToString:@"no_permission_for_this_api"]) {
        [[NSNotificationCenter defaultCenter] postNotificationName:kUserTokenIllegalNotification
                                                            object:nil
                                                          userInfo:@{
                                                                     kUserTokenNotificationKeyRequestToContinue:[response.request mutableCopy],
                                                                     kUserTokenNotificationKeyManagerToContinue:self
                                                                     }];
    } else {
        // 其他错误
        self.errorType = errorType;
        [self removeRequestIDWithRequestID:response.requestID];
        if ([self beforePerformFailWithResponse:response]) {
            [self.delegate managerCallAPIDidFail:self];
        }
        [self afterPerformFailWithResponse:response];
    }
}

// SQApiManager 协议方法 SQBaseApiManager不遵循该协议，只实现
// 子类实现该方法，提供该api的通用参数
- (NSDictionary *) reformParams:(NSDictionary *)params {
    IMP childIMP = [self.child methodForSelector:@selector(reformParams:)];
    IMP selfIMP = [self methodForSelector:@selector(reformParams:)];
    
    if (childIMP == selfIMP) {
        return params;
    } else {
        // 如果child是继承得来的，那么这里就不会跑到，会直接跑子类中的IMP。
        // 如果child是另一个对象，就会跑到这里
        NSDictionary *result = nil;
        result = [self.child reformParams:params];
        if (result) {
            return result;
        } else {
            return params;
        }
    }
}


- (void)cleanData {
    [self.cache clean];
    self.fetchedRawData = nil;
    self.errorMessage = nil;
    self.errorType = SQAPIManagerErrorTypeDefault;
}


- (BOOL)shouldCache {
    return kSQShouldCache;
}


#pragma mark -  private methods
- (void) removeRequestIDWithRequestID:(NSInteger) requestId {
    
    NSNumber *requestID = @(requestId);
    NSNumber *requestIDRemoved = nil;
    
    for (NSNumber *storedRequestID in self.requestIdList) {
        if ([storedRequestID isEqualToNumber:requestID]) {
            requestIDRemoved = storedRequestID;
            break;
        }
    }
    
    if (requestIDRemoved) {
        [self.requestIdList removeObject:requestIDRemoved];
    }
}

- (BOOL) hasCacheWithParams:(NSDictionary *)params {
    
    NSString *methodName = [self.child methodName];
    NSData *data = [self.cache fetchCachedDataWithMethodName:methodName requestParams:params];
    
    if (data) {
        
        SQURLResponse *response = [[SQURLResponse alloc] initWithData:data];
        response.requestParams = params;
        
        [SQLogger logDebugInfoWithCachedResponse:response methodName:methodName serviceIdentifier:[SQService sharedInstance]];
        
        [self successedOnCallingAPI:response];
        return YES;
    } else {
        return NO;
    }
}


#pragma mark - getter
- (NSMutableArray *)requestIdList {
    if (_requestIdList == nil) {
        _requestIdList = [NSMutableArray array];
    }
    
    return _requestIdList;
}

- (SQCache *)cache {
    if (_cache == nil) {
        _cache = [SQCache sharedInstance];
    }
    
    return _cache;;
}

- (BOOL)isReachable {
    BOOL isReachability = [SQAppContext sharedInstance].isReachable;
    if (!isReachability ) {
        self.errorType = SQAPIManagerErrorTypeNoNetWork;
    }
    
    return isReachability;
}


@end
