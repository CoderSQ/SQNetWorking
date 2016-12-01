//
//  SQURLResponse.h
//  SQNetWorking
//
//  Created by apple on 16/7/18.
//  Copyright © 2016年 zsq. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, SQURLResponseStatus)
{
    SQURLResponseStatusSuccess, //作为底层，请求是否成功只考虑是否成功收到服务器反馈。至于签名是否正确，返回的数据是否完整，由上层的SQBaseApiManager来决定。
    SQURLResponseStatusErrorTimeout,
    SQURLResponseStatusErrorNoNetwork // 默认除了超时以外的错误都是无网络错误。
};

@interface SQURLResponse : NSObject

@property (nonatomic, assign, readonly) SQURLResponseStatus status;

@property (nonatomic, copy, readonly  ) NSString            * contentString;

//** 原始数据转换成的对象 */
@property (nonatomic, strong, readonly) id                  content;

@property (nonatomic, assign, readonly) NSInteger           requestID;
@property (nonatomic, strong, readonly) NSURLRequest        * request;

//** 返回的原始数据 */
@property (nonatomic, strong, readonly) NSData              * responseData;
@property (nonatomic, copy            ) NSDictionary        * requestParams;

//* 是否是从缓存中取的数据*/
@property (nonatomic, assign          ) BOOL                isCache;


- (instancetype) initWithRequestID:(NSNumber *)requestID request:(NSURLRequest *) request responseData:(NSData *)respData error:(NSError *)error;

- (instancetype) initWithRequestID:(NSNumber *)requestID request:(NSURLRequest *) request responseData:(NSData *)respData status:(SQURLResponseStatus)status;

- (instancetype) initWithData:(NSData *) data;
@end
