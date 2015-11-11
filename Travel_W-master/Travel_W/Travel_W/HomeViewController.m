//
//  HomeViewController.m
//  Travel_W
//
//  Created by 王萌 on 15/9/20.
//  Copyright (c) 2015年 WM. All rights reserved.
//

#import "HomeViewController.h"
#import "DetailViewController.h"
#import "HomeTableViewCell.h"
#import "SearchViewController.h"
@interface HomeViewController ()<UISearchBarDelegate>
@end

@implementation HomeViewController
@synthesize slideImages;
//创建导航栏，导航栏上有搜索栏按钮，点击进入下一个页面
-(void)createSearchBar
{
    UINavigationBar *bar=self.navigationController.navigationBar;
    bar.barTintColor=[UIColor colorWithRed:0 green:0.7 blue:0.9 alpha:1];//设置导航栏的颜色
    bar.barStyle=UIBarStyleBlackTranslucent;
    
    UINavigationItem *item=self.navigationItem;
    UISearchBar *search=[[UISearchBar alloc]initWithFrame:CGRectMake(0, 0,SEARCHBARWIDTH,NAVBARHIGHT)];
    search.delegate=self;
    // search.barTintColor=[UIColor yellowColor];
    item.titleView=search;
    search.placeholder=@"／旅行地／景点";
    self.navigationController.navigationBar.translucent=NO;
    self.tabBarController.tabBar.hidden=NO;
    item.backBarButtonItem=[[UIBarButtonItem alloc]initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
}
- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar
{
    SearchViewController *searchView=[[SearchViewController alloc]init];
    NSLog(@"start");
    searchView.hidesBottomBarWhenPushed=YES;
    [self.navigationController pushViewController:searchView animated:YES];
    return NO;
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    [self.tabBarController.tabBar setHidden:NO];
    self.navigationController.navigationBar.translucent=NO;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    //导航栏
    [self createSearchBar];
    //界面操作
    [self uiConfiguration];
    //到parse读取数据
    [self requestData];
    //去掉tableView多余的下划线
    _tableView.tableFooterView=[[UIView alloc]init];
    [self.navigationController.navigationBar setTranslucent:NO];
    // 定时器 循环
    [NSTimer scheduledTimerWithTimeInterval:1.5 target:self selector:@selector(runTimePage) userInfo:nil repeats:YES];
    _scrollView.bounces = YES;
    _scrollView.pagingEnabled = YES;
    _scrollView.userInteractionEnabled = YES;
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.alwaysBounceHorizontal = YES;
    // 初始化 数组 并添加六张图片
    slideImages = [[NSMutableArray alloc]initWithObjects:@"hd_001.jpg",@"hd_002.jpg",@"hd_003.jpg",@"hd_004.jpg",@"hd_005.jpg",@"hd_006.jpg", nil];
    _pageControl.numberOfPages = [self.slideImages count];
    _pageControl.currentPage = 0;
    [_pageControl addTarget:self action:@selector(turnPage) forControlEvents:UIControlEventValueChanged]; // 触摸mypagecontrol触发change这个方法事件
    
    //创建6个图片
    for (int i = 0;i<[slideImages count];i++)
    {
        UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:[slideImages objectAtIndex:i]]];
        imageView.clipsToBounds = YES;
        imageView.frame = CGRectMake((UI_SCREEN_W * i) + UI_SCREEN_W, 0,UI_SCREEN_W, 150);
        [_scrollView addSubview:imageView]; // 首页是第0页,默认从第1页开始的。所以+UI_SCREEN_W。。。
    }
    // 取数组最后一张图片 放在第0页
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:[slideImages objectAtIndex:([slideImages count]-1)]]];
    imageView.frame = CGRectMake(0, 0, UI_SCREEN_W,150); // 添加最后1页在首页 循环
    [_scrollView addSubview:imageView];
    // 取数组第一张图片 放在最后1页
    imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:[slideImages objectAtIndex:0]]];
    imageView.frame = CGRectMake((UI_SCREEN_W * ([slideImages count] + 1)) , 0,UI_SCREEN_W, 150); // 添加第1页在最后 循环
    [_scrollView addSubview:imageView];
    
    [_scrollView setContentSize:CGSizeMake(UI_SCREEN_W * ([slideImages count] + 2), 150)];
    [_scrollView setContentOffset:CGPointMake(0, 0)];
}
// scrollview 委托函数
- (void)scrollViewDidScroll:(UIScrollView *)sender
{
    CGFloat pagewidth = self.scrollView.frame.size.width;
    int page = floor((self.scrollView.contentOffset.x - pagewidth/([slideImages count]+2))/pagewidth)+1;
    page --;  // 默认从第二页开始
    _pageControl.currentPage = page;
}
// scrollview 委托函数
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    CGFloat pagewidth = self.scrollView.frame.size.width;
    int currentPage = floor((self.scrollView.contentOffset.x - pagewidth/ ([slideImages count]+2)) / pagewidth) + 1;
    if (currentPage==0)
    {
        [self.scrollView scrollRectToVisible:CGRectMake(UI_SCREEN_W * [slideImages count],0,[UIScreen mainScreen].bounds.size.width,[UIScreen mainScreen].bounds.size.height) animated:NO]; // 序号0 最后1页
    }
    else if (currentPage==([slideImages count]+1))
    {
        [self.scrollView scrollRectToVisible:CGRectMake(UI_SCREEN_W,0,[UIScreen mainScreen].bounds.size.width,[UIScreen mainScreen].bounds.size.height) animated:NO]; // 最后+1,循环第1页
    }
}
// pagecontrol 选择器的方法
- (void)turnPage
{
    long page = _pageControl.currentPage; // 获取当前的page
    [self.scrollView scrollRectToVisible:CGRectMake(UI_SCREEN_W*(page+1),0,[UIScreen mainScreen].bounds.size.width,[UIScreen mainScreen].bounds.size.height) animated:NO]; // 触摸pagecontroller那个点点 往后翻一页 +1
}
// 定时器 绑定的方法
- (void)runTimePage
{
    long page = _pageControl.currentPage; // 获取当前的page
    page++;
    page = page >=6 ? 0 : page ;
    _pageControl.currentPage = page;
    [self turnPage];
}

