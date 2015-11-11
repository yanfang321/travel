//
//  MineViewController.m
//  Travel_W
//
//  Created by 王萌 on 15/9/20.
//  Copyright (c) 2015年 WM. All rights reserved.
//

#import "MineViewController.h"
#import "LoginViewController.h"
#import "SetViewController.h"
#import "InformationViewController.h"
#import "TravelViewController.h"
#import "collectionViewController.h"
#import "CommentViewController.h"
@interface MineViewController ()
- (IBAction)LoginAction:(UIBarButtonItem *)sender;
- (IBAction)BackAction:(UIButton *)sender forEvent:(UIEvent *)event;
- (IBAction)tapAction:(UITapGestureRecognizer *)sender;
@end

@implementation MineViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UINavigationBar *bar=self.navigationController.navigationBar;
    bar.barTintColor=[UIColor colorWithRed:0 green:0.7 blue:0.9 alpha:1];//设置导航栏的颜色
    bar.barStyle=UIBarStyleBlackTranslucent;
    
    //把tableViewcell下面的下划线部分去掉
    _tableView.tableFooterView = [[UIView alloc]init];
    
    //创建数组
    _imageArray=[[NSMutableArray alloc]initWithObjects:@"地址",@"评论",@"收藏",@"攻略",@"设置",nil];
    _array=[[NSMutableArray alloc]initWithObjects:@"个人信息",@"我的评论",@"我的收藏",@"旅游攻略",@"设置",nil];
}
//跳转第二个页面
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    /*设置cell的点击事件*/
    if (indexPath.row == 0) {
        PFUser *currentUser = [PFUser currentUser];
        if (currentUser) {
            InformationViewController *information = [self.storyboard instantiateViewControllerWithIdentifier:@"Information"];
            information.hidesBottomBarWhenPushed = YES;
            information.title = @"个人信息";
            [self.navigationController pushViewController:information animated:YES];
        }
        else
        {
            LoginViewController *first=[self.storyboard instantiateViewControllerWithIdentifier:@"Login"];
            UINavigationController *nav=[[UINavigationController alloc]initWithRootViewController:first];
            nav.navigationBarHidden=NO;//隐藏导航条
           nav.modalTransitionStyle=UIModalTransitionStyleCoverVertical;//跳转的动画效果
            [self presentViewController:nav animated:YES completion:nil];//跳转到第二个页面，相当于modal
        }
    }
    if (indexPath.row == 1) {
        PFUser *currentUser = [PFUser currentUser];
        if (currentUser) {
        CommentViewController *comment = [self.storyboard instantiateViewControllerWithIdentifier:@"comment"];
        comment.hidesBottomBarWhenPushed = YES;
        comment.title = @"我的评论";
        [self.navigationController pushViewController:comment animated:YES];
    }
    else
    {
        LoginViewController *first=[self.storyboard instantiateViewControllerWithIdentifier:@"Login"];
        UINavigationController *nav=[[UINavigationController alloc]initWithRootViewController:first];
        nav.navigationBarHidden=NO;//隐藏导航条
        nav.modalTransitionStyle=UIModalTransitionStyleCoverVertical;//跳转的动画效果
        [self presentViewController:nav animated:YES completion:nil];//跳转到第二个页面，相当于modal
    }
    }
    if (indexPath.row == 2) {
        PFUser *currentUser = [PFUser currentUser];
        if (currentUser) {
        collectionViewController *collection = [self.storyboard instantiateViewControllerWithIdentifier:@"collection"];
        collection.hidesBottomBarWhenPushed = YES;
        collection.title = @"我的收藏";
        [self.navigationController pushViewController:collection animated:YES];
    }
    else
    {
        LoginViewController *first=[self.storyboard instantiateViewControllerWithIdentifier:@"Login"];
        UINavigationController *nav=[[UINavigationController alloc]initWithRootViewController:first];
        nav.navigationBarHidden=NO;//隐藏导航条
        nav.modalTransitionStyle=UIModalTransitionStyleCoverVertical;//跳转的动画效果
        [self presentViewController:nav animated:YES completion:nil];//跳转到第二个页面，相当于modal
    }
    }
    if (indexPath.row == 3) {
        TravelViewController *travel = [self.storyboard instantiateViewControllerWithIdentifier:@"travel"];
        travel.hidesBottomBarWhenPushed = YES;
        travel.title = @"旅游攻略";
        [self.navigationController pushViewController:travel animated:YES];
    }
    if (indexPath.row == 4) {
        SetViewController *set = [self.storyboard instantiateViewControllerWithIdentifier:@"Set"];
        set.hidesBottomBarWhenPushed = YES;
        set.title = @"设置";
        [self.navigationController pushViewController:set animated:YES];
    }
  
}
//表格行数
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_array count];
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
//单元格内容设置
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *myId = @"demoCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:myId forIndexPath:indexPath];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:myId];
    }
    
    cell.textLabel.text = [_array objectAtIndex:indexPath.row];
    
    NSString *name=[NSString stringWithFormat:@"%@.png",[self.imageArray objectAtIndex:[indexPath row]]];
    cell.imageView.image=[UIImage imageNamed:name];
    return cell;
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 40;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

