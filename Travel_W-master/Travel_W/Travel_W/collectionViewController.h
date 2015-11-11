//
//  collectionViewController.h
//  Travel_W
//
//  Created by 王萌 on 15/9/23.
//  Copyright (c) 2015年 WM. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface collectionViewController : UIViewController
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property(strong,nonatomic)NSArray *collectionArray;
@property(nonatomic,strong) PFObject *Attractions;
@end
