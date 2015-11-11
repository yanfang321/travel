//
//  SearchViewController.m
//  Travel_W
//
//  Created by 王萌 on 15/9/23.
//  Copyright (c) 2015年 WM. All rights reserved.
//

#import "SearchViewController.h"
@interface SearchViewController ()<UITableViewDataSource,UITableViewDelegate,UISearchBarDelegate>
@property(nonatomic,strong) UISearchBar* searchBar;
@property(nonatomic,strong)NSMutableArray* searchResult;
@end

@implementation SearchViewController

- (void)viewDidLoad {
    self.view.backgroundColor=[UIColor whiteColor];
    [super viewDidLoad];
    [self creatSearchBar];
    [self.searchBar becomeFirstResponder];
    [self createHistroyData];
    [self createTableView];
    
}
//创建搜索栏
-(void)creatSearchBar
{
    UISearchBar *searchBar=[[UISearchBar alloc]initWithFrame:CGRectMake(0, 20, self.navigationController.navigationBar.bounds.size.width, self.navigationController.navigationBar.bounds.size.height)];
    UINavigationItem *item=self.navigationItem;
    item.hidesBackButton=YES;
    item.titleView=searchBar;
    [searchBar setShowsCancelButton:YES];
    self.searchBar=searchBar;
    self.searchBar.delegate=self;
    [self.searchBar becomeFirstResponder];
}
-(void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    [searchBar resignFirstResponder];
    [self.navigationController popToRootViewControllerAnimated:YES];
}
//创建tableview
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.searchResult.count+1;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *cellID=@"cellID";
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:cellID];
    if(cell==nil)
    {
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    if(indexPath.row==0)
        cell.textLabel.text=@"历史搜索";
    else
        
        cell.textLabel.text=self.searchResult[indexPath.row-1];
    return cell;
}
//创建tableview的数据
-(void)createTableView
{
    CGFloat heigh=self.view.bounds.size.height;
    CGRect rect=CGRectMake(0, 0, self.view.bounds.size.width,heigh-64);
    _table=[[UITableView alloc]initWithFrame:rect style:UITableViewStylePlain];
    _table.dataSource=self;
    _table.delegate=self;
    [self.view addSubview:_table];
}
//创建历史数据
-(void)createHistroyData
{
    NSString *home=NSHomeDirectory();
    NSLog(@"%@",home);
    NSUserDefaults *df=[NSUserDefaults standardUserDefaults];
    NSMutableArray *arrayData=[df objectForKey:@"历史搜索"];
    self.searchResult=[NSMutableArray arrayWithArray:arrayData];
    for(NSString *str in self.searchResult)
        NSLog(@"%@",str);
    NSLog(@"111111");
}
//当点击search时搜索的记录会被写进plist文件中
-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    //NSLog(@"%ld",self.searchResult.count);
    int i;
    for( i=0;i<self.searchResult.count;i++)
    {
        //NSLog(@"%@",self.searchResult[i]);
        if([self.searchBar.text isEqualToString: self.searchResult[i]])
        {
            break;
        }
    }
    if(i==self.searchResult.count)
    {
        [self.searchResult insertObject:self.searchBar.text atIndex:0];
    }
    NSMutableArray *tempArray=self.searchResult;
    NSUserDefaults *df=[NSUserDefaults standardUserDefaults];
    [df setObject:tempArray forKey:@"历史搜索" ];
    
    NSLog(@"searchBar = %@", searchBar.text);
    PFQuery *query = [PFQuery queryWithClassName:@"Attractions"];
    [query whereKey:@"Name" containsString:searchBar.text];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            NSLog(@"objects = %@", objects);
            [self.searchResult removeAllObjects];
            for (PFObject *obj in objects) {
                [self.searchResult addObject:obj[@"Name"]];
            }
            [_table reloadData];
        }
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
