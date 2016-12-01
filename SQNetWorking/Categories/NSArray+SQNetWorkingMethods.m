//
//  NSArray+SQNetWorkingMethods.m
//  SQNetWorking
//
//  Created by apple on 16/7/21.
//  Copyright © 2016年 zsq. All rights reserved.
//

#import "NSArray+SQNetWorkingMethods.h"

@implementation NSArray (SQNetWorkingMethods)

/** 字母排序之后形成的参数字符串 */
- (NSString *)sq_paramsString
{
    NSMutableString *paramString = [[NSMutableString alloc] init];
    
    NSArray *sortedParams = [self sortedArrayUsingSelector:@selector(compare:)];
    [sortedParams enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        
        if ([paramString length] == 0) {
            [paramString appendFormat:@"%@", obj];
        } else {
            [paramString appendFormat:@"&%@", obj];
        }
    }];
    
    return paramString;
}

/** 数组变json */
- (NSString *)sq_jsonString
{
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:self options:NSJSONWritingPrettyPrinted error:NULL];
    return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
}

@end
