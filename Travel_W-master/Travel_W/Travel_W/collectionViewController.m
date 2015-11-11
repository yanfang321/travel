//
//  collectionViewController.m
//  Travel_W
//
//  Created by 王萌 on 15/9/23.
//  Copyright (c) 2015年 WM. All rights reserved.
//

#import "collectionViewController.h"
#import "DetailViewController.h"
@interface collectionViewController ()

@end

@implementation collectionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self collectionData];
    //去掉tableView多余的下划线
    _tableView.tableFooterView=[[UIView alloc]init];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)collectionData
{
    PFUser *currentUser = [PFUser currentUser];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"shoucangUser == %@",currentUser];
    PFQuery *collection = [PFQuery queryWithClassName:@"collection" predicate:predicate];
    [collection includeKey:@"shoucangUser"];//关联查询
    [collection includeKey:@"shoucangAttractions"];//关联查询
    NSLog(@"collection == %@ ",collection);
    
    UIActivityIndicatorView *aiv = [Utilities getCoverOnView:self.view];
    [collection findObjectsInBackgroundWithBlock:^(NSArray *returnedObjects, NSError *error) {
        [aiv stopAnimating];
        if (!error) {
            _collectionArray = returnedObjects;
            NSLog(@"_collectionArray == %@", _collectionArray);
            
            [_tableView reloadData];
        } else {
            NSLog(@"Error: %@ %@", error, [error userInfo]);
        }
    }];
}
//取消点击cell行
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
//    PFObject *object = [_collectionArray objectAtIndex:[_tableView indexPathForSelectedRow].row];//获得当前tablview选中行的数据
//    DetailViewController *detail = [self.storyboard instantiateViewControllerWithIdentifier:@"detail"];
//    detail.Attractions = object;
//    [self.navigationController pushViewController:detail animated:YES];

}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [_collectionArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    
    PFObject *object = [_collectionArray objectAtIndex:indexPath.row];
    PFObject *activity = object[@"shoucangAttractions"];
    
    if (!(activity[@"Name"])) {
        
        cell.textLabel.text =@"";
    }
    cell.textLabel.text = [NSString stringWithFormat:@"%@", activity[@"Name"]];
    NSLog(@"cell == %@",cell.textLabel.text);
    return cell;
}

@end
