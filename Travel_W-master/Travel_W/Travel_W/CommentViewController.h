//
//  CommentViewController.h
//  Travel_W
//
//  Created by 王萌 on 15/10/12.
//  Copyright (c) 2015年 WM. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CommentViewController : UIViewController
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong,nonatomic)NSArray *collectionArray;
@end
