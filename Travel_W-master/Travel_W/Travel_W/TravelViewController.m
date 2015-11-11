//
//  TravelViewController.m
//  Travel_W
//
//  Created by 王萌 on 15/10/10.
//  Copyright (c) 2015年 WM. All rights reserved.
//

#import "TravelViewController.h"

@interface TravelViewController ()

@end

@implementation TravelViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _travel.multipleTouchEnabled = YES;//启用多个触摸
    _travel.userInteractionEnabled = YES;//交互
    /*载入网站首页*/
    [self.view insertSubview:_travel atIndex:0];
    NSURL *url = [NSURL URLWithString:@"http://you.ctrip.com/place/"];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [_travel loadRequest:request];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma UIWebViewDelegate  协议
-(void)webViewDidStartLoad:(UIWebView *)webView// 整体的一个controller类方法, 加载一个菊花图标，当正在访问的时候，一直转//5
{
    [[UIApplication sharedApplication]
     setNetworkActivityIndicatorVisible:YES];
}
-(void)webViewDidFinishLoad:(UIWebView *)webView// 访问完成，停止加载时，就不再转
{
    [[UIApplication sharedApplication ]setNetworkActivityIndicatorVisible:NO];
    
}

@end