//视图出现之前做的事情
- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self read];
}
-(void)read
{
    //****在数据库里下载图片****
    PFUser *currentUser = [PFUser currentUser];
    NSLog(@"currentUser = %@", currentUser);
    if (currentUser != nil) {
        PFFile *photo = currentUser[@"Photo"];
        
        [photo getDataInBackgroundWithBlock:^(NSData *photoData, NSError *error) {
            if (!error) {
                UIImage *image = [UIImage imageWithData:photoData];
                dispatch_async(dispatch_get_main_queue(), ^{
                    _Photo.image = image;
                });
            }
        }];
    //****在数据库里下载图片****
        
        _buttonItem.enabled= NO;
        _buttonItem.title=@"已登录";
        _backButton.hidden = NO;
        _nameLabel.text = @"未登录";
        //获得当前用户
        _nameLabel.text = currentUser.username;
    } else {
        _buttonItem.enabled=YES;
        _buttonItem.title=@"登录";
        _backButton.hidden = YES;
        _nameLabel.text = @"未登录";
        _Photo.image = nil;
        
    }
}

- (IBAction)LoginAction:(UIBarButtonItem *)sender {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    UIViewController *viewcontroller = [storyboard instantiateViewControllerWithIdentifier:@"Login"];
    //[self.navigationController showViewController:viewcontroller sender:self];
    [self presentViewController:viewcontroller animated:YES completion:nil];
}

- (IBAction)BackAction:(UIButton *)sender forEvent:(UIEvent *)event {
    
    [PFUser logOut];
    [self read];
}
#pragma   修改头像
- (IBAction)tapAction:(UITapGestureRecognizer *)sender {
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍照", @"从相册选择", nil];
    [actionSheet setExclusiveTouch:YES];
    actionSheet.actionSheetStyle = UIActionSheetStyleDefault;
    [actionSheet showInView:self.view];
}
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 2)
        return;
    
    UIImagePickerControllerSourceType temp;
    if (buttonIndex == 0) {
        temp = UIImagePickerControllerSourceTypeCamera;
    } else if (buttonIndex == 1) {
        temp = UIImagePickerControllerSourceTypePhotoLibrary;
    }
    if ([UIImagePickerController isSourceTypeAvailable:temp]) {
        _imagePickerController = nil;
        _imagePickerController = [[UIImagePickerController alloc] init];
        _imagePickerController.delegate = self;
        _imagePickerController.allowsEditing = YES;
        _imagePickerController.sourceType = temp;
        [self presentViewController:_imagePickerController animated:YES completion:nil];
    } else {
        if (temp == UIImagePickerControllerSourceTypeCamera) {
            [Utilities popUpAlertViewWithMsg:@"当前设备无照相功能" andTitle:nil];
        }
    }
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage *image = [info valueForKey:UIImagePickerControllerEditedImage];
    _Photo.image = image;
    [self dismissViewControllerAnimated:YES completion:nil];
    //****上传图片****
    PFUser *currentUser = [PFUser currentUser];
    NSData *photoData = UIImagePNGRepresentation(_Photo.image);
    PFFile *photoFile = [PFFile fileWithName:@"photo.png" data:photoData];
    currentUser[@"Photo"] = photoFile;
    UIActivityIndicatorView *aiv = [Utilities getCoverOnView:self.view];
    [currentUser saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        [aiv stopAnimating];
        if (succeeded) {
            [[NSNotificationCenter defaultCenter] performSelectorOnMainThread:@selector(postNotification:) withObject:[NSNotification notificationWithName:@"refreshMine" object:self] waitUntilDone:YES];
            [self.navigationController popViewControllerAnimated:YES];
        } else {
            [Utilities popUpAlertViewWithMsg:nil andTitle:nil];
        }
    }];
    //****上传图片****
}

@end
