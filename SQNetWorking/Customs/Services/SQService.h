//
//  SQService.h
//  SQNetWorking
//
//  Created by apple on 16/7/19.
//  Copyright © 2016年 zsq. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SQService : NSObject



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
