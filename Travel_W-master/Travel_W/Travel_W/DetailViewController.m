//
//  DetailViewController.m
//  Travel_W
//
//  Created by 王萌 on 15/9/23.
//  Copyright (c) 2015年 WM. All rights reserved.
//

#import "DetailViewController.h"
#import "DetailTableViewCell1.h"
#import "DetailTableViewCell2.h"
#import "DetailTableViewCell3.h"
#import "mapViewController.h"
#import "HomeViewController.h"
@interface DetailViewController ()
- (IBAction)shoucang:(UIBarButtonItem *)sender;
- (IBAction)segclick:(UISegmentedControl *)sender forEvent:(UIEvent *)event;
- (IBAction)clickTap:(UITapGestureRecognizer *)sender;
- (IBAction)saveButton:(UIButton *)sender forEvent:(UIEvent *)event;
@end

@implementation DetailViewController
@synthesize seg;
- (void)viewDidLoad {
    [super viewDidLoad];
    [self collectData];
    frame = self.view.frame;
    //去掉tableView多余的下划线
    _tableView.tableFooterView=[[UIView alloc]init];
    [self requestData];
    //[self createNav];
    self.navigationItem.title = [NSString stringWithFormat:@"%@", _Attractions[@"Name"]];
    //*************下载图片*************
    PFFile *photo = _Attractions[@"Photo"];
    [photo getDataInBackgroundWithBlock:^(NSData *photoData, NSError *error) {
        if (!error) {
            UIImage *image = [UIImage imageWithData:photoData];
            dispatch_async(dispatch_get_main_queue(), ^{
                _imgview.image = image;
            });
        }
    }];
    _timeLabel.text = _Attractions[@"Time"];
    _addressLabel.text = _Attractions[@"DetailAddress"];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)shoucang:(UIBarButtonItem *)sender {
    PFUser *user=[PFUser currentUser];
    if (!user) {
        [Utilities popUpAlertViewWithMsg:@"您还没有登录，请先登录" andTitle:nil];
    }
    else
    {
    if ([_shoucangItem.title isEqualToString:@"收藏"]) {
        PFUser *current=[PFUser currentUser];
        
        PFObject *praise = [PFObject objectWithClassName:@"collection"];
        praise[@"shoucangAttractions"] = _Attractions;
        praise[@"shoucangUser"] = current;
        praise[@"shoucang"]=@"收藏";
        [praise saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            
            if (succeeded){
                NSLog(@"Object Uploaded!");
                [self collectData];
            }
            else{
                NSLog(@"error=%@",error);
            }
        }];
        NSLog(@" 收藏==  %@",praise[@"shoucang"]);
    }
}
}
-(void)collectData
{
    PFUser *current=[PFUser currentUser];
    NSPredicate *predicate3 = [NSPredicate predicateWithFormat:@"shoucangAttractions == %@ AND shoucangUser == %@",_Attractions,current];
    PFQuery *query3 = [PFQuery queryWithClassName:@"collection" predicate:predicate3];
    //菊花 指示器
    UIActivityIndicatorView *aiv = [Utilities getCoverOnView:self.view];
    [query3 countObjectsInBackgroundWithBlock:^(int number, NSError *error) {
        if (!error) {
            [aiv stopAnimating];
            if (number == 0) {
                _shoucangItem.title=@"收藏";
                _shoucangItem.enabled=YES;
            } else {
                
                _shoucangItem.title=@"已收藏";
                _shoucangItem.enabled=NO;
            }
        }
    }];
}
- (IBAction)segclick:(UISegmentedControl *)sender forEvent:(UIEvent *)event {
    [_tableView reloadData];
}
//返回tableview的行数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (seg.selectedSegmentIndex == 0 || seg.selectedSegmentIndex == 1) {
        return _objectsForShow.count;
    } else {
        return _objectsForShow2.count;
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (seg.selectedSegmentIndex == 0) {
        DetailTableViewCell1 *cell = [tableView dequeueReusableCellWithIdentifier:@"cell1" forIndexPath:indexPath];//复用Cell
        //获得数据
        PFObject *object = [_objectsForShow objectAtIndex:indexPath.row];

        cell.nameLabel.text = object[@"Name"];
        cell.priceLabel.text =object[@"Pirce"];
        
        return cell;
    }
    else if (seg.selectedSegmentIndex == 1) {
        DetailTableViewCell2 *cell = [tableView dequeueReusableCellWithIdentifier:@"cell2" forIndexPath:indexPath];//复用Cell
        //获得数据
        PFObject *object = [_objectsForShow objectAtIndex:indexPath.row];
    
        cell.desirptionLabel.text = object[@"description"];
        cell.trafficLabel.text =object[@"traffic"];
        
        return cell;
    }
    else {
        DetailTableViewCell3 *cell = [tableView dequeueReusableCellWithIdentifier:@"cell3" forIndexPath:indexPath];//复用Cell
        //获得数据
        PFObject *object = [_objectsForShow2 objectAtIndex:indexPath.row];
        //NSLog(@"object = %@", object);
        PFUser *user = object[@"publisher"];
        cell.username.text = user.username;
        cell.advice.text = object[@"comment"];
        cell.time.text = object.createdAt.debugDescription;
        //******转换时间格式******
        NSDateFormatter* dateFormat = [[NSDateFormatter alloc] init];//实例化一个NSDateFormatter对象
        [dateFormat setDateFormat:@"yyyy-MM-dd"];//设定时间格式
        NSString *dateString = [dateFormat stringFromDate:object.createdAt] ; //求出当天的时间字符串，当更改时间格式时，时间字符串也能随之改变
        cell.time.text = dateString;
        //******转换时间格式******
        
        //*************下载图片*************
        PFFile *photo = user[@"Photo"];
        [photo getDataInBackgroundWithBlock:^(NSData *photoData, NSError *error) {
            if (!error) {
                UIImage *image = [UIImage imageWithData:photoData];
                dispatch_async(dispatch_get_main_queue(), ^{
                    cell.photoIV.image = image;
                });
            }
        }];
        
        return cell;
    }
}
/****根据内容更改行高****/
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (seg.selectedSegmentIndex == 0) {
        return 60;
    } else if (seg.selectedSegmentIndex == 1) {
        DetailTableViewCell2 *cell = [tableView dequeueReusableCellWithIdentifier:@"cell2"];
        
        PFObject *object = [_objectsForShow objectAtIndex:indexPath.row];
        
        CGSize maxSize = CGSizeMake(UI_SCREEN_W - 16, 1000);
        CGSize contentLabelSize = [object[@"description"] boundingRectWithSize:maxSize options:NSStringDrawingTruncatesLastVisibleLine|NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:13]} context:nil].size;
        
        CGSize maxSize2 = CGSizeMake(UI_SCREEN_W - 16, 1000);
        CGSize contentLabelSize2 = [object[@"traffic"] boundingRectWithSize:maxSize2 options:NSStringDrawingTruncatesLastVisibleLine|NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:13]} context:nil].size;
        
        return cell.desirptionLabel.frame.origin.y + contentLabelSize.height + contentLabelSize2.height + 41;
    } else {
        DetailTableViewCell3 *cell = [tableView dequeueReusableCellWithIdentifier:@"cell3"];
        
        PFObject *object = [_objectsForShow2 objectAtIndex:indexPath.row];
        
        CGSize maxSize = CGSizeMake(UI_SCREEN_W - 16, 1000);
        CGSize contentLabelSize = [object[@"comment"] boundingRectWithSize:maxSize options:NSStringDrawingTruncatesLastVisibleLine|NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:13]} context:nil].size;
        NSLog(@"origin = %f", cell.advice.frame.origin.y);
        NSLog(@"height = %f", contentLabelSize.height);
        NSLog(@"totalHeight = %f", cell.advice.frame.origin.y + contentLabelSize.height + 36);
        return cell.advice.frame.origin.y + contentLabelSize.height + 36;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

