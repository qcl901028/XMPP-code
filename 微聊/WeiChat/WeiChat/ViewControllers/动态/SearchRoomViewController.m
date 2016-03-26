//
//  SearchRoomViewController.m
//  WeiChat
//
//  Created by 张诚 on 15/2/6.
//  Copyright (c) 2015年 zhangcheng. All rights reserved.
//

#import "SearchRoomViewController.h"
#import "GroupChatViewController.h"
@interface SearchRoomViewController ()

@end

@implementation SearchRoomViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createTableView];
    [self loadData];
    // Do any additional setup after loading the view.
}
-(void)loadData{
    [[ZCXMPPManager sharedInstance]searchXmppRoomBlock:^(NSMutableArray *array) {
        self.dataArray=[NSMutableArray arrayWithArray:array];
        [_tableView reloadData];
    }];

}
-(void)createTableView{
    _tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT-64) style:UITableViewStyleGrouped];
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
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"ID"];
    }
    //获取数据源是字典 roomName roomJid
    NSDictionary*dic=self.dataArray[indexPath.row];
    cell.textLabel.text=dic[@"roomName"];
    cell.detailTextLabel.text=dic[@"roomJid"];
    
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //获取数据源
    NSDictionary*dic=self.dataArray[indexPath.row];
    NSString*roomJid=dic[@"roomJid"];
    GroupChatViewController*vc=[[GroupChatViewController alloc]init];
    vc.hidesBottomBarWhenPushed=YES;
    vc.roomJid=roomJid;
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
