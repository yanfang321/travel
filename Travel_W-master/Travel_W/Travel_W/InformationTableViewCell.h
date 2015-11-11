//
//  InformationTableViewCell.h
//  Travel_W
//
//  Created by 王萌 on 15/9/25.
//  Copyright (c) 2015年 WM. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface InformationTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UITextField *detailTF;
@property (nonatomic) BOOL editable;



@end
