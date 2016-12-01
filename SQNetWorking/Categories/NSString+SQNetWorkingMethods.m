//
//  NSString+SQNetWorkingMethods.m
//  SQNetWorking
//
//  Created by apple on 16/7/22.
//  Copyright © 2016年 zsq. All rights reserved.
//

#import "NSString+SQNetWorkingMethods.h"
#import <CommonCrypto/CommonDigest.h>

@implementation NSString (SQNetWorkingMethods)

- (NSString *)sq_md5
{
    NSData* inputData = [self dataUsingEncoding:NSUTF8StringEncoding];
    unsigned char outputData[CC_MD5_DIGEST_LENGTH];
    CC_MD5([inputData bytes], (unsigned int)[inputData length], outputData);
    
    NSMutableString* hashStr = [NSMutableString string];
    int i = 0;
    for (i = 0; i < CC_MD5_DIGEST_LENGTH; ++i)
        [hashStr appendFormat:@"%02x", outputData[i]];
    
    return hashStr;
}
@end
