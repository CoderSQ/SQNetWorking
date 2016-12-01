//
//  SQRequestGenerator.h
//  SQNetWorking
//
//  Created by apple on 16/7/19.
//  Copyright © 2016年 zsq. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SQRequestGenerator : NSObject

+ (instancetype) sharedInstance;

// GET 请求
- (NSURLRequest *) generatorGETRequestWithParams:(NSDictionary *)params serviceIdentifier:(NSString *)servieIdentifier methodName:(NSString *)methodName;

// POST 请求
- (NSURLRequest *) generatorPOSTRequestWithParams:(NSDictionary *)params serviceIdentifier:(NSString *)servieIdentifier methodName:(NSString *)methodName;
@end
