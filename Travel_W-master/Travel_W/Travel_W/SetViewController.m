//
//  SetViewController.m
//  Travel_W
//
//  Created by 王萌 on 15/9/24.
//  Copyright (c) 2015年 WM. All rights reserved.
//

#import "SetViewController.h"
#import "MineViewController.h"
#import "ModifiesPasswordViewController.h"
@interface SetViewController ()
- (IBAction)ModifiesUsername:(UIButton *)sender forEvent:(UIEvent *)event;

@end

@implementation SetViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"img2.jpg"]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)ModifiesUsername:(UIButton *)sender forEvent:(UIEvent *)event {
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"修改" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定",nil];
    alert.alertViewStyle= UIAlertViewStylePlainTextInput;
    [alert show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    PFUser*currentUser=[PFUser currentUser];
    //如果是0表示取消按钮  1表示yes按钮
    if (buttonIndex == 1)
    {
        UITextField *textField = [alertView textFieldAtIndex:0];
        if([textField.text isEqualToString:@""])
        {
            [Utilities popUpAlertViewWithMsg:@"请填写用户名" andTitle:nil];
            return;//终止该方法
        }
        //读取用户输入的内容
        NSString*string=textField.text;
        //上传用户输入的内容
        currentUser[@"username"]=string;
    
        //刷新
        UIActivityIndicatorView*aiv=[Utilities getCoverOnView:self.view];
        [currentUser saveInBackgroundWithBlock:^(BOOL succeeded,NSError*error)
         {
             [aiv stopAnimating];
             if(succeeded){
                 [[NSNotificationCenter defaultCenter]performSelectorOnMainThread:@selector(postNotification:) withObject:[NSNotification notificationWithName:@"refreshMine" object:self]waitUntilDone:YES];
                 [self.navigationController popViewControllerAnimated:YES];
             }
             else
             {
                 [Utilities popUpAlertViewWithMsg:nil andTitle:nil];
             }
             
         }];
    }
}
@end