//通知 到parse读取数据
- (void)requestData {
    //查询Attractions表中当前用户所有字段
    _objectsForShow = [NSMutableArray new];
    [_objectsForShow addObject:_Attractions];
    
    PFQuery *query = [PFQuery queryWithClassName:@"Comments"];
    [query whereKey:@"target" equalTo:_Attractions];
    [query includeKey:@"publisher"];
    //菊花 指示器
    UIActivityIndicatorView *aiv = [Utilities getCoverOnView:self.view];
    [query findObjectsInBackgroundWithBlock:^(NSArray *returnedObjects, NSError *error) {
        [aiv stopAnimating];//停止动画
        if (!error) {
            _objectsForShow2 = [NSMutableArray arrayWithArray:returnedObjects];
            NSLog(@"_objectsForShow2 = %@", _objectsForShow2);
            //[_tableView reloadData];
        } else {
            NSLog(@"Error: %@ %@", error, [error userInfo]);
        }
    }];
}

//点击空白处返回键盘
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [super touchesBegan:touches withEvent:event];
    [self.view endEditing:YES];
}
#pragma mark 解决虚拟键盘挡住UITextField的方法
- (void)keyboardWillShow:(NSNotification *)notification
{
    //键盘输入的界面调整
    //键盘的高度
    CGRect keyboardRect = [[[notification userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    float height = keyboardRect.size.height;
    NSLog(@"Show = %f", height);
    CGRect reFrame = frame;
    reFrame.size = CGSizeMake(frame.size.width, frame.size.height - height);
    [UIView beginAnimations:@"Curl"context:nil];//动画开始
    [UIView setAnimationDuration:[[[notification userInfo] objectForKey:UIKeyboardAnimationDurationUserInfoKey] floatValue]];
    [UIView setAnimationDelegate:self];
    [self.view setFrame:reFrame];
    [UIView commitAnimations];
}

- (void)keyboardWillHide:(NSNotification *)notification
{
//    CGRect keyboardRect = [[[notification userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
//    float height = keyboardRect.size.height;
//    NSLog(@"Hide = %f", height);
//    CGRect frame = self.view.frame;
//    frame.size = CGSizeMake(frame.size.width, frame.size.height + height);
    [UIView beginAnimations:@"Curl"context:nil];//动画开始
    [UIView setAnimationDuration:[[[notification userInfo] objectForKey:UIKeyboardAnimationDurationUserInfoKey] floatValue]];
    [UIView setAnimationDelegate:self];
    [self.view setFrame:frame];
    [UIView commitAnimations];
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    // When the user presses return, take focus away from the text field so that the keyboard is dismissed.
//    NSTimeInterval animationDuration = 0.30f;
//    [UIView beginAnimations:@"ResizeForKeyboard" context:nil];
//    [UIView setAnimationDuration:animationDuration];
//    CGRect rect = CGRectMake(0.0f, 20.0f, self.view.frame.size.width, self.view.frame.size.height);
//    self.view.frame = rect;
//    [UIView commitAnimations];
    [textField resignFirstResponder];
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
//    CGRect frame = textField.frame;
//    int offset = frame.origin.y + 32 - (self.view.frame.size.height - 216.0);//键盘高度216
//    NSTimeInterval animationDuration = 0.30f;
//    [UIView beginAnimations:@"ResizeForKeyBoard" context:nil];
//    [UIView setAnimationDuration:animationDuration];
//    float width = self.view.frame.size.width;
//    float height = self.view.frame.size.height;
//    if(offset > 0)
//    {
//        CGRect rect = CGRectMake(0.0f, -offset,width,height);
//        self.view.frame = rect;
//    }
//    [UIView commitAnimations];
}
- (IBAction)clickTap:(UITapGestureRecognizer *)sender {
    if (sender.state == UIGestureRecognizerStateRecognized) {
        NSLog(@"IN");
        mapViewController *map = [self.storyboard instantiateViewControllerWithIdentifier:@"map"];
        map.Attractions = _Attractions;
        [self.navigationController pushViewController:map animated:YES];
    }
}

- (IBAction)saveButton:(UIButton *)sender forEvent:(UIEvent *)event {
    PFUser *user = [PFUser currentUser];
    
    if (!user) {
          [Utilities popUpAlertViewWithMsg:@"您还没有登录，请先登录" andTitle:nil];
    }
    else
    {
        NSString *comment = _t1.text;
        PFObject *item = [PFObject objectWithClassName:@"Comments"];
        item[@"comment"] = comment;
        
        //获得当前用户的实例
        PFUser *currentUser = [PFUser currentUser];
        item[@"publisher"] = currentUser;
        item[@"target"] = _Attractions;
        
        UIActivityIndicatorView *aiv = [Utilities getCoverOnView:self.view];
        _saveButton.enabled = NO;
        //保存操作
        [item saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            [aiv stopAnimating];
            _saveButton.enabled = YES;
            if (succeeded) {
                [[NSNotificationCenter defaultCenter] performSelectorOnMainThread:@selector(postNotification:) withObject:[NSNotification notificationWithName:@"refreshMine" object:self] waitUntilDone:YES];//通过通知来触发列表列
               [self.navigationController popViewControllerAnimated:YES];
            } else {
                [Utilities popUpAlertViewWithMsg:nil andTitle:nil];
                
            }
        }];
    }
    
}
@end
