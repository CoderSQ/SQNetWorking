//
//  SQUUIDGenerator.m
//  SQNetWorking
//
//  Created by apple on 16/7/22.
//  Copyright © 2016年 zsq. All rights reserved.
//

#import "SQUUIDGenerator.h"

static NSString * kKeyAppUUID = @"KeyAppUUID";
static NSString * kKeyKeychainIdentify  = @"com.company.app.usernamepassword";

@interface SQKeyChainStore : NSObject

+ (void)save:(NSString *)service data:(id)data;
+ (id)load:(NSString *)service;
+ (void)deleteKeyData:(NSString *)service;

@end

@implementation SQKeyChainStore

+ (NSMutableDictionary *)getKeychainQuery:(NSString *)service {
    return [NSMutableDictionary dictionaryWithObjectsAndKeys:
            (id)kSecClassGenericPassword,(id)kSecClass,
            service, (id)kSecAttrService,
            service, (id)kSecAttrAccount,
            (id)kSecAttrAccessibleAfterFirstUnlock,(id)kSecAttrAccessible,
            nil];
}

+ (void)save:(NSString *)service data:(id)data {
    //Get search dictionary
    NSMutableDictionary *keychainQuery = [self getKeychainQuery:service];
    //Delete old item before add new item
    SecItemDelete((CFDictionaryRef)keychainQuery);
    //Add new object to search dictionary(Attention:the data format)
    [keychainQuery setObject:[NSKeyedArchiver archivedDataWithRootObject:data] forKey:(id)kSecValueData];
    //Add item to keychain with the search dictionary
    SecItemAdd((CFDictionaryRef)keychainQuery, NULL);
}

+ (id)load:(NSString *)service {
    id ret = nil;
    NSMutableDictionary *keychainQuery = [self getKeychainQuery:service];
    //Configure the search setting
    //Since in our simple case we are expecting only a single attribute to be returned (the password) we can set the attribute kSecReturnData to kCFBooleanTrue
    [keychainQuery setObject:(id)kCFBooleanTrue forKey:(id)kSecReturnData];
    [keychainQuery setObject:(id)kSecMatchLimitOne forKey:(id)kSecMatchLimit];
    CFDataRef keyData = NULL;
    if (SecItemCopyMatching((CFDictionaryRef)keychainQuery, (CFTypeRef *)&keyData) == noErr) {
        @try {
            ret = [NSKeyedUnarchiver unarchiveObjectWithData:(__bridge NSData *)keyData];
        } @catch (NSException *e) {
            NSLog(@"Unarchive of %@ failed: %@", service, e);
        } @finally {
        }
    }
    if (keyData)
        CFRelease(keyData);
    return ret;
}

+ (void)deleteKeyData:(NSString *)service {
    NSMutableDictionary *keychainQuery = [self getKeychainQuery:service];
    SecItemDelete((CFDictionaryRef)keychainQuery);
}


@end

@implementation SQUUIDGenerator

+(NSString *)getUUID
{
    NSString * strUUID = (NSString *)[SQKeyChainStore load:kKeyKeychainIdentify];
    
    //首次执行该方法时，uuid为空
    if ([strUUID isEqualToString:@""] || !strUUID)
    {
        // 防止profile文件更改，找不到uuid的情况
        strUUID = [[NSUserDefaults standardUserDefaults] objectForKey:kKeyKeychainIdentify];
        
        if (strUUID && strUUID.length) {
            //将该uuid保存到keychain
            [SQKeyChainStore save:kKeyKeychainIdentify data:strUUID];
            return strUUID;
        }
        
        //生成一个uuid的方法
        CFUUIDRef uuidRef = CFUUIDCreate(kCFAllocatorDefault);
        
        strUUID = (NSString *)CFBridgingRelease(CFUUIDCreateString (kCFAllocatorDefault,uuidRef));
        
        [[NSUserDefaults standardUserDefaults] setObject:strUUID forKey:kKeyKeychainIdentify];
        //将该uuid保存到keychain
        [SQKeyChainStore save:kKeyKeychainIdentify data:strUUID];
        
    }
    return strUUID;
}

@end
