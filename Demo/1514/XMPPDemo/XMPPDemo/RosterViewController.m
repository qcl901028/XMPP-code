//
//  RosterViewController.m
//  XMPPDemo
//
//  Created by lzxuan on 15/11/9.
//  Copyright (c) 2015年 lzxuan. All rights reserved.
//

#import "RosterViewController.h"
#import "XMPPManager.h"
#import "ChatViewController.h"
@interface RosterViewController () <XMPPRosterDelegate, UITableViewDelegate, UITableViewDataSource> {
    UITableView *_tableView;
    NSMutableArray *_rosterArray;
}

@end

@implementation RosterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _rosterArray = [NSMutableArray array];
    self.view.backgroundColor = [UIColor whiteColor];
    [[XMPPManager defautManager].xmppRoster addDelegate:self delegateQueue:dispatch_get_main_queue()];
    
    [self createTableView];
    UIBarButtonItem *right = [[UIBarButtonItem alloc] initWithTitle:@"添加好友" style:UIBarButtonItemStylePlain target:self action:@selector(doAdd:)];
    self.navigationItem.rightBarButtonItem = right;
    
}

- (void)doAdd:(id)sender {
    // @"lzxuan" 必须是服务器里有的用户名. @"lzxuan.local" 必须和服务器的地址一样
    XMPPJID *jid = [XMPPJID jidWithUser:@"lvzhixuan" domain:@"lzxuan.local" resource:@"iphone6s plus"];
    //添加好友
    [[XMPPManager defautManager].xmppRoster subscribePresenceToUser:jid];
}


- (void)createTableView {
    _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _rosterArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identtifer = @"identtifer";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identtifer];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identtifer];
    }
    
    cell.textLabel.text = [(XMPPJID *)_rosterArray[indexPath.row] user];
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    UIStoryboard *mainStoryBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    ChatViewController *chatViewController = [mainStoryBoard instantiateViewControllerWithIdentifier:@"ChatViewController"];
    chatViewController.title = [(XMPPJID *)_rosterArray[indexPath.row] user];
    chatViewController.friendJID = _rosterArray[indexPath.row];
    [self.navigationController pushViewController:chatViewController animated:YES];
}

- (void)xmppRosterDidBeginPopulating:(XMPPRoster *)sender {
    NSLog(@"开始检索好友列表");
}

- (void)xmppRoster:(XMPPRoster *)sender didRecieveRosterItem:(DDXMLElement *)item {
//    NSLog(NSString *format, ...)
    NSString *jid = [[item attributeForName:@"jid"] stringValue];
//    NSString *name = [[item attributeForName:@"name"] stringValue];
    XMPPJID *xmppJID = [XMPPJID jidWithString:jid];
    if ([_rosterArray containsObject:jid]) {
        return;
    }
    [_rosterArray addObject:xmppJID];
    [_tableView insertRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:_rosterArray.count - 1 inSection:0]] withRowAnimation:UITableViewRowAnimationFade];
    
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
