//
//  InformationViewController.m
//  Travel_W
//
//  Created by 王萌 on 15/9/29.
//  Copyright (c) 2015年 WM. All rights reserved.
//

#import "InformationViewController.h"
#import "InformationTableViewCell.h"
#import "MyKit.h"
@interface InformationViewController ()
{
    BOOL isEdit;
}
//- (IBAction)deitorAction:(UIButton *)sender forEvent:(UIEvent *)event;
- (IBAction)deitorAction:(UIBarButtonItem *)sender;


- (IBAction)saveAction:(UIButton *)sender forEvent:(UIEvent *)event;
@end
@implementation InformationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //去掉tableView多余的下划线
    _tableView.tableFooterView=[[UIView alloc]init];
    //[self createNavBar];
    //[self createFootView];
    _array=[[NSMutableArray alloc]initWithObjects:@"昵称",@"个性签名",@"邮箱",@"性别",@"地址",nil];
    isEdit = NO;
    _saveButton.hidden = YES;
    [self creatbutton];
    
}
-(void)creatbutton
{
    self.tabBarController.tabBar.hidden=YES;
    self.navigationController.navigationBar.translucent=NO;
    //_editor.title=@"编辑";
}
//点击return键盘回收
- (BOOL)textFieldShouldReturn:(UITextField *)theTextField {
    [theTextField resignFirstResponder];
    return YES;
}
//点击空白处键盘回收
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [super touchesBegan:touches withEvent:event];
    [self.view endEditing:YES];
}
//表格行数
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_array count];
}
//单元格内容设置
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    InformationTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];//复用Cell
    cell.nameLabel.text = [_array objectAtIndex:indexPath.row];
    PFUser *user =[PFUser currentUser];
    NSLog(@"%@",user);
    cell.editable = isEdit;
    if (indexPath.row == 0) {
        if (!(user[@"username"])) {
            cell.detailTF.text=@"";
        }else
        {
            cell.detailTF.text=[NSString stringWithFormat:@"%@",user[@"username"]];
        }
    }else if(indexPath.row == 1)
    {
        if (!(user[@"signature"])) {
            cell.detailTF.text=@"";
        }else
        {
            
            cell.detailTF.text=[NSString stringWithFormat:@"%@", user[@"signature"]];
        }
    }
    else if (indexPath.row==2)
    {
        if (!(user[@"email"])) {
            cell.detailTF.text=@"";
        }else
        {
            
            cell.detailTF.text=[NSString stringWithFormat:@"%@", user[@"email"]];
        }
    }
    else if (indexPath.row==3)
    {
        if (!(user[@"gender"])) {
            cell.detailTF.text=@"";
        }else
        {
            cell.detailTF.text=[NSString stringWithFormat:@"%@", user[@"gender"]];
        }
    }
    else if (indexPath.row==4)
    {
        if (!(user[@"address"])) {
            cell.detailTF.text=@"";
        }else
        {
            cell.detailTF.text=[NSString stringWithFormat:@"%@", user[@"address"]];
        }
    }
    
    if (isEdit == YES) {
        if (indexPath.row==0) {
            if (!(cell.detailTF.text)) {
                _secondname = @"";
            }
            _secondname = cell.detailTF.text;
        }else if (indexPath.row==1)
        {
            if (!(cell.detailTF.text)) {
                _signature = @"";
            }
            _signature = cell.detailTF.text;
        }
        else if (indexPath.row==2)
        {
            if (!(cell.detailTF.text)) {
                _email = @"";
            }
            _email = cell.detailTF.text;
        }
        else if (indexPath.row==3)
        {
            if (!(cell.detailTF.text)) {
                _gender = @"";
            }
            _gender = cell.detailTF.text;
        }
        else if (indexPath.row==4)
        {
            if (!(cell.detailTF.text)) {
                _address = @"";
            }
            _address = cell.detailTF.text;
        }
        
    }
    return cell;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 70;
}
//取消选择tableView
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


- (IBAction)deitorAction:(UIBarButtonItem *)sender {
    if(isEdit == NO)
    {
        isEdit=YES;
//        [_editor setTitle:@"取消" forState:UIControlStateNormal];
//        [_editor se:@"取消" forState:UIControlStateNormal];
        _editor.title=@"取消";

        _saveButton.hidden = NO;
        
        [_tableView reloadData];
    }
    else if([_editor.title isEqualToString:@"取消"])
    {
        isEdit=NO;
//        [_editor setTitle:@"编辑" forState:UIControlStateNormal];
         _editor.title=@"编辑";
        _saveButton.hidden = YES;
        
        [_tableView reloadData];
    }

}

- (IBAction)saveAction:(UIButton *)sender forEvent:(UIEvent *)event {
    PFUser *user = [PFUser currentUser];
    NSLog(@"B: %@", _secondname);
    
    InformationTableViewCell *cell1 = (InformationTableViewCell *)[_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    user[@"username"] = cell1.detailTF.text;
    
    InformationTableViewCell *cell2 = (InformationTableViewCell *)[_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]];
    user[@"signature"] = cell2.detailTF.text;
    
    InformationTableViewCell *cell3 = (InformationTableViewCell *)[_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:2 inSection:0]];
    user[@"email"] = cell3.detailTF.text;
    
    InformationTableViewCell *cell4 = (InformationTableViewCell *)[_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:3 inSection:0]];
    user[@"gender"] = cell4.detailTF.text;
    
    InformationTableViewCell *cell5 = (InformationTableViewCell *)[_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:4 inSection:0]];
    user[@"address"] = cell5.detailTF.text;
    //菊花 指示器
    UIActivityIndicatorView *aiv = [Utilities getCoverOnView:self.view];
    [user saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error){
        if (succeeded) {
            [aiv stopAnimating];
            //[self requestData];
        } else {
            
        }
    }];
//    [_editor setTitle:@"编辑" forState:UIControlStateNormal];
     _editor.title=@"编辑";
    isEdit=NO;
    _saveButton.hidden = YES;
    
    [_tableView reloadData];
}

@end
