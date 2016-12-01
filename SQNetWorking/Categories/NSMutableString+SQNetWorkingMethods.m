//
//  NSMutableString+SQNetWorkingMethods.m
//  SQNetWorking
//
//  Created by apple on 16/7/22.
//  Copyright © 2016年 zsq. All rights reserved.
//

#import "NSMutableString+SQNetWorkingMethods.h"
#import "NSObject+SQNetWorkingMethods.h"

@implementation NSMutableString (SQNetWorkingMethods)

- (void)appendURLRequest:(NSURLRequest *)request
{
    [self appendFormat:@"\n\nHTTP URL:\n\t%@", request.URL];
    [self appendFormat:@"\n\nHTTP Header:\n%@", request.allHTTPHeaderFields ? request.allHTTPHeaderFields : @"\t\t\t\t\tN/A"];
    [self appendFormat:@"\n\nHTTP Body:\n\t%@", [[[NSString alloc] initWithData:request.HTTPBody encoding:NSUTF8StringEncoding] sq_defaultValue:@"\t\t\t\tN/A"]];
}

@end
