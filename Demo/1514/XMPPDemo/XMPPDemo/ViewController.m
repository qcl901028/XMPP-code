//
//  ViewController.m
//  XMPPDemo
//
//  Created by lzxuan on 15/11/9.
//  Copyright (c) 2015年 lzxuan. All rights reserved.
//

#import "ViewController.h"
#import "XMPPManager.h"
#import "RosterViewController.h"
@interface ViewController () <XMPPStreamDelegate>
@property (weak, nonatomic) IBOutlet UITextField *nameTextField;
@property (weak, nonatomic) IBOutlet UITextField *pwTextField;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [[XMPPManager defautManager].xmppStream addDelegate:self delegateQueue:dispatch_get_main_queue()];
}
- (IBAction)loginAction:(id)sender {
    if (self.nameTextField.text.length == 0 || self.pwTextField.text.length == 0) {
        NSLog(@"你的用户名或密码都错了,你登陆个毛啊!!");
        return;
    }
    [[XMPPManager defautManager] loginwithName:self.nameTextField.text andPassword:self.pwTextField.text];
    
}
- (IBAction)registerAction:(id)sender {
    if (self.nameTextField.text.length == 0 || self.pwTextField.text.length == 0) {
        NSLog(@"你的用户名或密码都错了,你注册个毛啊!!");
        return;
    }
    [[XMPPManager defautManager] registerwithName:self.nameTextField.text andPassword:self.pwTextField.text];
    
    
}

- (void)xmppStreamDidAuthenticate:(XMPPStream *)sender {
    
    RosterViewController *roster = [RosterViewController new];
    roster.title = @"好友列表";
    [self.navigationController pushViewController:roster animated:YES];
    
    NSLog(@"登录成功!!!!!!");
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