//***下拉刷新***
-(void)uiConfiguration
{
    //在可以滚动的控件里执行刷新的控件
    UIRefreshControl *refreshControl = [[UIRefreshControl alloc] init];
    NSString *title = [NSString stringWithFormat:@"下拉即可刷新"];
    NSMutableParagraphStyle *style = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
    [style setAlignment:NSTextAlignmentCenter];
    [style setLineBreakMode:NSLineBreakByWordWrapping];
    
    //设置的属性字典
    NSDictionary *attrsDictionary = @{NSUnderlineStyleAttributeName:
                                          @(NSUnderlineStyleNone),
                                      NSFontAttributeName:[UIFont preferredFontForTextStyle:UIFontTextStyleBody],
                                      NSParagraphStyleAttributeName:style,
                                      NSForegroundColorAttributeName:[UIColor brownColor]};
    
    
    NSAttributedString *attributedTitle = [[NSAttributedString alloc] initWithString:title attributes:attrsDictionary];
    refreshControl.attributedTitle = attributedTitle;
    //tintColor旋转的小花的颜色
    refreshControl.tintColor = [UIColor brownColor];
    //背景色 浅灰色
    refreshControl.backgroundColor = [UIColor groupTableViewBackgroundColor];
    //执行的动作
    [refreshControl addTarget:self action:@selector(refreshData:) forControlEvents:UIControlEventValueChanged];
    [self.tableView addSubview:refreshControl];
    [_tableView reloadData];
}

//下拉刷新执行的方法
- (void)refreshData:(UIRefreshControl *)rc
{
    [self requestData];
    //怎么样让方法延迟执行的
    [self performSelector:@selector(endRefreshing:) withObject:rc afterDelay:1.f];
}

- (void)endRefreshing:(UIRefreshControl *)rc {
    [rc endRefreshing];//闭合
}
//***下拉刷新***
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

