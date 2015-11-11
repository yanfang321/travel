//
//  InformationTableViewCell.m
//  Travel_W
//
//  Created by 王萌 on 15/9/25.
//  Copyright (c) 2015年 WM. All rights reserved.
//

#import "InformationTableViewCell.h"

@implementation InformationTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    //[self textfile];
}
//-(void)textfile
//{
//    _detailTF.textColor=[UIColor blackColor];
//    //_detailTF.clearButtonMode=UITextFieldViewModeAlways;
//    _detailTF.clearsOnBeginEditing=YES;
//    _detailTF.adjustsFontSizeToFitWidth=YES;
//    _detailTF.backgroundColor=[UIColor clearColor];
//    _detailTF.borderStyle=UITextBorderStyleNone;
//}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    if (_editable) {
        
        _detailTF.enabled = YES;
    } else {
        
        _detailTF.enabled = NO;
    }
}
@end
