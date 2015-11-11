//
//  RegisteredViewController.m
//  Travel_W
//
//  Created by 王萌 on 15/9/20.
//  Copyright (c) 2015年 WM. All rights reserved.
//

#import "RegisteredViewController.h"
#import "MainViewController.h"
#import "LoginViewController.h"
@interface RegisteredViewController ()
- (IBAction)signupAction:(UIButton *)sender forEvent:(UIEvent *)event;

@end

@implementation RegisteredViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //设置textField的属性
    _usernameTF.layer.cornerRadius = 5.0;
    _usernameTF.borderStyle = UITextBorderStyleBezel;
    _usernameTF.clearButtonMode = UITextFieldViewModeAlways;
    [self.view addSubview:_usernameTF];
    
    _passwordTF.layer.cornerRadius = 5.0;
    _passwordTF.borderStyle = UITextBorderStyleBezel;
    _passwordTF.clearButtonMode = UITextFieldViewModeAlways;
    [self.view addSubview:_passwordTF];
    
    _emailTF.layer.cornerRadius = 5.0;
    _emailTF.borderStyle = UITextBorderStyleBezel;
    _emailTF.clearButtonMode = UITextFieldViewModeAlways;
    [self.view addSubview:_emailTF];

    _confirmPwdTF.layer.cornerRadius = 5.0;
    _confirmPwdTF.borderStyle = UITextBorderStyleBezel;
    _confirmPwdTF.clearButtonMode = UITextFieldViewModeAlways;
    [self.view addSubview:_confirmPwdTF];
    //设置textField的属性
    
    //在textField里添加图片
    UIColor* boColor = [UIColor colorWithRed:221.0/255.0 green:221.0/255.0 blue:221.0/255.0 alpha:100];
    _usernameTF.layer.borderColor = boColor.CGColor;
    _usernameTF.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
    _usernameTF.leftViewMode = UITextFieldViewModeAlways;
    UIImageView* imgUser = [[UIImageView alloc] initWithFrame:CGRectMake(11, 11, 22, 22)];
    imgUser.image = [UIImage imageNamed:@"iconfont-user"];
    [_usernameTF.leftView addSubview:imgUser];
    
    _emailTF.layer.borderColor = boColor.CGColor;
    _emailTF.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
    _emailTF.leftViewMode = UITextFieldViewModeAlways;
    UIImageView* imgEmail = [[UIImageView alloc] initWithFrame:CGRectMake(11, 11, 22, 22)];
    imgEmail.image = [UIImage imageNamed:@"iconfont-email"];
    [_emailTF.leftView addSubview:imgEmail];
    
    _passwordTF.layer.borderColor = boColor.CGColor;
    _passwordTF.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
    _passwordTF.leftViewMode = UITextFieldViewModeAlways;
    UIImageView* imgPwd = [[UIImageView alloc] initWithFrame:CGRectMake(11, 11, 22, 22)];
    imgPwd.image = [UIImage imageNamed:@"iconfont-password"];
    [_passwordTF.leftView addSubview:imgPwd];
    
    _confirmPwdTF.layer.borderColor = boColor.CGColor;
    _confirmPwdTF.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
    _confirmPwdTF.leftViewMode = UITextFieldViewModeAlways;
    UIImageView* imgPwd1 = [[UIImageView alloc] initWithFrame:CGRectMake(11, 11, 22, 22)];
    imgPwd1.image = [UIImage imageNamed:@"iconfont-password"];
    [_confirmPwdTF.leftView addSubview:imgPwd1];
    //在textField里添加图片
    
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"img1.png"]];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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

- (IBAction)signupAction:(UIButton *)sender forEvent:(UIEvent *)event {
    NSString *username=_usernameTF.text;
    NSString *email=_emailTF.text;
    NSString *password=_passwordTF.text;
    NSString *confirmPwd=_confirmPwdTF.text;
    if ([username isEqualToString:@""] || [email isEqualToString:@""] || [password isEqualToString:@""] || [confirmPwd isEqualToString:@""]) {
        [Utilities popUpAlertViewWithMsg:@"请填写所有信息" andTitle:nil];
        return;
    }
    if (![password isEqualToString:confirmPwd]) {
        [Utilities popUpAlertViewWithMsg:@"确认密码是必须与密码保持一致" andTitle:nil];
        return;
    }
    //创建用户
    PFUser *user=[PFUser user];
    user.username=username;
    user.password=password;
    user.email=email;
    
    //创建一个保护膜
    UIActivityIndicatorView *aiv = [Utilities getCoverOnView:self.view];
    
    //用户写入数据库
    [user signUpInBackgroundWithBlock:^(BOOL succeeded,NSError *error)
     {
         [aiv stopAnimating];
         if (!error) {
             //记住用户名
             [Utilities setUserDefaults:@"userName" content:username];
             
             //注册成功是1的时候，跳转到登录界面
             [[storageMgr singletonStorageMgr]addKeyAndValue:@"sigup" And:@1];//单例化变量中插入一个键值对
             //注册成功退到登录界面
             [self.navigationController popViewControllerAnimated:YES];
             
         }else if (error.code == 202) {//202该用户已经使用
             [Utilities popUpAlertViewWithMsg:@"该用户名已被使用，请尝试其它名称" andTitle:nil];
         } else if (error.code == 203) {
             [Utilities popUpAlertViewWithMsg:@"该电子邮箱已被使用，请尝试其它名称" andTitle:nil];
         }else if (error.code == 125) {
             [Utilities popUpAlertViewWithMsg:@"该邮箱地址为非法地址" andTitle:nil];
         } else if (error.code == 100) {
             [Utilities popUpAlertViewWithMsg:@"网络不给力，请稍后再试" andTitle:nil];
         }else {
             [Utilities popUpAlertViewWithMsg:nil andTitle:nil];
         }
     }];
}
@end
