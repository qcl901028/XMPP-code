//
//  FriendListViewController.m
//  XMPPDemo
//
//  Created by lijinghua on 15/9/28.
//  Copyright (c) 2015年 lijinghua. All rights reserved.
//

#import "FriendListViewController.h"
#import "XMPPCommonDefine.h"
#import "XMPPManager.h"
#import "UserModel.h"
#import "ChatViewController.h"

@interface FriendListViewController ()<UITableViewDataSource,UITableViewDelegate>
@property(nonatomic)IBOutlet UITableView *tableView;
@property(nonatomic)NSArray     *friendList;
@end

@implementation FriendListViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cellId"];
    
    //添加好友列表变更的通知
    [[NSNotificationCenter defaultCenter]removeObserver:self];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(updateFriendList:) name:XMPP_FRIEND_LIST_NOTIFICATION object:nil];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(updateFriendList:) name:XMPP_UPDATE_STATUS_NOTIFICATION object:nil];
}

- (void)updateFriendList:(NSNotification*)notify
{
    //主动把数据拉回来
    self.friendList = [XMPPManager sharedInstance].freindList;
    [self.tableView reloadData];
}


#pragma mark -
#pragma mark UITableView 代理
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.friendList.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"cellId" forIndexPath:indexPath];
    UserModel *user = [self.friendList objectAtIndex:indexPath.row];
    if ([user.status isEqualToString:@"unavailable"]) {
        [cell.textLabel setTextColor:[UIColor lightGrayColor]];
    }else{
        [cell.textLabel setTextColor:[UIColor redColor]];
    }
    cell.textLabel.text = user.jid;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    UserModel *to = [self.friendList objectAtIndex:indexPath.row];
    ChatViewController *chatViewController = [[ChatViewController alloc]init];
    //传递聊天对象
    chatViewController.toUser = to;
    [self.navigationController pushViewController:chatViewController animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
