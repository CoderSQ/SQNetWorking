//
//  NSDictionary+SQNetWorkingMethods.h
//  SQNetWorking
//
//  Created by apple on 16/7/21.
//  Copyright © 2016年 zsq. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDictionary (SQNetWorkingMethods)

/**  @param isForSignature YES 是给签名做处理 */
- (NSString *)sq_urlParamsStringSignature:(BOOL)isForSignature;

- (NSString *)sq_jsonString;
- (NSArray *)sq_transformedUrlParamsArraySignature:(BOOL)isForSignature;

@end
