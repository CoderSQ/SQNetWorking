//
//  SQBaseApiManager.h
//  SQNetWorking
//
//  Created by apple on 16/7/18.
//  Copyright © 2016年 zsq. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SQURLResponse.h"

@class SQBaseApiManager;

// 在调用成功之后的params字典里面，用这个key可以取出requestID
static NSString * const kSQAPIBaseManagerRequestID = @"kSQBaseApiManagerRequestID";

// token通知常量
static NSString * const kUserTokenInvalidNotification = @"kUserTokenInvalidNotification";
static NSString * const kUserTokenIllegalNotification = @"kUserTokenIllegalNotification";

static NSString * const kUserTokenNotificationKeyRequestToContinue = @"kUserTokenNotificationKeyRequestToContinue";
static NSString * const kUserTokenNotificationKeyManagerToContinue = @"kUserTokenNotificationKeyManagerToContinue";


typedef NS_ENUM(NSUInteger, SQApiManagerRequestType) {
    SQApiManagerRequestTypeGet,
    SQApiManagerRequestTypePost,
};

/*
 当产品要求返回数据不正确或者为空的时候显示一套UI，请求超时和网络不通的时候显示另一套UI时，使用这个enum来决定使用哪种UI。
 你不应该在回调数据验证函数里面设置这些值，事实上，在任何派生的子类里面你都不应该自己设置manager的这个状态，baseManager已经帮你搞定了。
 强行修改manager的这个状态有可能会造成程序流程的改变，容易造成混乱。
 */
typedef NS_ENUM (NSUInteger, SQAPIManagerErrorType){
    SQAPIManagerErrorTypeDefault,       //没有产生过API请求，这个是manager的默认状态。
    SQAPIManagerErrorTypeSuccess,       //API请求成功且返回数据正确，此时manager的数据是可以直接拿来使用的。
    SQAPIManagerErrorTypeNoContent,     //API请求成功但返回数据不正确。如果回调数据验证函数返回值为NO，manager的状态就会是这个。
    SQAPIManagerErrorTypeParamsError,   //参数错误，此时manager不会调用API，因为参数验证是在调用API之前做的。
    SQAPIManagerErrorTypeTimeout,       //请求超时。SQAPIProxy设置的是20秒超时，具体超时时间的设置请自己去看SQAPIProxy的相关代码。
    SQAPIManagerErrorTypeNoNetWork      //网络不通。在调用API之前会判断一下当前网络是否通畅，这个也是在调用API之前验证的，和上面超时的状态是有区别的。
};


/*************************************************************************************************/
/*                               SQApiManager                                 */
/*************************************************************************************************/

/** SQBaseApiManager的派生类必须符合这些protocal */
@protocol SQApiManager <NSObject>

@required

/** 请求方法名 */
- (NSString *)methodName;

/** 请求哪个服务器的服务 备用*/
- (NSString *)serviceType;

/** 请求方法类型 GET / POST */
- (SQApiManagerRequestType)requestType;

/** 是否缓存该方法数据 nscache缓存*/
- (BOOL)shouldCache;

// used for pagable API Managers mainly
@optional

- (void)cleanData;
- (NSDictionary *)reformParams:(NSDictionary *)params;
- (NSInteger)loadDataWithParams:(NSDictionary *)params;

/** 是否使用本地缓存 */
- (BOOL)shouldLoadFromNative;
@end




/*************************************************************************************************/
/*                               SQApiManagerCallBackDelegate                                 */
/*************************************************************************************************/

//api回调
@protocol SQApiManagerCallBackDelegate <NSObject>

@required
- (void) managerCallAPIDidSucced:(SQBaseApiManager *)manager;
- (void) managerCallAPIDidFail:(SQBaseApiManager *)manager;

@end




/*************************************************************************************************/
/*                               SQApiManagerParamSource                                 */
/*************************************************************************************************/

/** api请求参数协议，当前api的请求参数通过这个协议中的方法获取 */
@protocol SQApiManagerParamSource <NSObject>

@required
- (NSDictionary *) paramsForManager:(SQBaseApiManager *)manager;

@end




/*************************************************************************************************/
/*                               SQApiManagerDataReformer                                 */
/*************************************************************************************************/

/** SQBaseApiManager的子类发起请求，回调请求数据后，通过reformer生产出适合view使用的数据 */
@protocol SQApiManagerDataReformer <NSObject>

