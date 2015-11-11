//
//  RegionViewController.h
//  Travel_W
//
//  Created by 王萌 on 15/9/20.
//  Copyright (c) 2015年 WM. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RegionViewController : UIViewController
@property(nonatomic,strong) NSMutableArray* parentArray;
@property(nonatomic,copy) void(^block)(NSString *,NSString *);

@end
