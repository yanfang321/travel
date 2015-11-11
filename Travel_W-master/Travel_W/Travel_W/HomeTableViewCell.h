//
//  HomeTableViewCell.h
//  Travel_W
//
//  Created by 王萌 on 15/9/23.
//  Copyright (c) 2015年 WM. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HomeViewController.h"
@interface HomeTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *photoIV;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UILabel *citynameLabel;
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;
@end
