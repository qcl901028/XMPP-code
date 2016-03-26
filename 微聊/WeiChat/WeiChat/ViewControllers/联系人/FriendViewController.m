//
//  FriendViewController.m
//  WeiChat
//
//  Created by 张诚 on 15/2/2.
//  Copyright (c) 2015年 zhangcheng. All rights reserved.
//

#import "FriendViewController.h"
#import "FirendRequestViewController.h"
#import "FriendCell.h"
#import "ChatViewController.h"
@interface FriendViewController ()<UIAlertViewDelegate>
{
    int isOpen[4];
    UIButton*tableViewHeaderButton;

}
@end

@implementation FriendViewController
-(void)viewWillAppear:(BOOL)animated
{
    [self loadData];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self createTableView];
    [self createRightNav];
    // Do any additional setup after loading the view.
}
-(void)createRightNav{
    UIButton*rightButton=[ZCControl createButtonWithFrame:CGRectMake(0, 0, 44, 44) ImageName:nil Target:self Action:@selector(rightButton) Title:nil];
    UIImage*image=[UIImage imageWithContentsOfFile:[NSString stringWithFormat:@"%@header_icon_add.png",self.path]];
    [rightButton setImage:image forState:UIControlStateNormal];
    self.navigationItem.rightBarButtonItem=[[UIBarButtonItem alloc]initWithCustomView:rightButton];

}
#pragma mark 导航右按钮 添加好友
-(void)rightButton{
    UIAlertView*alert=[[UIAlertView alloc]initWithTitle:@"输入对方账号" message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    alert.alertViewStyle=UIAlertViewStylePlainTextInput;
    [alert show];
}
#pragma mark 接收主题的函数
-(void)createNotificationTheme
{
    [self createRightNav];
}
-(void)loadData{
    //读取好友信息
   NSArray*array= [[ZCXMPPManager sharedInstance]friendsList:^(BOOL isSucceed) {
       [self loadData];
    }];
    self.dataArray=[NSMutableArray arrayWithArray:array];
    [_tableView reloadData];
    
    //需要获取好友请求的数量
    NSInteger i=[ZCXMPPManager sharedInstance].subscribeArray.count;
    
    if (i) {
        [tableViewHeaderButton setTitle:[NSString stringWithFormat:@"您有%d好友请求",i] forState:UIControlStateNormal];
    }else{
        [tableViewHeaderButton setTitle:@"没有新的好友请求" forState:UIControlStateNormal];

    }

}
-(void)createTableView{
    _tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT-64-49) style:UITableViewStyleGrouped];
    _tableView.delegate=self;
    _tableView.dataSource=self;
    [self.view addSubview:_tableView];
    
    tableViewHeaderButton=[ZCControl createButtonWithFrame:CGRectMake(0, 0, WIDTH, 30) ImageName:nil Target:self Action:@selector(headerButtonClick) Title:nil];
    _tableView.tableHeaderView=tableViewHeaderButton;
}
//显示好友请求的按钮
-(void)headerButtonClick{
    FirendRequestViewController*vc=[[FirendRequestViewController alloc]init];
    vc.hidesBottomBarWhenPushed=YES;
    [self.navigationController pushViewController:vc animated:YES];
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    //self.dataArray每一个元素是数组，也就是每一段的内容
    return  isOpen[section]>0?0:[self.dataArray[section] count];
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    FriendCell*cell=[tableView dequeueReusableCellWithIdentifier:@"ID"];
    if (!cell) {
        cell=[[FriendCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"ID"];
    }
    //获取数据
    XMPPUserCoreDataStorageObject*object=self.dataArray[indexPath.section][indexPath.row];
    //cell.textLabel.text=object.jidStr;
    [cell config:object];
    
    return cell;
}
//行高
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}

//分段
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return   self.dataArray.count;
}
//设置段头高度
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 30;
}
//设置段头
-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    NSArray*array=@[@"好友",@"关注",@"被关注",@"陌生人"];
    UIButton*button=[ZCControl createButtonWithFrame:CGRectMake(0, 0, WIDTH, 30) ImageName:nil Target:self Action:@selector(headerClick:) Title:array[section]];
    button.tag=section;
    return button;
}
-(void)headerClick:(UIButton*)button{
    
    isOpen[button.tag]=!isOpen[button.tag];
    //刷新指定的某一段
    [_tableView reloadSections:[NSIndexSet indexSetWithIndex:button.tag] withRowAnimation:UITableViewRowAnimationLeft];
}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex) {
        UITextField*textField=[alertView textFieldAtIndex:0];
        if (textField.text.length) {
            //添加好友
            [[ZCXMPPManager sharedInstance]addSomeBody:textField.text Newmessage:nil];
        }
    }

}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
//获取数据源
    XMPPUserCoreDataStorageObject*object=self.dataArray[indexPath.section][indexPath.row];
    ChatViewController*vc=[[ChatViewController alloc]init];
    vc.friendJid=object.jidStr;
    vc.hidesBottomBarWhenPushed=YES;
    [self.navigationController pushViewController:vc animated:YES];

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