- (id) manager:(SQBaseApiManager *)manager reformData:(NSDictionary *)data;

@end



/*************************************************************************************************/
/*                               SQApiManagerValidator                                 */
/*************************************************************************************************/

/** 验证请求参数以及回调数据是否合法的协议 */
@protocol SQApiManagerValidator <NSObject>

/** 验证回调数据是否合法 */
- (BOOL) manager:(SQBaseApiManager *)manager isCorrectWithCallBackData:(NSDictionary *)data;

/** 验证请求参数是否合法 */
- (BOOL) manager:(SQBaseApiManager *)manager isCorrectWithParamsData:(NSDictionary *)data;

@end



/*************************************************************************************************/
/*                               SQApiManagerValidator                                 */
/*************************************************************************************************/

/** 拦截器 在指定时刻前后分别调用这些协议方法 */

@protocol SQApiManagerIntercetor <NSObject>

- (BOOL) manager:(SQBaseApiManager *)manager shouldCallApiWithParams:(NSDictionary *)params;
- (void) manager:(SQBaseApiManager *)manager afterCallApiWithParams:(NSDictionary *)params;

- (BOOL) manager:(SQBaseApiManager *)manager beforePerformSuccessWithResponse:(SQURLResponse *)response;
- (void) manager:(SQBaseApiManager *)manager afterPerformSuccessWithResponse:(SQURLResponse *)response;

- (BOOL) manager:(SQBaseApiManager *)manager beforePerformFailWithResponse:(SQURLResponse *)response;
- (void) manager:(SQBaseApiManager *)manager afterPerformFailWithResponse:(SQURLResponse *)response;

@end



@interface SQBaseApiManager : NSObject

// id 无法调用methodForSelector方法， 所以用nsobject
@property (nonatomic, weak) NSObject<SQApiManager          > *child;
@property (nonatomic, weak) id<SQApiManagerCallBackDelegate> delegate;
@property (nonatomic, weak) id<SQApiManagerParamSource     > parmSource;
@property (nonatomic, weak) id<SQApiManagerValidator       > validator;
@property (nonatomic, weak) id<SQApiManagerIntercetor      > intercetor;


/*
 baseManager是不会去设置errorMessage的，派生的子类manager可能需要给controller提供错误信息。所以为了统一外部调用的入口，设置了这个变量。
 派生的子类需要通过extension来在保证errorMessage在对外只读的情况下使派生的manager子类对errorMessage具有写权限。
 */
@property (nonatomic, copy, readonly  ) NSString              *errorMessage;
@property (nonatomic, assign, readonly) SQAPIManagerErrorType errorType;
@property (nonatomic, assign, readonly) SQURLResponse         *response;
@property (nonatomic, assign, readonly) BOOL                  isReachable;
@property (nonatomic, assign, readonly) BOOL                  isLoading;


/**
 * 通过这个接口传入一个reformer，返回适合业务使用的数据
 */
- (id) fetchDataWithReformer:(id<SQApiManagerDataReformer>)reformer;

/**
 *  使用loadData这个方法,这个方法会通过param source来获得参数，这使得参数的生成逻辑位于controller中的固定位置
 *   @return requestID  请求标识数
 */
- (NSInteger) loadData;

/**  复杂场景用这个方法调用接口*/
- (NSInteger) loadDataWithParams:(NSDictionary *)dict;

- (void) cancelAllRequests;
- (void) cancelRequestWithRequestID:(NSInteger) requestID;


// 拦截器方法
- (BOOL) shouldCallApiWithParams:(NSDictionary *)params;
- (void) afterCallApiWithParams:(NSDictionary *)params;
- (BOOL) beforePerformSuccessWithResponse:(SQURLResponse *)response;
- (void) afterPerformSuccessWithResponse:(SQURLResponse *)response;
- (BOOL) beforePerformFailWithResponse:(SQURLResponse *)response;
- (void) afterPerformFailWithResponse:(SQURLResponse *)response;

// SQApiManager 协议方法 SQBaseApiManager不遵循该协议，只实现
- (NSDictionary *)reformParams:(NSDictionary *)params;
- (void)cleanData;
- (BOOL)shouldCache;

// SQApiManagerCallBackDelegate 协议方法 SQBaseApiManager不遵循该协议，只实现
- (void)successedOnCallingAPI:(SQURLResponse *)response;
- (void)failedOnCallingAPI:(SQURLResponse *)response withErrorType:(SQAPIManagerErrorType)errorType;

@end






