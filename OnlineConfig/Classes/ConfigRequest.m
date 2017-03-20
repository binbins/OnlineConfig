//
//  ConfigRequest.m
//  Pods
//
//  Created by 张帆 on 17/3/13.
//
//

#import "ConfigRequest.h"
#import "SafeObject.h"
#import "NSString+ToObject.h"


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

+ (AFHTTPSessionManager *)afManager {
    return [[ConfigRequest alloc] afManager];
}

+ (void)updateConfig:(NSString *)url {

    if ([SafeObject objIsNull:url]) return;
    
    [[ConfigRequest afManager] GET:url parameters:AppAdRespInfoDict progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        if ([USERDEFAULTS objectForKey:LocalConfigKey] == nil) {
            [USERDEFAULTS setObject:@{@"la":@"la"} forKey:LocalConfigKey];
        }
        [ConfigRequest checkConfigResult:responseObject];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        NSLog(@"请求在线参数失败");
    }];
}

+ (NSString *)stringForKey:(NSString *)key {
    if ([SafeObject objIsNull:key]) {
        return @"";
    }
    return [SafeObject safeString:[ConfigRequest localConfig] objectForKey:key];   //也有问题，返回的不一定是字符串
}

+ (NSDictionary *)dictionaryForKey:(NSString *)key {
    if ([SafeObject objIsNull:key]) {
        return @{};
    }
    NSString *string = [SafeObject safeString:[ConfigRequest localConfig] objectForKey:key];
    return [string toNSDictionary];
}

+ (NSArray *)arrayForKey:(NSString *)key {
    if ([SafeObject objIsNull:key]) {
        return @[];
    }
    NSString *string = [SafeObject safeString:[ConfigRequest localConfig] objectForKey:key];
    return [string toNSArray];
}

+ (BOOL)boolForKey:(NSString *)key {
    if ([SafeObject objIsNull:key]) {
        return NO;
    }
    NSString *string = [SafeObject safeString:[ConfigRequest localConfig] objectForKey:key];
    return string.boolValue;
}

+ (float)floatForKey:(NSString *)key {
    if ([SafeObject objIsNull:key]) {
        return 0.0f;
    }
    NSString *string = [SafeObject safeString:[ConfigRequest localConfig] objectForKey:key];  
    return string.floatValue;
}

+ (int)intForKey:(NSString *)key {
    if ([SafeObject objIsNull:key]) {
        return -1;
    }
    NSString *string = [SafeObject safeString:[ConfigRequest localConfig] objectForKey:key];
    return string.intValue;
}

+ (NSDictionary *)localConfig {
    
    NSDictionary *dict = [USERDEFAULTS objectForKey:LocalConfigKey];
    if ([SafeObject objIsNull:dict]) {
        return  @{};
    }
    return dict;
}

#pragma mark - 内部方法

+ (void)checkConfigResult:(NSDictionary *)result {

    if ([SafeObject objIsNull:result] || ![result isKindOfClass:[NSDictionary class]]) {
        NSLog(@"result 非法");
        return;
    }
    
    if ([SafeObject safeInt:result objectForKey:@"code"] != 0) {   //有问题，没有判断是不是string或者number
        NSLog(@"返回值不为0");
        return;
    }
    
    NSDictionary *res = [SafeObject safeDictionary:result objectForKey:@"res"];
    if ([SafeObject objIsNull:res] || ![res isKindOfClass:[NSDictionary class]]) {
        NSLog(@"res 非法");
        return;
    }
    
    NSDictionary *params = [SafeObject safeDictionary:res objectForKey:@"params"];   //有问题，没有判断是不是字典
    if ([SafeObject objIsNull:params] || ![params isKindOfClass:[NSDictionary class]]) {
        NSLog(@"params 非法");
        return;
    }
    
    [USERDEFAULTS setObject:params forKey:LocalConfigKey];
    NSLog(@"request succeed ! content:%@",params);
}


@end
