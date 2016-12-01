//
//  NSURLRequest+RequestParams.m
//  SQNetWorking
//
//  Created by apple on 16/7/19.
//  Copyright © 2016年 zsq. All rights reserved.
//

#import "NSURLRequest+RequestParams.h"
#import <objc/runtime.h>

static void * const kSQURLRequestParams;

@implementation NSURLRequest (RequestParams)

- (NSDictionary *) requestParams {
    return objc_getAssociatedObject(self, &kSQURLRequestParams);
}
- (void) setRequestParams:(NSDictionary *)requestParams {
    objc_setAssociatedObject(self, &kSQURLRequestParams, requestParams, OBJC_ASSOCIATION_COPY);
}
@end
