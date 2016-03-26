//
//  ChatViewController.m
//  XMPPDemo
//
//  Created by lijinghua on 15/9/28.
//  Copyright (c) 2015年 lijinghua. All rights reserved.
//

#import "ChatViewController.h"
#import "ChatModel.h"
#import "XMPPManager.h"
#import "XMPPCommonDefine.h"

@interface ChatViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UITextField *textFiled;
//聊天内容的数组
@property(nonatomic)NSMutableArray *chatContent;
@end

@implementation ChatViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.chatContent = [NSMutableArray array];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(receiveChatMessage:) name:XMPP_RECEIVE_CHAT_MESSAGE_NOTIFICATION object:nil];
}

- (void)receiveChatMessage:(NSNotification*)notify
{
    ChatModel *chat =  (ChatModel*)notify.object;
    [self.chatContent addObject:chat];
    [self.tableView reloadData];
}

- (IBAction)sendMessage:(id)sender {
    if (self.textFiled.text.length == 0) {
        return;
    }
    
    ChatModel *chat = [[ChatModel alloc]init];
    chat.from = [[XMPPManager sharedInstance] currentLoginUser];
    chat.to   = self.toUser.jid;
    chat.message = self.textFiled.text;
    
    [[XMPPManager sharedInstance] sendMessage:chat];
    
    [self.chatContent addObject:chat];
    [self.tableView reloadData];
}

#pragma mark -
#pragma mark UITabelViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.chatContent.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellId = @"cellId";
    UITableViewCell *cell = [tableView  dequeueReusableCellWithIdentifier:cellId];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellId];
    }
    ChatModel *chat = [self.chatContent objectAtIndex:indexPath.row];
    cell.textLabel.text = chat.message;
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%@->%@",chat.from,chat.to];
    return cell;
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
