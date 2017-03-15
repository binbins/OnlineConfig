//
//  ConfigRequest.m
//  Pods
//
//  Created by 张帆 on 17/3/13.
//
//

#import "ConfigRequest.h"
#import "NSString+ToObject.h"

@import JSONParse;
@import AFNetworking;


@interface ConfigRequest()
@property (nonatomic, retain)AFHTTPSessionManager *afManager;

@end



@implementation ConfigRequest

#pragma mark - get
- (AFHTTPSessionManager *)afManager {
    if (_afManager == nil) {
        _afManager = [AFHTTPSessionManager manager];
        _afManager.requestSerializer = [AFHTTPRequestSerializer serializer];
        _afManager.requestSerializer.timeoutInterval = 15;
        _afManager.requestSerializer.cachePolicy = NSURLRequestReloadIgnoringCacheData;
        _afManager.responseSerializer = [AFJSONResponseSerializer serializerWithReadingOptions:NSJSONReadingAllowFragments];
        _afManager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/html", @"text/json", @"text/plain", @"text/javascript", nil];
    }
    return _afManager;
}

#pragma mark - 暴露方法

+ (void)updateConfig:(NSString *)url {

    if ([JSONParse objIsNull:url]) return;
    
    [[ConfigRequest defauleNetManager] GET:url parameters:AppAdRespInfoDict progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        [USERDEFAULTS setObject:@{} forKey:LocalConfigKey];
        [ConfigRequest checkConfigResult:responseObject];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        NSLog(@"请求在线参数失败");
    }];
}

+ (NSString *)stringForKey:(NSString *)key {
    if ([JSONParse objIsNull:key]) {
        return @"";
    }
    return [JSONParse optString:[ConfigRequest localConfig] valueForKey:key];   //也有问题，返回的不一定是字符串
}

+ (NSDictionary *)dictionaryForKey:(NSString *)key {
    if ([JSONParse objIsNull:key]) {
        return @{};
    }
    NSString *string = [JSONParse optString:[ConfigRequest localConfig] valueForKey:key];
    return [string toNSDictionary];
}

+ (NSArray *)arrayForKey:(NSString *)key {
    if ([JSONParse objIsNull:key]) {
        return @[];
    }
    NSString *string = [JSONParse optString:[ConfigRequest localConfig] valueForKey:key];
    return [string toNSArray];
}

+ (BOOL)boolForKey:(NSString *)key {
    if ([JSONParse objIsNull:key]) {
        return NO;
    }
    NSString *string = [JSONParse optString:[ConfigRequest localConfig] valueForKey:key];
    if ([string isEqualToString:@"true"]) {
        return YES;
    }
    return NO;
}

+ (float)floatForKey:(NSString *)key {
    if ([JSONParse objIsNull:key]) {
        return 0.0f;
    }
    NSString *string = [JSONParse optString:[ConfigRequest localConfig] valueForKey:key];
    return string.floatValue;
}

+ (int)intForKey:(NSString *)key {
    if ([JSONParse objIsNull:key]) {
        return 0;
    }
    NSString *string = [JSONParse optString:[ConfigRequest localConfig] valueForKey:key];
    return string.intValue;
}


#pragma mark - 内部方法

+ (AFHTTPSessionManager *)defauleNetManager {
    
    return [[ConfigRequest alloc] afManager];
}

+ (NSDictionary *)localConfig {

    NSDictionary *dict = [USERDEFAULTS objectForKey:LocalConfigKey];
    if ([JSONParse objIsNull:dict]) {
        return  @{};
    }
    return dict;
}


+ (void)checkConfigResult:(NSDictionary *)result {

    if ([JSONParse objIsNull:result] || ![result isKindOfClass:[NSDictionary class]]) {
        NSLog(@"result 非法");
        return;
    }
    
    if ([JSONParse optInt:result valueForKey:@"code" defValue:-1] != 0) {   //有问题，没有判断是不是string或者number
        NSLog(@"返回值不为0");
        return;
    }
    
    NSDictionary *res = [JSONParse optNSDictionary:result valueForKey:@"res"];
    if ([JSONParse objIsNull:res] || ![res isKindOfClass:[NSDictionary class]]) {
        NSLog(@"res 非法");
        return;
    }
    
    NSDictionary *params = [JSONParse optNSDictionary:res valueForKey:@"params"];   //有问题，没有判断是不是字典
    if ([JSONParse objIsNull:params] || ![params isKindOfClass:[NSDictionary class]]) {
        NSLog(@"params 非法");
        return;
    }
    
    [USERDEFAULTS setObject:params forKey:LocalConfigKey];
    NSLog(@"request succeed ! content:%@",params);
}




@end