//返回tableview的行数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _objectsForShow.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    HomeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];//复用Cell
    //获得数据
    PFObject *object = [_objectsForShow objectAtIndex:indexPath.row];
    //得到名字
    NSLog(@"%@", object[@"Name"]);
    cell.nameLabel.text = object[@"Name"];
    cell.priceLabel.text =object[@"Pirce"];
    cell.citynameLabel.text =object[@"City"];
    cell.addressLabel.text =object[@"DetailAddress"];
    //获取数据库的图片（下载）
    //创建item
    PFFile *item = object[@"Photo"];
    [item getDataInBackgroundWithBlock:^(NSData *photoData, NSError *error) {
        if (!error) {
            UIImage *image = [UIImage imageWithData:photoData];
            dispatch_async(dispatch_get_main_queue(), ^{
                cell.photoIV.image = image;
            });
        }
    }];
    
    return cell;
}
//通知 到parse读取数据
- (void)requestData {
    _aiv = [Utilities getCoverOnView:self.view];
    [self initializeData];
}
//下拉刷新：刷新器+初始数据（第一页数据）
- (void) initializeData
{
    loadCount = 1;//页码为1，从第一页开始
    perPage = 4;//每页显示4个数据
    loadingMore = NO;
    [self urlAction];
}
- (void) urlAction
{
    PFQuery *query = [PFQuery queryWithClassName:@"Attractions"];
    //[query includeKey:@"owner"];//关联查询
    [query orderByDescending:@"Pirce"];//降序排序
    //  [query orderByDescending:@"createdAt"];
    [query setLimit:perPage];//限定每页显示多少行
    [query setSkip:(perPage * (loadCount - 1))];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error){
        [_aiv stopAnimating];
        if (!error) {
            //NSLog(@"objects = %@", objects);
            if (objects.count == 0) {
                NSLog(@"NO");
                loadCount --;
                [self performSelector:@selector(beforeLoadEnd) withObject:nil afterDelay:0.25];//过0.25秒执行终止操作
            } else {
                if (loadCount == 1) {
                    _objectsForShow = nil;
                    _objectsForShow = [NSMutableArray new];//上拉翻页，新的数据续在第一页的数据之下。若下拉刷新，清空第一二页的内容，然后重新载入第一页的内容
                }
                for (PFObject *obj in objects) {
                    [_objectsForShow addObject:obj];
                }
                NSLog(@"_objectsForShow = %@", _objectsForShow);
                [_tableView reloadData];
                [self loadDataEnd];
            }
        } else {
            [self loadDataEnd];
            NSLog(@"%@", [error description]);
        }
    }];
}
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    if (scrollView.contentSize.height > scrollView.frame.size.height) {
        if (!loadingMore && scrollView.contentOffset.y > (scrollView.contentSize.height - scrollView.frame.size.height))/**当scrollView的y轴显示位置高度内容大于scrollView的显示高度-scrollView的本身高度**/ {
            [self loadDataBegin];
        }
    } else {
        if (!loadingMore && scrollView.contentOffset.y > 0)/**内容高度大于scrollView本身的高度，执行刷新**/ {
            [self loadDataBegin];
        }
    }
}

- (void)loadDataBegin {
    //这个方法是让上拉时，正在加载时再次上拉时阻断
    if (loadingMore == NO) /**没有在加载**/{
        loadingMore = YES;
        [self createTableFooter];
        _tableFooterAI = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake((UI_SCREEN_W - 86.0f) / 2 - 30.0f, 10.0f, 20.0f, 20.0f)];//创建一个菊花
        [_tableFooterAI setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleGray];
        [self.tableView.tableFooterView addSubview:_tableFooterAI];
        [_tableFooterAI startAnimating];
        [self loadDataing];
    }
}

- (void)loadDataing {
    loadCount ++;
    [self urlAction];
}

- (void)beforeLoadEnd {
    UILabel *label = (UILabel *)[self.tableView.tableFooterView viewWithTag:9001];
    [label setText:@"当前已无更多数据"];
    [_tableFooterAI stopAnimating];
    _tableFooterAI = nil;
    [self performSelector:@selector(loadDataEnd) withObject:nil afterDelay:0.25];//再过0.25秒执行loadDataEnd
}

- (void)loadDataEnd {
    self.tableView.tableFooterView = [[UIView alloc] init];
    loadingMore = NO;
    
}

- (void)createTableFooter {
    UIView *tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, self.tableView.bounds.size.width, 40.0f)];
    UILabel *loadMoreText = [[UILabel alloc] initWithFrame:CGRectMake((UI_SCREEN_W - 86.0f) / 2, 0.0f, 116.0f, 40.0f)];//UI_SCREEN_W 是屏幕的宽度  上拉刷新的Label  让文字和菊花都在正中间
    loadMoreText.tag = 9001;//这个Label的标签是9001
    [loadMoreText setFont:[UIFont systemFontOfSize:B_Font]];
    [loadMoreText setText:@"上拉显示更多数据"];
    loadMoreText.textColor = [UIColor grayColor];
    [tableFooterView addSubview:loadMoreText];
    self.tableView.tableFooterView = tableFooterView;
}


//取消选择tableView
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

//跳转下一页面，切换的按钮会隐藏掉
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {

    if ([segue.identifier isEqualToString:@"det"]) {
        PFObject *object = [_objectsForShow objectAtIndex:[_tableView indexPathForSelectedRow].row];//获得当前tablview选中行的数据
        DetailViewController *miVC = segue.destinationViewController;//目的地视图控制器
        miVC.Attractions = object;
        miVC.hidesBottomBarWhenPushed = YES;//把切换按钮隐藏掉
    }
    
}

@end
