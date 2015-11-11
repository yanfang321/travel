//
//  HomeViewController.h
//  Travel_W
//
//  Created by 王萌 on 15/9/20.
//  Copyright (c) 2015年 WM. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HomeViewController : UIViewController
{
    BOOL loadingMore;
    NSInteger loadCount;
    NSInteger perPage;
    NSInteger totalPage;
}
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIPageControl *pageControl;
@property (strong,nonatomic) NSMutableArray * slideImages;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong,nonatomic)NSMutableArray *objectsForShow;
@property (strong, nonatomic) UIActivityIndicatorView *aiv;
@property (strong, nonatomic) UIImageView *zoomedIV;
@property(nonatomic,strong) PFObject *Attractions;
@property (strong, nonatomic) UIActivityIndicatorView *tableFooterAI;
@end
