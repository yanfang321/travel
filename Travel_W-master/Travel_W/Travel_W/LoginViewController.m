//
//  LoginViewController.m
//  Travel_W
//
//  Created by 王萌 on 15/9/20.
//  Copyright (c) 2015年 WM. All rights reserved.
//

#import "LoginViewController.h"
#import "MainViewController.h"
#import "ModifiesPasswordViewController.h"
#import "RegisteredViewController.h"
@interface LoginViewController ()
- (IBAction)returnAction:(UIBarButtonItem *)sender;
- (IBAction)LoginAction:(UIButton *)sender forEvent:(UIEvent *)event;
@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self UISetting];
    
    self.navigationController.navigationBar.barTintColor=[UIColor colorWithRed:0 green:0.7 blue:0.9 alpha:1];//设置导航栏的颜色
    self.navigationController.navigationBar.barStyle=UIBarStyleBlackTranslucent;
    //记住用户名和密码
//    if (![[Utilities getUserDefaults:@"userName"] isKindOfClass:[NSNull class]]) {
//        _UserNameTextField.text = [Utilities getUserDefaults:@"userName"];
//    }
//    
//    if (![[Utilities getUserDefaults:@"passWord"] isKindOfClass:[NSNull class]]) {
//        _PasswordTextField.text = [Utilities getUserDefaults:@"passWord"];
//    }

    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"img1.png"]];
}

//存在时，检查指针是否存在
- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    //判断是否注册成功，是1的时候执行登录界面
    if ([[[storageMgr singletonStorageMgr]objectForKey:@"signup"]integerValue] == 1) {
        [[storageMgr singletonStorageMgr]removeObjectForKey:@"signup"];
    }
}

-(void)UISetting{
    //在textField里添加图片
    UIColor* boColor = [UIColor colorWithRed:221.0/255.0 green:221.0/255.0 blue:221.0/255.0 alpha:100];
    _UserNameTextField.layer.borderColor = boColor.CGColor;
    _UserNameTextField.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
    _UserNameTextField.leftViewMode = UITextFieldViewModeAlways;
    UIImageView* imgUser = [[UIImageView alloc] initWithFrame:CGRectMake(11, 11, 22, 22)];
    imgUser.image = [UIImage imageNamed:@"iconfont-user"];
    [_UserNameTextField.leftView addSubview:imgUser];

    _PasswordTextField.layer.borderColor = boColor.CGColor;
    _PasswordTextField.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
    _PasswordTextField.leftViewMode = UITextFieldViewModeAlways;
    UIImageView* imgPwd = [[UIImageView alloc] initWithFrame:CGRectMake(11, 11, 22, 22)];
    imgPwd.image = [UIImage imageNamed:@"iconfont-password"];
    [_PasswordTextField.leftView addSubview:imgPwd];
    //在textField里添加图片
    
    //设置textField的属性
    _UserNameTextField.layer.cornerRadius = 5.0;
    _UserNameTextField.borderStyle = UITextBorderStyleBezel;
    _UserNameTextField.clearButtonMode = UITextFieldViewModeAlways;
    [self.view addSubview:_UserNameTextField];
    
    _PasswordTextField.layer.cornerRadius = 5.0;
    _PasswordTextField.borderStyle = UITextBorderStyleBezel;
    _PasswordTextField.clearButtonMode = UITextFieldViewModeAlways;
    [self.view addSubview:_PasswordTextField];
    //设置textField的属性
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}
//点击return返回键盘
- (BOOL)textFieldShouldReturn:(UITextField *)theTextField {
    [theTextField resignFirstResponder];
    return YES;
}
//点击空白处返回键盘
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [super touchesBegan:touches withEvent:event];
    [self.view endEditing:YES];
}
- (IBAction)LoginAction:(UIButton *)sender forEvent:(UIEvent *)event {
    
    
    NSString *username = _UserNameTextField.text;
    NSString *password = _PasswordTextField.text;
    
    if ([username isEqualToString:@""] || [password isEqualToString:@""]) {
        [Utilities popUpAlertViewWithMsg:@"请填写用户名或密码" andTitle:nil];
        return;
    }
    //获取保护膜
    UIActivityIndicatorView *aiv = [Utilities getCoverOnView:self.view];
    
    [PFUser logInWithUsernameInBackground:username password:password block:^(PFUser *user, NSError *error) {
        [aiv stopAnimating];
        if (user) {
            //记住用户名和密码
//            [Utilities setUserDefaults:@"userName" content:username];
//            [Utilities setUserDefaults:@"passWord" content:password];
            NSLog(@"IN");
            [self dismissViewControllerAnimated:YES completion:nil];
        } else if (error.code == 101) {
            [Utilities popUpAlertViewWithMsg:@"用户名或密码错误" andTitle:nil];
        } else if (error.code == 100) {
            [Utilities popUpAlertViewWithMsg:@"网络不给力，请稍后再试" andTitle:nil];
        } else {
            [Utilities popUpAlertViewWithMsg:nil andTitle:nil];
        }
    }];
}

- (IBAction)returnAction:(UIBarButtonItem *)sender {
    //跳转到上一级页面
    [self dismissViewControllerAnimated:YES completion:nil];
    //push返回上一级页面
    //[self.navigationController popViewControllerAnimated:YES];
}

@end
