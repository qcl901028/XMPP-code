//
//  AddFriendViewController.m
//  xmpp
//
//  Created by 张广洋 on 15/10/13.
//  Copyright © 2015年 张广洋. All rights reserved.
//

#import "AddFriendViewController.h"

#import "XMPPManager.h"

@interface AddFriendViewController ()

@property (weak, nonatomic) IBOutlet UITextField *friendNameTF;

@property (weak, nonatomic) IBOutlet UITextField *domainNameTF;

@end

@implementation AddFriendViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.domainNameTF.text=@"lzxuan.local";
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)back:(id)sender {
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}


- (IBAction)addOneFriend:(id)sender {
    [XMPPManager share].name=self.friendNameTF.text;
    [XMPPManager share].domainName=self.domainNameTF.text;
    [[XMPPManager share] addFriend];
}



@end
