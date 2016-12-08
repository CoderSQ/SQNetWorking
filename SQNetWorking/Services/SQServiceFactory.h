//
//  SQServiceFactory.h
//  Huiyin
//
//  Created by apple on 16/7/24.
//  Copyright © 2016年 7ien. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "SQService.h"

extern NSString * const kSQServiceTypeHYLH;
extern NSString * const kSQServiceTypeDMW;


@interface SQServiceFactory : NSObject

+ (instancetype)sharedInstance;

- (SQService<SQServiceProtocal> *)serviceWithIdentifyName:(NSString *)serviceIdentifier;
@end
