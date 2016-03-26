//
//  ViewController.m
//  xmpp
//
//  Created by 张广洋 on 15/10/12.
//  Copyright © 2015年 张广洋. All rights reserved.
//

#import "ViewController.h"

#import "XMPPManager.h"

@interface ViewController ()

@property (weak, nonatomic) IBOutlet UITextField *account;

@property (weak, nonatomic) IBOutlet UITextField *password;

@property (weak, nonatomic) IBOutlet UITextField *domainName;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.domainName.text=@"lzxuan.local";
}

- (IBAction)loginBtn:(id)sender {
    [XMPPManager share].name=self.account.text;
    [XMPPManager share].password=self.password.text;
    [XMPPManager share].domainName=self.domainName.text;
    [[XMPPManager share] login];
}

- (IBAction)register:(id)sender {
    [XMPPManager share].name=self.account.text;
    [XMPPManager share].password=self.password.text;
    [XMPPManager share].domainName=self.domainName.text;
    [[XMPPManager share] reg];
}
- (IBAction)dengchu:(id)sender {
    [[XMPPManager share]logOut];
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [[UIApplication sharedApplication].keyWindow endEditing:YES];
}


@end
