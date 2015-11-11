//
//  LNGood.h
//  Travel_W
//
//  Created by 王萌 on 15/9/20.
//  Copyright (c) 2015年 WM. All rights reserved.
//

#import "LNGood.h"

@implementation LNGood

//字典转模型
+ (instancetype)goodWithDict:(NSDictionary *)dict {
    id good = [[self alloc] init];
    [good setValuesForKeysWithDictionary:dict];
    return good;
}

//根据索引返回数组
+ (NSArray *)goodsWithIndex:(NSInteger)index {
    
    NSString *fileName = [NSString stringWithFormat:@"%ld.plist", index % 2 + 1];
    NSString *path = [[NSBundle mainBundle] pathForResource:fileName ofType:nil];
    NSArray *goodsArray = [NSArray arrayWithContentsOfFile:path];
    NSMutableArray *tmpArray = [NSMutableArray arrayWithCapacity:goodsArray.count];
    
    [goodsArray enumerateObjectsUsingBlock: ^(NSDictionary *dict, NSUInteger idx, BOOL *stop) {
        [tmpArray addObject:[self goodWithDict:dict]];
    }];
    return tmpArray.copy;
}
@end
