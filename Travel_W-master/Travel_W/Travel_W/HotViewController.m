//
//  HotViewController.m
//  Travel_W
//
//  Created by 王萌 on 15/9/20.
//  Copyright (c) 2015年 WM. All rights reserved.
//

#import "HotViewController.h"
#import "LNGood.h"
#import "LNWaterfallFlowCell.h"
#import "LNWaterfallFlowLayout.h"
#import "LNWaterfallFlowFooterView.h"
#import "RegionViewController.h"
@interface HotViewController ()<MJRefreshBaseViewDelegate>
{
    int page;
    BOOL isRegion;
    NSString* resgion_id;
    NSString* pid;
}
@property(nonatomic,strong) UIButton* resgion_btn;
@property(nonatomic,strong) NSMutableArray* dataArray;

// 热图列表数组
@property (nonatomic, strong) NSMutableArray *goodsList;
//当前的数据索引
@property (nonatomic, assign) NSInteger index;
// 瀑布流布局
@property (weak, nonatomic) IBOutlet LNWaterfallFlowLayout *waterfallFlowLayout;
// 底部视图
@property (nonatomic, weak) LNWaterfallFlowFooterView *footerView;
// 是否正在加载数据标记
@property (nonatomic, assign, getter=isLoading) BOOL loading;
@end

@implementation HotViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadData];
    UINavigationBar *bar=self.navigationController.navigationBar;
    bar.barTintColor=[UIColor colorWithRed:0 green:0.7 blue:0.9 alpha:1];//设置导航栏的颜色
    bar.barStyle=UIBarStyleBlackTranslucent;
    
    [self createNav];
    _dataArray=[NSMutableArray array];
    self.view.backgroundColor=[UIColor whiteColor];
    resgion_id=@"321";
    isRegion=NO;
}
//创造导航栏
-(void)createNav
{
    UIButton *btn=[UIButton buttonWithType:UIButtonTypeSystem];
    [btn setTitle:@"全国" forState:UIControlStateNormal];
    btn.frame=CGRectMake(0, 15,35, 30);
    btn.tag=20;
    self.resgion_btn=btn;
    UIImageView *view=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 30, 30)];
    view.image=[UIImage imageNamed:@"zuobiao"];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    btn.titleLabel.font=[UIFont systemFontOfSize:12];
    [btn addTarget:self action:@selector(resigonclick:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *item=[[UIBarButtonItem alloc]initWithCustomView:btn];
    UIBarButtonItem *item1=[[UIBarButtonItem alloc]initWithCustomView:view];
    self.navigationItem.rightBarButtonItems=@[item,item1];
}
#pragma mark-跳转到地区界面
-(void)resigonclick:(UIButton *)btn
{
    RegionViewController *region=[[RegionViewController alloc]init];
    region.tabBarController.hidesBottomBarWhenPushed=YES;
    region.block=^(NSString *rid,NSString *name)
    {
        isRegion=YES;
        //[self loadDataWithRegion:rid WithIsHead:NO WithPage:@"0"];
        page=0;
        resgion_id=rid;//获取地区
        [self.resgion_btn setTitle:name forState:UIControlStateNormal];
    };
    [self.navigationController pushViewController:region animated:YES]
    ;
}
//******图片点击放大******
-(void)photoTapAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"Tap");
    LNGood *object = [_goodsList objectAtIndex:indexPath.row];
    _zoomedIV = [[UIImageView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    _zoomedIV.userInteractionEnabled = YES;//让用户可以点击图片
    NSLog(@"%@", object.img);
    _zoomedIV.image = [Utilities imageUrl:object.img];
    
    _zoomedIV.contentMode = UIViewContentModeScaleAspectFit;//最长边到屏幕的长或宽任何一边，停止放大
    _zoomedIV.backgroundColor = [UIColor blackColor];
    UITapGestureRecognizer *ivTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(ivTap:)];
    [_zoomedIV addGestureRecognizer:ivTap];
    [[[UIApplication sharedApplication] keyWindow] addSubview:_zoomedIV];
    
}
-(void)ivTap:(UITapGestureRecognizer *)tap
{
    if (tap.state==UIGestureRecognizerStateRecognized) {
        [_zoomedIV removeFromSuperview];//把zoomedIV从超视图移出
        _zoomedIV=nil;//设为空
    }
}
//******图片点击放大******

/**
 *  加载数据
 */
- (void)loadData {
    NSArray *goods = [LNGood goodsWithIndex:self.index];
    [self.goodsList addObjectsFromArray:goods];
    self.index++;
    // 设置布局的属性
    self.waterfallFlowLayout.columnCount = 2;
    self.waterfallFlowLayout.goodsList = self.goodsList;
    // 刷新数据
    [self.collectionView reloadData];
    self.footerView = nil;
}

#pragma mark - 数据源方法
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    [self photoTapAtIndexPath:indexPath];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.goodsList.count;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    // 创建可重用的cell
    LNWaterfallFlowCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"CellCache"
                                 forIndexPath:indexPath];
    cell.good = self.goodsList[indexPath.item];
    return cell;
}

#pragma mark - FooterView
/**
 *  追加视图
 */
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    if (kind == UICollectionElementKindSectionFooter) {
        self.footerView = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"FooterViewCache" forIndexPath:indexPath];
        return self.footerView;
    }
    return nil;
}

#pragma mark - scrollView代理方法
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    if (self.footerView == nil || self.isLoading) {
        return;
    }
    if (self.footerView.frame.origin.y < (scrollView.contentOffset.y + scrollView.bounds.size.height)) {
        NSLog(@"开始刷新");
        // 如果正在刷新数据，不需要再次刷新
        self.loading = YES;
        [self.footerView.indicator startAnimating];
        // 模拟数据刷新
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self loadData];
            self.loading = NO;
        });
    }
}
//- (BOOL)prefersStatusBarHidden {
//    return YES;
//}

- (NSMutableArray *)goodsList {
    if (_goodsList == nil) {
        _goodsList = [NSMutableArray array];
    }
    return _goodsList;
}
@end
