//
//  HotViewController.h
//  Travel_W
//
//  Created by 王萌 on 15/9/20.
//  Copyright (c) 2015年 WM. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HotViewController : UIViewController
<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>
@property(strong,nonatomic)UIImageView *zoomedIV;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@end
