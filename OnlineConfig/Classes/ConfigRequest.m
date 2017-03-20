//
//  ConfigRequest.m
//  Pods
//
//  Created by 张帆 on 17/3/13.
//
//

#import "ConfigRequest.h"
#import "NSString+ToObject.h"


@interface ConfigRequest()


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

    if ([self objIsNull:url]) return;
    
    [[ConfigRequest defauleNetManager] GET:url parameters:AppAdRespInfoDict progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        if ([USERDEFAULTS objectForKey:LocalConfigKey] == nil) {
            [USERDEFAULTS setObject:@{@"la":@"la"} forKey:LocalConfigKey];
        }
        
        [ConfigRequest checkConfigResult:responseObject];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        NSLog(@"请求在线参数失败");
    }];
}

+ (NSString *)stringForKey:(NSString *)key {
    if ([self objIsNull:key]) {
        return @"";
    }
    return [self optString:[ConfigRequest localConfig] objectForKey:key];   //也有问题，返回的不一定是字符串
}

+ (NSDictionary *)dictionaryForKey:(NSString *)key {
    if ([self objIsNull:key]) {
        return @{};
    }
    NSString *string = [self optString:[ConfigRequest localConfig] objectForKey:key];
    return [string toNSDictionary];
}

+ (NSArray *)arrayForKey:(NSString *)key {
    if ([self objIsNull:key]) {
        return @[];
    }
    NSString *string = [self optString:[ConfigRequest localConfig] objectForKey:key];
    return [string toNSArray];
}

+ (BOOL)boolForKey:(NSString *)key {
    if ([self objIsNull:key]) {
        return NO;
    }
    NSString *string = [self optString:[ConfigRequest localConfig] objectForKey:key];
    if ([string isEqualToString:@"true"]) {
        return YES;
    }
    return NO;
}

+ (float)floatForKey:(NSString *)key {
    if ([self objIsNull:key]) {
        return 0.0f;
    }
    NSString *string = [self optString:[ConfigRequest localConfig] objectForKey:key];  
    return string.floatValue;
}

+ (int)intForKey:(NSString *)key {
    if ([self objIsNull:key]) {
        return 0;
    }
    NSString *string = [self optString:[ConfigRequest localConfig] objectForKey:key];
    return string.intValue;
}


#pragma mark - 内部方法

+ (AFHTTPSessionManager *)defauleNetManager {
    
    return [[ConfigRequest alloc] afManager];
}

+ (NSDictionary *)localConfig {

    NSDictionary *dict = [USERDEFAULTS objectForKey:LocalConfigKey];
    if ([self objIsNull:dict]) {
        return  @{};
    }
    return dict;
}


+ (void)checkConfigResult:(NSDictionary *)result {

    if ([self objIsNull:result] || ![result isKindOfClass:[NSDictionary class]]) {
        NSLog(@"result 非法");
        return;
    }
    
    if ([self optInt:result objectForKey:@"code"] != 0) {   //有问题，没有判断是不是string或者number
        NSLog(@"返回值不为0");
        return;
    }
    
    NSDictionary *res = [self optDictionary:result objectForKey:@"res"];
    if ([self objIsNull:res] || ![res isKindOfClass:[NSDictionary class]]) {
        NSLog(@"res 非法");
        return;
    }
    
    NSDictionary *params = [self optDictionary:res objectForKey:@"params"];   //有问题，没有判断是不是字典
    if ([self objIsNull:params] || ![params isKindOfClass:[NSDictionary class]]) {
        NSLog(@"params 非法");
        return;
    }
    
    [USERDEFAULTS setObject:params forKey:LocalConfigKey];
    NSLog(@"request succeed ! content:%@",params);
}

#pragma mark - 代替jsonparse的方法

+ (BOOL)objIsNull:(id)obj {
    return (obj == nil && [obj isEqual:[NSNull null]]) ? YES : NO;
}

+ (int)optInt:(NSDictionary *)dict objectForKey:(NSString *)key {
    int result = -1;
    
    if ([self objIsNull:dict] || ![dict isKindOfClass:[NSDictionary class]]) {
        NSLog(@"字典非法");
    }
    
    if ([self objIsNull:key] || ![key isKindOfClass:[NSString class]]) {
        NSLog(@"(字典）key非法");
    }

    NSString *value = [dict objectForKey:key];
    if ([value isKindOfClass:[NSString class]]) {
        result = value.intValue;
    }
    
    if ([value isKindOfClass:[NSNumber class]]) {//不太合适哈
        result = value.intValue;
    }
    
    return result;
}

+ (NSString *)optString:(NSDictionary *)dict objectForKey:(NSString *)key {
    NSString *resutl = @"";
    
    if ([self objIsNull:dict] || ![dict isKindOfClass:[NSDictionary class]]) {
        NSLog(@"字典非法");
    }
    
    if ([self objIsNull:key] || ![key isKindOfClass:[NSString class]]) {
        NSLog(@"（int）key非法");
    }

    NSString *value = [dict objectForKey:key];
    if ((value != nil) || [value isKindOfClass:[NSString class]]) {
        resutl = value;
    }
    
    return resutl;
}

+ (NSDictionary *)optDictionary:(NSDictionary *)dict objectForKey:(NSString *)key {
    NSString *resutl = @{};
    
    if ([self objIsNull:dict] || ![dict isKindOfClass:[NSDictionary class]]) {
        NSLog(@"字典非法");
    }
    
    if ([self objIsNull:key] || ![key isKindOfClass:[NSString class]]) {
        NSLog(@"（字典）key非法");
    }
    
    NSDictionary *value = [dict objectForKey:key];
    if ((value != nil) || [value isKindOfClass:[NSDictionary class]]) {
        resutl = value;
    }
    
    return resutl;
}


@end
