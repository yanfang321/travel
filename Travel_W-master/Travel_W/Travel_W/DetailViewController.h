//
//  DetailViewController.h
//  Travel_W
//
//  Created by 王萌 on 15/9/23.
//  Copyright (c) 2015年 WM. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DetailViewController : UIViewController {
    CGRect frame;
}
@property (weak, nonatomic) IBOutlet UIButton *saveButton;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *shoucangItem;
@property (weak, nonatomic) IBOutlet UIImageView *imgview;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;
@property (weak, nonatomic) IBOutlet UISegmentedControl *seg;
@property (weak, nonatomic) IBOutlet UITextField *t1;
@property (strong,nonatomic) NSMutableArray *objectsForShow;
@property (strong,nonatomic) NSMutableArray *objectsForShow2;
@property(nonatomic,strong) PFObject *Comments;
@property(nonatomic,strong) PFObject *Attractions;
@property (strong, nonatomic) PFObject *item;
@end
