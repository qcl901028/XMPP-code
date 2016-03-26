//
//  ViewController.m
//  XMPPDemo
//
//  Created by lijinghua on 15/9/28.
//  Copyright (c) 2015年 lijinghua. All rights reserved.
//

#import "ViewController.h"
#import "XMPPManager.h"
#import "FriendListViewController.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UITextField *userNameTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextFiled;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}
- (IBAction)registAction:(id)sender {
    NSString *userName = self.userNameTextField.text;
    NSString *password = self.passwordTextFiled.text;
    if (userName.length == 0 || password.length == 0) {
        return;
    }
    
    [[XMPPManager sharedInstance] regist:userName password:password resultBlock:^(BOOL isOk,NSError *error){
        if (isOk) {
            NSLog(@"注册成功");
        }else{
            NSLog(@"注册失败 %@",error);
        }
    }];
}

- (IBAction)login:(id)sender {
    
    NSString *userName = self.userNameTextField.text;
    NSString *password = self.passwordTextFiled.text;
    if (userName.length == 0 || password.length == 0) {
        return;
    }
    
    [[XMPPManager sharedInstance]login:userName password:password resultBlock:^(BOOL isOK, NSError *error) {
        if (isOK) {
            NSLog(@"登陆成功");
            
            FriendListViewController *friendList = [[FriendListViewController alloc]init];
            [self.navigationController pushViewController:friendList animated:YES];
        }else{
            NSLog(@"登陆失败");
        }
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
