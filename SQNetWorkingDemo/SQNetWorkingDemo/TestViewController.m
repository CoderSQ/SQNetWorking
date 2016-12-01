//
//  TestViewController.m
//  SQNetWorking
//
//  Created by apple on 16/7/21.
//  Copyright © 2016年 zsq. All rights reserved.
//

#import "TestViewController.h"

#import "SQTestApiManager.h"

@interface TestViewController () <SQApiManagerCallBackDelegate, SQApiManagerParamSource>

@property (nonatomic, strong) SQTestApiManager *testManager;


@end

@implementation TestViewController


- (void)viewDidLoad {

    self.view.backgroundColor = [UIColor whiteColor];
    [self.testManager loadData];
}

#pragma mark - SQApiManagerParamSource
- (NSDictionary *)paramsForManager:(SQBaseApiManager *)manager {
//    return @{@"key1" : @"value1", @"key2" : @"value2"};
    return @{@"code" : @"111111",
             @"origin" : @"4",
             @"password" : @"96e79218965eb72c92a549dd5a330112",
             @"phone" : @"18800000005",
             @"pwdSafe" : @"1",
             @"referralCode" : @"111",
             @"mKey" : @"b8dab3b42a32e1930f25e84f1050cdc9",
             @"time" : @"20160727205101"
             };
}

#pragma mark - SQApiManagerCallBackDelegate
- (void)managerCallAPIDidSucced:(SQBaseApiManager *)manager {
    
    if (self.testManager == manager) {
        NSLog(@"回调成功 %@",
              manager.response.content);
    }
}

- (void)managerCallAPIDidFail:(SQBaseApiManager *)manager {
    if (self.testManager == manager) {
        NSLog(@"回调失败,error = %zd",
              manager.errorType);
    }
}


#pragma mark - getter 
- (SQTestApiManager *)testManager {
    if (_testManager == nil) {
        _testManager = [[SQTestApiManager alloc] init];
        _testManager.delegate = self;
        _testManager.parmSource = self;
    }
    
    return _testManager;
}
@end
