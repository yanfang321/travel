//
//  LNGood.h
//  Travel_W
//
//  Created by 王萌 on 15/9/20.
//  Copyright (c) 2015年 WM. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LNGood : NSObject
@property (nonatomic, assign) NSInteger h;
@property (nonatomic, assign) NSInteger w;
@property (nonatomic, copy) NSString *img;
@property (nonatomic, copy) NSString *price; 

+ (instancetype)goodWithDict:(NSDictionary *)dict; // 字典转模型
+ (NSArray *)goodsWithIndex:(NSInteger)index; // 根据索引返回商品数组
@end
