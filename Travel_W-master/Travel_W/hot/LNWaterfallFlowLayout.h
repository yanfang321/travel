//
//  LNWaterfallFlowLayout.h
//  Travel_W
//
//  Created by 王萌 on 15/9/20.
//  Copyright (c) 2015年 WM. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LNWaterfallFlowLayout : UICollectionViewFlowLayout
// 总列数
@property (nonatomic, assign) NSInteger columnCount;
// 商品数据数组
@property (nonatomic, strong) NSArray *goodsList;
@end