//
//  SQURLResponse.m
//  SQNetWorking
//
//  Created by apple on 16/7/18.
//  Copyright © 2016年 zsq. All rights reserved.
//

#import "SQURLResponse.h"
#import "NSURLRequest+RequestParams.h"


@interface SQURLResponse ()

@property (nonatomic, assign, readwrite) SQURLResponseStatus status;
@property (nonatomic, copy,   readwrite) NSString            * contentString;
@property (nonatomic, strong, readwrite) id                  content;
@property (nonatomic, assign, readwrite) NSInteger           requestID;
@property (nonatomic, strong, readwrite) NSURLRequest        * request;
@property (nonatomic, strong, readwrite) NSData              * responseData;

@end

@implementation SQURLResponse


- (instancetype)initWithRequestID:(NSNumber *)requestID request:(NSURLRequest *)request responseData:(NSData *)respData error:(NSError *)error {
    
    if (self = [super init]) {
        
        if (respData) {
            self.contentString = [[NSString alloc] initWithData:respData encoding:NSUTF8StringEncoding];
            self.content = [NSJSONSerialization JSONObjectWithData:respData options:kNilOptions error:nil];
        }
        
        self.requestID     = [requestID integerValue];
        self.request       = request;
        self.requestParams = request.requestParams;
        self.responseData  = respData;
        self.status        = [self responseStatusWithError:error];
        self.isCache       = NO;
    }
    
    return self;
}


- (instancetype)initWithRequestID:(NSNumber *)requestID request:(NSURLRequest *)request responseData:(NSData *)respData status:(SQURLResponseStatus)status {
    
    if (self = [super init]) {
        
        if (respData) {
            self.contentString = [[NSString alloc] initWithData:respData encoding:NSUTF8StringEncoding];
            self.content = [NSJSONSerialization JSONObjectWithData:respData options:kNilOptions error:nil];
        }
        
        self.requestID     = [requestID integerValue];
        self.request       = request;
        self.requestParams = request.requestParams;
        self.responseData  = respData;
        self.status        = status;
        self.isCache       = NO;
    }
    
    return self;
}

- (instancetype)initWithData:(NSData *)data {

    self = [super init];
    if (self) {
        self.contentString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        self.status = [self responseStatusWithError:nil];
        self.requestID = 0;
        self.request = nil;
        self.responseData = [data copy];
        self.content = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:NULL];
        self.isCache = YES;
    }
    return self;
}

- (SQURLResponseStatus)responseStatusWithError:(NSError *)error {
    if (error) {
        
        // 除了超时的错误以外，所有的错误都认为是网络错误
        if (error.code == NSURLErrorTimedOut) {
            return SQURLResponseStatusErrorTimeout;
        }
        
        return SQURLResponseStatusErrorNoNetwork;
    }
    
    return SQURLResponseStatusSuccess;
}

@end
