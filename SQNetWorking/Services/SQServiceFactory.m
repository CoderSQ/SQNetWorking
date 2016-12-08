//
//  SQServiceFactory.m
//  Huiyin
//
//  Created by apple on 16/7/24.
//  Copyright © 2016年 7ien. All rights reserved.
//

#import "SQServiceFactory.h"
#import "HYLHService.h"

// TODO: 在这里添加所有serviceTYPE
/** 汇银乐虎后台服务 */
NSString * const kSQServiceTypeHYLH = @"kSQServiceTypeHYLH";

@interface SQServiceFactory ()

@property (nonatomic, strong) NSMutableDictionary *serviceStorage;


@end


@implementation SQServiceFactory

+ (instancetype)sharedInstance {
    
    static dispatch_once_t onceToken;
    static SQServiceFactory * instance = nil;
    dispatch_once(&onceToken, ^{
        instance = [[SQServiceFactory alloc] init];
    });
    
    return instance;
}

- (SQService<SQServiceProtocal> *)serviceWithIdentifyName:(NSString *)serviceIdentifier {
    
    SQService *service = [self.serviceStorage objectForKey:serviceIdentifier];
    if (service == nil) {
        self.serviceStorage[serviceIdentifier] = [self newServiceWithIdentifyName:serviceIdentifier];
    }
    return self.serviceStorage[serviceIdentifier];
}

/**  再这里根据不同的serviceIdentifier返回不同的服务 */
- (SQService<SQServiceProtocal> *) newServiceWithIdentifyName:(NSString *) serviceIdentifier {
   
    //TODO: 这里返回继承自SQService的子类
    if (serviceIdentifier == kSQServiceTypeHYLH) {
        return [[HYLHService alloc] init];
    } else if (serviceIdentifier == kSQServiceTypeDMW) {

    }
    
    return nil;
}

- (NSMutableDictionary *)serviceStorage {
    if (_serviceStorage == nil) {
        _serviceStorage = [NSMutableDictionary dictionary];
    }
    
    return _serviceStorage;
}


@end
