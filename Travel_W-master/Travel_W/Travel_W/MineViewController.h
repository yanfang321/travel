//
//  MineViewController.h
//  Travel_W
//
//  Created by 王萌 on 15/9/20.
//  Copyright (c) 2015年 WM. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MineViewController : UIViewController<UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic,strong) NSMutableArray *imageArray,*array;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *buttonItem;
@property (weak, nonatomic) IBOutlet UIButton *backButton;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *Photo;
//调用
@property(strong,nonatomic)UIImagePickerController *imagePickerController;
@end
