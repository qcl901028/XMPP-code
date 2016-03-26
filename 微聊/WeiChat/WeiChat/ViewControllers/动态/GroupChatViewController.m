//
//  GroupChatViewController.m
//  WeiChat
//
//  Created by 张诚 on 15/2/6.
//  Copyright (c) 2015年 zhangcheng. All rights reserved.
//

#import "GroupChatViewController.h"
#import "ZCFaceToolBar.h"
@interface GroupChatViewController ()
{
    ZCXMPPManager*manager;
    XMPPRoom*room;
    ZCFaceToolBar*toolBar;
}
@end

@implementation GroupChatViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
/*
 群聊在xmpp是类似聊天室那样的，加入进去就可以聊天，但是并不是我们QQ群组的形式，是永久加入的，而是每次都是临时加入，在你下线后会自动退出，并且在你程序中需要注意的是在写加入房间时候，加入成功后，点击返回，应当退出房间，否则再次进入时候，不会获取消息
 
 */
    [self createTableView];
    [self createNavLeft];
    [self createFaceToolBar];
    [self loadData];

    // Do any additional setup after loading the view.
}
-(void)createFaceToolBar{
    toolBar=[[ZCFaceToolBar alloc]initWithFrame:CGRectMake(0, 0, 100, 100) voice:nil ViewController:self Block:^(NSString *sign, NSString *message) {
        //发送消息
        [manager sendGroupMessage:[NSString stringWithFormat:@"%@%@",sign,message] roomName:[[self.roomJid componentsSeparatedByString:@"@"] firstObject]];
    }];
    [self.view addSubview:toolBar];
    //建立观察者
    [toolBar addObserver:self forKeyPath:@"frame" options:NSKeyValueObservingOptionNew context:nil];
}
-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    _tableView.frame=CGRectMake(0, 0, WIDTH, toolBar.frame.origin.y);
    if (self.dataArray.count) {
        [_tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:self.dataArray.count-1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
    }

}
-(void)createNavLeft{
    UIButton*leftButton=[ZCControl createButtonWithFrame:CGRectMake(0, 0, 60, 30) ImageName:@"header_leftbtn_black_nor.png" Target:self Action:@selector(leftButtonClick) Title:@"返回"];
    self.navigationItem.leftBarButtonItem=[[UIBarButtonItem alloc]initWithCustomView:leftButton];


}
-(void)leftButtonClick{
    //退出房间
    [manager XmppOutRoom:room];
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)loadData{
    //加入房间
    NSString*roomJidStr=[[self.roomJid componentsSeparatedByString:@"@"]firstObject];
    
    manager= [ZCXMPPManager sharedInstance];
    
    //xmppRoomCreateRoomName返回一个xmpproom 这个值需要记录，因为在退出房间时候，需要这个指针
    self.dataArray=[NSMutableArray arrayWithCapacity:0];
  room=[manager xmppRoomCreateRoomName:roomJidStr nickName:@"zhangcheng111" MessageBlock:^(NSDictionary *message) {
        //获取的消息
      NSLog(@"%@",message);
      /*
       {
       jid = 3344521;
       message = "<message xmlns=\"jabber:client\" type=\"groupchat\" to=\"zc001@1000phone.net/IOS\" id=\"11053814\" from=\"3344521@room11.1000phone.net/11053814\"><body>[1]dddddd</body></message>";
       }
       */
      [self.dataArray addObject:message];
      
      [_tableView reloadData];
      //产生便宜
      if (self.dataArray.count) {
          [_tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:self.dataArray.count-1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
      }
      
    } presentBlock:^(NSDictionary *present) {
       //预留的接口
    }];
}
-(void)createTableView{
    _tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT-64-49) style:UITableViewStylePlain];
    _tableView.delegate=self;
    _tableView.dataSource=self;
    [self.view addSubview:_tableView];

}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell*cell=[tableView dequeueReusableCellWithIdentifier:@"ID"];
    if (!cell) {
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"ID"];
    }
    //读取数据源
    XMPPMessage*message=self.dataArray[indexPath.row][@"message"];
    cell.textLabel.text=message.body;

    
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
