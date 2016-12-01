//
//  SQSignatureGenerator.m
//  SQNetWorking
//
//  Created by apple on 16/7/22.
//  Copyright © 2016年 zsq. All rights reserved.
//

#import "SQSignatureGenerator.h"
#import "NSDictionary+SQNetWorkingMethods.h"
#import "NSArray+SQNetWorkingMethods.h"
#import "NSString+SQNetWorkingMethods.h"

@implementation SQSignatureGenerator

+ (NSString *)signGetWithSigParams:(NSDictionary *)allParams methodName:(NSString *)methodName apiVersion:(NSString *)apiVersion privateKey:(NSString *)privateKey publicKey:(NSString *)publicKey
{
    NSString *sigString = [allParams sq_urlParamsStringSignature:YES];
    return [[NSString stringWithFormat:@"%@%@", sigString, privateKey] sq_md5];
}

+ (NSString *)signRestfulGetWithAllParams:(NSDictionary *)allParams methodName:(NSString *)methodName apiVersion:(NSString *)apiVersion privateKey:(NSString *)privateKey
{
    NSString *part1 = [NSString stringWithFormat:@"%@/%@", apiVersion, methodName];
    NSString *part2 = [allParams sq_urlParamsStringSignature:YES];
    NSString *part3 = privateKey;
    
    NSString *beforeSign = [NSString stringWithFormat:@"%@%@%@", part1, part2, part3];
    return [beforeSign sq_md5];
}

+ (NSString *)signPostWithApiParams:(NSDictionary *)apiParams privateKey:(NSString *)privateKey publicKey:(NSString *)publicKey
{
    NSMutableDictionary *sigParams = [NSMutableDictionary dictionaryWithDictionary:apiParams];
    sigParams[@"api_key"] = publicKey;
    NSString *sigString = [sigParams sq_urlParamsStringSignature:YES];
    return [[NSString stringWithFormat:@"%@%@", sigString, privateKey] sq_md5];
}

+ (NSString *)signRestfulPOSTWithApiParams:(id)apiParams commonParams:(NSDictionary *)commonParams methodName:(NSString *)methodName apiVersion:(NSString *)apiVersion privateKey:(NSString *)privateKey
{
    NSString *part1 = [NSString stringWithFormat:@"%@/%@", apiVersion, methodName];
    NSString *part2 = [commonParams sq_urlParamsStringSignature:YES];
    NSString *part3 = nil;
    if ([apiParams isKindOfClass:[NSDictionary class]]) {
        part3 = [(NSDictionary *)apiParams sq_jsonString];
    } else if ([apiParams isKindOfClass:[NSArray class]]) {
        part3 = [(NSArray *)apiParams sq_jsonString];
    } else {
        return @"";
    }
    
    NSString *part4 = privateKey;
    
    NSString *beforeSign = [NSString stringWithFormat:@"%@%@%@%@", part1, part2, part3, part4];
    
    return [beforeSign sq_md5];
}

@end
