//
//  SQService.h
//  SQNetWorking
//
//  Created by apple on 16/7/19.
//  Copyright © 2016年 zsq. All rights reserved.
//

#import <Foundation/Foundation.h>

// 所有SQService的派生类都要符合这个protocal
@protocol SQServiceProtocal <NSObject>

@property (nonatomic, readonly) BOOL isOnline;

@property (nonatomic, readonly) NSString *offlineApiBaseUrl;
@property (nonatomic, readonly) NSString *onlineApiBaseUrl;

@property (nonatomic, readonly) NSString *offlineApiVersion;
@property (nonatomic, readonly) NSString *onlineApiVersion;

@property (nonatomic, readonly) NSString *onlinePublicKey;
@property (nonatomic, readonly) NSString *offlinePublicKey;

@property (nonatomic, readonly) NSString *onlinePrivateKey;
@property (nonatomic, readonly) NSString *offlinePrivateKey;

@end

@interface SQService : NSObject

@property (nonatomic, weak) id<SQServiceProtocal> child;


/** 公钥 */
@property (nonatomic, strong, readonly) NSString * publicKey;

/** 私钥 */
@property (nonatomic, strong, readonly) NSString * privateKey;

/** url */
@property (nonatomic, strong, readonly) NSString * apiBaseUrl;

/** 版本 */
@property (nonatomic, strong, readonly) NSString * apiVersion;


+ (instancetype) sharedInstance;


/** 根据方法名返回访问该方法的Url字符串 */
- (NSString *) urlStringWithMethodName:(NSString *) methodName;

@end
