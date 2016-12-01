//
//  SQApiProxy.h
//  SQNetWorking
//
//  Created by apple on 16/7/18.
//  Copyright © 2016年 zsq. All rights reserved.
//

#import <Foundation/Foundation.h>

@class SQURLResponse;


typedef void(^SQCallBack)(SQURLResponse *response);


@interface SQApiProxy : NSObject


+ (instancetype) sharedInstance;

// GET
- (NSInteger) callGETWithParams:(NSDictionary *)params serviceIdentifier:(NSString *)servieIdentifier methodName:(NSString *)methodName success:(SQCallBack)success fail:(SQCallBack)fail;

// POST
- (NSInteger) callPOSTWithParams:(NSDictionary *)params serviceIdentifier:(NSString *)servieIdentifier methodName:(NSString *)methodName success:(SQCallBack)success fail:(SQCallBack)fail;


- (void) cancelRequestWithRequestIDList:(NSArray *)cancelList;
- (void) cancelRequestWithRequestID:(NSInteger) requestID;

@end
