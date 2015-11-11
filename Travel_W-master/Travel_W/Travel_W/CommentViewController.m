
//
//  CommentViewController.m
//  Travel_W
//
//  Created by 王萌 on 15/10/12.
//  Copyright (c) 2015年 WM. All rights reserved.
//

#import "CommentViewController.h"
#import "CommentTableViewCell.h"
@interface CommentViewController ()

@end

@implementation CommentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //去掉tableView多余的下划线
    _tableView.tableFooterView=[[UIView alloc]init];
    [self requestData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
//取消点击cell行
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [_collectionArray count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    CommentTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    //获得数据
    PFObject *object = [_collectionArray objectAtIndex:indexPath.row];
    PFObject *activity = object[@"target"];

    cell.titleName.text = activity[@"Name"];
    cell.comment.text = object[@"comment"];
    cell.time.text = object.createdAt.debugDescription;
    //******转换时间格式******
    NSDateFormatter* dateFormat = [[NSDateFormatter alloc] init];//实例化一个NSDateFormatter对象
    [dateFormat setDateFormat:@"yyyy-MM-dd"];//设定时间格式
    NSString *dateString = [dateFormat stringFromDate:object.createdAt] ; //求出当天的时间字符串，当更改时间格式时，时间字符串也能随之改变
    cell.time.text = dateString;
    //******转换时间格式******
    
    return cell;
}
/****根据内容更改行高****/
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
        CommentTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
        PFObject *object = [_collectionArray objectAtIndex:indexPath.row];
        CGSize maxSize = CGSizeMake(UI_SCREEN_W - 16, 1000);
        CGSize contentLabelSize = [object[@"comment"] boundingRectWithSize:maxSize options:NSStringDrawingTruncatesLastVisibleLine|NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:13]} context:nil].size;
        return cell.comment.frame.origin.y + contentLabelSize.height + 36;
}
//通知 到parse读取数据
- (void)requestData {
    PFUser *current=[PFUser currentUser];
      NSPredicate *predicate3 = [NSPredicate predicateWithFormat:@" publisher== %@ ",current];
    //查询Attractions表中当前用户所有字段
    PFQuery *query = [PFQuery queryWithClassName:@"Comments" predicate:predicate3];
    [query includeKey:@"target"];
//    [query includeKey:@"publisher"];
    
    //菊花 指示器
    UIActivityIndicatorView *aiv = [Utilities getCoverOnView:self.view];
    [query findObjectsInBackgroundWithBlock:^(NSArray *returnedObjects, NSError *error) {
        [aiv stopAnimating];//停止动画
        if (!error) {
            _collectionArray = returnedObjects;
            NSLog(@"%@", _collectionArray);
            [_tableView reloadData];
        } else {
            NSLog(@"Error: %@ %@", error, [error userInfo]);
        }
    }];
}



@end
