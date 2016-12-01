//
//  SQCachedObject.h
//  SQNetWorking
//
//  Created by apple on 16/7/19.
//  Copyright © 2016年 zsq. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SQCachedObject : NSObject

@property (nonatomic, strong, readonly) NSData * content;
@property (nonatomic, strong, readonly) NSDate * lastUpdateTime;
@property (nonatomic, assign, readonly) BOOL isOutdate;
@property (nonatomic, assign, readonly) BOOL isEmpty;

- (instancetype) initWithContent:(NSData *)content;
- (void) updateContent:(NSData *)content;



@end
