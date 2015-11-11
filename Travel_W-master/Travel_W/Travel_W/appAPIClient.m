//
//  appAPIClient.m
//  Zhong Rui
//
//  Created by Ziyao Yang on 8/5/15.
//  Copyright (c) 2015 Ziyao Yang. All rights reserved.
//

#import "appAPIClient.h"

@implementation appAPIClient

+ (instancetype)sharedClient//自己公司的接口组
{
    static appAPIClient *_sharedClient = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedClient = [[appAPIClient alloc] initWithBaseURL:nil];
        _sharedClient.requestSerializer = [AFHTTPRequestSerializer serializer];
    });
    return _sharedClient;
}

+ (instancetype)sharedResponseDataClient//所有微信API要用到请求
{
    static appAPIClient *_sharedClient = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedClient = [[appAPIClient alloc] initWithBaseURL:nil];
        _sharedClient.requestSerializer = [AFHTTPRequestSerializer serializer];
        _sharedClient.responseSerializer = [AFHTTPResponseSerializer serializer];
    });
    return _sharedClient;
}


+ (instancetype)sharedJSONClient//纯JSON的玩家
{
    static appAPIClient *_sharedClient = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedClient = [[appAPIClient alloc] initWithBaseURL:nil];
        _sharedClient.requestSerializer     = [AFJSONRequestSerializer serializer];
        _sharedClient.responseSerializer    = [AFJSONResponseSerializer serializer];
        NSMutableSet* set = [NSMutableSet set];
        [set addObjectsFromArray:[_sharedClient.responseSerializer.acceptableContentTypes allObjects]];
        [set addObject:@"text/plain"];
        [_sharedClient.responseSerializer setAcceptableContentTypes:[set copy]];
    });
    return _sharedClient;
}

@end
