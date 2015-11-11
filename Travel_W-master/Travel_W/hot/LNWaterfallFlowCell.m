//
//  LNWaterfallFlowCell.m
//  Travel_W
//
//  Created by 王萌 on 15/9/20.
//  Copyright (c) 2015年 WM. All rights reserved.
//

#import "LNWaterfallFlowCell.h"
#import "LNGood.h"
#import "UIImageView+WebCache.h"

@interface LNWaterfallFlowCell ()
@property (weak, nonatomic) IBOutlet UIImageView *iconView;
@property (weak, nonatomic) IBOutlet UILabel *priceView;

@end

@implementation LNWaterfallFlowCell

- (void)setGood:(LNGood *)good {
    _good = good;
    NSURL *url = [NSURL URLWithString:good.img];
    [self.iconView sd_setImageWithURL:url];
    self.priceView.text = good.price;
}

@end
