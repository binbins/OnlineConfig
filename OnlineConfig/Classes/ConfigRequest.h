//
//  ConfigRequest.h
//  Pods
//
//  Created by 张帆 on 17/3/13.
//
//
#define AppVerName [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"]
#define AppVerCode [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"]
#define AppBundleID [[NSBundle mainBundle] bundleIdentifier]
#define SysName [[[UIDevice currentDevice] systemName] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]
#define SysVersion [[[UIDevice currentDevice] systemVersion] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]
#define SysModel [[[UIDevice currentDevice] model] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]
#define CurrentLanguage [[NSLocale preferredLanguages] count] > 0 ? [[NSLocale preferredLanguages] objectAtIndex:0] : @""


#define AppAdRespInfoDict @{@"platform": @"ios", @"apppackagename" : AppBundleID, @"appversionname":AppVerName, @"appversioncode":AppVerCode, @"sys_name":SysName, @"sys_ver":SysVersion, @"sys_model":SysModel, @"sys_language":CurrentLanguage, @"package_name" : AppBundleID,}
#define USERDEFAULTS [NSUserDefaults standardUserDefaults]
#define LocalConfigKey @"AD_config_key"


#import <Foundation/Foundation.h>
@import AFNetworking;


@interface ConfigRequest : NSObject

+ (AFHTTPSessionManager *)afManager;

+ (NSDictionary *)localConfig;

#pragma mark - 从在线参数(params字典)中取值
+ (void)updateConfig:(NSString *)url;

+ (NSString *)stringForKey:(NSString *)key;

+ (NSDictionary *)dictionaryForKey:(NSString *)key;

+ (NSArray *)arrayForKey:(NSString *)key;

+ (float)floatForKey:(NSString *)key;

+ (BOOL)boolForKey:(NSString *)key;

+ (int)intForKey:(NSString *)key;





@end
