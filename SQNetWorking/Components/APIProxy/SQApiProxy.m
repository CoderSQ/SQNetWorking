//
//  SQApiProxy.m
//  SQNetWorking
//
//  Created by apple on 16/7/18.
//  Copyright © 2016年 zsq. All rights reserved.
//

#import "AFNetworking.h"
#import "SQApiProxy.h"
#import "SQURLResponse.h"

#import "SQRequestGenerator.h"
#import "SQLogger.h"


@interface SQApiProxy ()

@property (nonatomic, strong) NSMutableDictionary *dispatchTable;
@property (nonatomic, strong) AFHTTPSessionManager *sessionManager;


@end

@implementation SQApiProxy


+ (instancetype) sharedInstance {
    
    static dispatch_once_t onceToken;
    static SQApiProxy *instance = nil;
    
    dispatch_once(&onceToken, ^{
        instance = [[SQApiProxy alloc] init];
    });
    
    return instance;
}


#pragma mark - member methods

// GET
- (NSInteger) callGETWithParams:(NSDictionary *)params serviceIdentifier:(NSString *)servieIdentifier methodName:(NSString *)methodName success:(SQCallBack)success fail:(SQCallBack)fail {

    NSURLRequest *request = [[SQRequestGenerator sharedInstance] generatorGETRequestWithParams:params serviceIdentifier:servieIdentifier methodName:methodName];
    return [self callApiWithRequest:request success:success fail:fail];
}

// POST
- (NSInteger) callPOSTWithParams:(NSDictionary *)params serviceIdentifier:(NSString *)servieIdentifier methodName:(NSString *)methodName success:(SQCallBack)success fail:(SQCallBack)fail {
    
    NSURLRequest *request = [[SQRequestGenerator sharedInstance] generatorPOSTRequestWithParams:params serviceIdentifier:servieIdentifier methodName:methodName];
    return [self callApiWithRequest:request success:success fail:fail];
}



#pragma mark - private methods
- (NSInteger) callApiWithRequest:(NSURLRequest*)request success:(SQCallBack)success fail:(SQCallBack)fail {
    
    NSURLSessionDataTask *dataTask = [self.sessionManager dataTaskWithRequest:request completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
        
        NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
        NSNumber *reqeustID = @([dataTask taskIdentifier]);
        [self.dispatchTable removeObjectForKey:reqeustID];
        
        NSData *responseData = responseObject;
        NSString *responseString = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];

        if (error) {
            
            [SQLogger logDebugInfoWithResponse:httpResponse
                                 resposeString:responseString
                                       request:request
                                         error:error];
            
            SQURLResponse *response = [[SQURLResponse alloc] initWithRequestID:reqeustID request:request responseData:responseObject error:error];
            
            fail ? fail(response) : nil;
        } else {
            
            [SQLogger logDebugInfoWithResponse:httpResponse
                                 resposeString:responseString
                                       request:request
                                         error:NULL];
            
            SQURLResponse *response = [[SQURLResponse alloc] initWithRequestID:reqeustID request:request responseData:responseObject status:SQURLResponseStatusSuccess];
            
            success ? success(response) : nil;
        }
    }];
    
    NSNumber* requestID = @([dataTask taskIdentifier]);
    self.dispatchTable[requestID] = dataTask;
    [dataTask resume];
    
    return [requestID integerValue];
}

- (void)cancelRequestWithRequestIDList:(NSArray *)cancelList {
    for (NSNumber *requestID in cancelList) {
        [self cancelRequestWithRequestID:[requestID integerValue]];
    }
}


- (void)cancelRequestWithRequestID:(NSInteger)requestID {
    
    NSURLSessionDataTask *task = self.dispatchTable[@(requestID)];
    [task cancel];
    [self.dispatchTable removeObjectForKey:@(requestID)];
}


#pragma mark - getter

- (AFHTTPSessionManager *)sessionManager {
    if (_sessionManager == nil) {
        _sessionManager = [AFHTTPSessionManager manager];
        _sessionManager.responseSerializer = [AFHTTPResponseSerializer serializer];
        _sessionManager.securityPolicy.allowInvalidCertificates = YES;
        _sessionManager.securityPolicy.validatesDomainName = NO;
    }
    
    return _sessionManager;
}

- (NSMutableDictionary *)dispatchTable {
    
    if (_dispatchTable == nil) {
        _dispatchTable = [NSMutableDictionary dictionary];
    }
    
    return _dispatchTable;
}

@end
