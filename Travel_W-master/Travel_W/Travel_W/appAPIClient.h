//
//  appAPIClient.h
//  Zhong Rui
//
//  Created by Ziyao Yang on 8/5/15.
//  Copyright (c) 2015 Ziyao Yang. All rights reserved.
//

#import "AFNetworking.h"

@interface appAPIClient : AFHTTPRequestOperationManager//类似于NSURLSession，打包好配置并预处理好异常的NSURLSession

+ (instancetype)sharedClient;
+ (instancetype)sharedResponseDataClient;
+ (instancetype)sharedJSONClient;

@end