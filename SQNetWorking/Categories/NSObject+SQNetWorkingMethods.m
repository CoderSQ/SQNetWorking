//
//  NSObject+SQNetWorkingMethods.m
//  SQNetWorking
//
//  Created by apple on 16/7/22.
//  Copyright © 2016年 zsq. All rights reserved.
//

#import "NSObject+SQNetWorkingMethods.h"

@implementation NSObject (SQNetWorkingMethods)

- (id)sq_defaultValue:(id)defaultData
{
    if (![defaultData isKindOfClass:[self class]]) {
        return defaultData;
    }
    
    if ([self sq_isEmptyObject]) {
        return defaultData;
    }
    
    return self;
}

- (BOOL)sq_isEmptyObject
{
    if ([self isEqual:[NSNull null]]) {
        return YES;
    }
    
    if ([self isKindOfClass:[NSString class]]) {
        if ([(NSString *)self length] == 0) {
            return YES;
        }
    }
    
    if ([self isKindOfClass:[NSArray class]]) {
        if ([(NSArray *)self count] == 0) {
            return YES;
        }
    }
    
    if ([self isKindOfClass:[NSDictionary class]]) {
        if ([(NSDictionary *)self count] == 0) {
            return YES;
        }
    }
    
    return NO;
}
@end
