//
//  Utilities.m
//  Utility
//
//  Created by ZIYAO YANG on 15/8/20.
//  Copyright (c) 2015年 Zhong Rui. All rights reserved.
//

#import "Utilities.h"

@implementation Utilities
//获得UserDefaults
+ (id)getUserDefaults:(NSString *)key
{
    return [[NSUserDefaults standardUserDefaults] objectForKey:key];
}
//设置UserDefaults
+ (void)setUserDefaults:(NSString *)key content:(id)value
{
    [[NSUserDefaults standardUserDefaults] setObject:value forKey:key];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
//移动UserDefaults
+ (void)removeUserDefaults:(NSString *)key
{
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:key];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
//通过这个方法输入storyboard的名字就可以连接了
+ (id)getStoryboardInstanceByIdentity:(NSString*)identity
{
    UIStoryboard* storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    return [storyboard instantiateViewControllerWithIdentifier:identity];
}
//弹出警告框
+ (void)popUpAlertViewWithMsg:(NSString *)msg andTitle:(NSString* )title
{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:title == nil ? @"提示" : title
                                                        message:msg == nil ? @"操作失败" : msg
                                                       delegate:self
                                              cancelButtonTitle:@"确认"
                                              otherButtonTitles:nil];
    [alertView show];
}
//在某一个视图上加一个覆盖物(获得保护膜)
+ (UIActivityIndicatorView *)getCoverOnView:(UIView *)view {
    UIActivityIndicatorView *aiv = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    aiv.backgroundColor = [[UIColor darkGrayColor] colorWithAlphaComponent:0.4];
    aiv.frame = view.bounds;
    [view addSubview:aiv];
    [aiv startAnimating];
    return aiv;
}

//将浮点数转换为保留小数点后若干位的字符串
+ (NSString *)notRounding:(float)price afterPoint:(int)position
{
    NSDecimalNumberHandler* roundingBehavior = [NSDecimalNumberHandler decimalNumberHandlerWithRoundingMode:NSRoundPlain scale:position raiseOnExactness:NO raiseOnOverflow:NO raiseOnUnderflow:NO raiseOnDivideByZero:NO];
    NSDecimalNumber *ouncesDecimal;
    NSDecimalNumber *roundedOunces;
    
    ouncesDecimal = [[NSDecimalNumber alloc] initWithFloat:price];
    roundedOunces = [ouncesDecimal decimalNumberByRoundingAccordingToBehavior:roundingBehavior];
    return [NSString stringWithFormat:@"%@",roundedOunces];
}
//根据url下载图片并缓存
+ (UIImage *)imageUrl:(NSString *)url {
    //if (nil == url || url.length == 0) {
    if ([url isKindOfClass:[NSNull class]] || url == nil) {
        return nil;//判断url的链接是不是空，nil是没有，但是是个字符，null是没有，什么也没。
    }
    static dispatch_queue_t backgroundQueue;
    if (backgroundQueue == nil) {
        backgroundQueue = dispatch_queue_create("com.beilyton.queue", NULL);
    }
    //去硬盘里看看图片是否存好
    NSArray *directories = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);//所有文件路径的集合
    NSString *documentDirectory = [directories objectAtIndex:0];//获得根目录的字符串
    __block NSString *filePath = nil;
    filePath = [documentDirectory stringByAppendingPathComponent:[url lastPathComponent]];//在根目录上附加url
    UIImage *imageInFile = [UIImage imageWithContentsOfFile:filePath];//通过路径去拿一张图片
    if (imageInFile) {
        return imageInFile;
    }
    
    __block NSData * data = [NSData dataWithContentsOfURL:[NSURL URLWithString:url]];//把url转化为数据流
    if (!data) {//如果数据不存在，则下载失败
        NSLog(@"Error retrieving %@", url);
        return nil;//不返回任何值
    }
    UIImage *imageDownloaded = [[UIImage alloc] initWithData:data];//初始化一段数据流
    dispatch_async(backgroundQueue, ^(void) {//异步写入
        [data writeToFile:filePath atomically:YES];
        NSLog(@"Wrote to: %@", filePath);
    });
    return imageDownloaded;
}

@end
