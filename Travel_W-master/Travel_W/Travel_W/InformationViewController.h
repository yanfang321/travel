//
//  InformationViewController.h
//  Travel_W
//
//  Created by 王萌 on 15/9/29.
//  Copyright (c) 2015年 WM. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface InformationViewController : UIViewController
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong,nonatomic) NSArray *array,*array1;
//@property (weak, nonatomic) IBOutlet UIButton *editor;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *editor;

@property (weak, nonatomic) IBOutlet UIButton *saveButton;
@property (strong, nonatomic) NSString *secondname;
@property (strong, nonatomic) NSString *signature;
@property (strong, nonatomic) NSString *email;
@property (strong, nonatomic) NSString *gender;
@property (strong, nonatomic) NSString *address;


@end
