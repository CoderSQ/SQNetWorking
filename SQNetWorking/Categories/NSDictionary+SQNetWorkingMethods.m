//
//  NSDictionary+SQNetWorkingMethods.m
//  SQNetWorking
//
//  Created by apple on 16/7/21.
//  Copyright © 2016年 zsq. All rights reserved.
//

#import "NSDictionary+SQNetWorkingMethods.h"
#import "NSArray+SQNetWorkingMethods.h"

@implementation NSDictionary (SQNetWorkingMethods)

/** 字符串前面是没有问号的，如果用于POST，那就不用加问号，如果用于GET，就要加个问号 */
- (NSString *)sq_urlParamsStringSignature:(BOOL)isForSignature
{
    NSArray *sortedArray = [self sq_transformedUrlParamsArraySignature:isForSignature];
    return [sortedArray sq_paramsString];
}

/** 字典变json */
- (NSString *)sq_jsonString
{
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:self options:NSJSONWritingPrettyPrinted error:NULL];
    return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
}

/** 转义参数 */
- (NSArray *)sq_transformedUrlParamsArraySignature:(BOOL)isForSignature
{
    NSMutableArray *result = [[NSMutableArray alloc] init];
    [self enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        if (![obj isKindOfClass:[NSString class]]) {
            obj = [NSString stringWithFormat:@"%@", obj];
        }
        if (!isForSignature) {
            NSString *obj1 = [obj copy];
            obj = (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(NULL,  (CFStringRef)obj,  NULL,  (CFStringRef)@"!*'();:@&;=+$,/?%#[]",  kCFStringEncodingUTF8));
            obj1 = [obj1 stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            NSLog(@"obj = %@, obj1 = %@", obj,obj1);
        }
        if ([obj length] > 0) {
            [result addObject:[NSString stringWithFormat:@"%@=%@", key, obj]];
        }
    }];
    NSArray *sortedResult = [result sortedArrayUsingSelector:@selector(compare:)];
    return sortedResult;
}

@end
