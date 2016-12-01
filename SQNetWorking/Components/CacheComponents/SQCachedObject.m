//
//  SQCachedObject.m
//  SQNetWorking
//
//  Created by apple on 16/7/19.
//  Copyright © 2016年 zsq. All rights reserved.
//

#import "SQCachedObject.h"
#import "SQNetWorkingConfig.h"


@interface SQCachedObject ()

@property (nonatomic, strong, readwrite) NSData * content;
@property (nonatomic, strong, readwrite) NSDate * lastUpdateTime;

@end

@implementation SQCachedObject

#pragma mark - lifecycle
- (instancetype)initWithContent:(NSData *)content {
    
    if (self  = [super init]) {
        self.content = content;
    }
    
    return self;
}

#pragma mark - public method
- (void)updateContent:(NSData *)content {
    self.content = content;
    self.lastUpdateTime = [NSDate dateWithTimeIntervalSinceNow:0];
}

#pragma mark - getter
- (BOOL)isEmpty {
    return self.content == nil;
}

- (BOOL)isOutdate {
    NSTimeInterval interval = [[NSDate date] timeIntervalSinceDate:self.lastUpdateTime];
    return interval > kSQCacheOutdateTimeSeconds;
}
@end
