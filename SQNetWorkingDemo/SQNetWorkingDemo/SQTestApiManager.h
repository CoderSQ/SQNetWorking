//
//  SQTestApiManager.h
//  SQNetWorking
//
//  Created by apple on 16/7/21.
//  Copyright © 2016年 zsq. All rights reserved.
//

#import "SQBaseApiManager.h"

@interface SQTestApiManager : SQBaseApiManager <SQApiManager>

- (NSString *)methodName;
- (NSString *)serviceType;
- (SQApiManagerRequestType)requestType;
- (BOOL) shouldCache;

@end
