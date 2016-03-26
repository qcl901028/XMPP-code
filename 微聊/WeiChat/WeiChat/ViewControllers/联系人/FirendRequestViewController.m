
//
//  FirendRequestViewController.m
//  WeiChat
//
//  Created by 张诚 on 15/2/4.
//  Copyright (c) 2015年 zhangcheng. All rights reserved.
//

#import "FirendRequestViewController.h"

@interface FirendRequestViewController ()

@end

@implementation FirendRequestViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createTableView];
    [self loadData];
    // Do any additional setup after loading the view.
}
-(void)loadData{
    self.dataArray=[ZCXMPPManager sharedInstance].subscribeArray;
    [_tableView reloadData];
}
-(void)createTableView{
    _tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT-64) style:UITableViewStyleGrouped];
    _tableView.delegate=self;
    _tableView.dataSource=self;
    [self.view addSubview:_tableView];

}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell*cell=[tableView dequeueReusableCellWithIdentifier:@"ID"];
    if (!cell) {
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"ID"];
        UIButton*agreeButton=[ZCControl createButtonWithFrame:CGRectMake(WIDTH-120, 0, 60, 30) ImageName:nil Target:self Action:@selector(agreeButtonClick:) Title:@"同意"];
        [cell.contentView addSubview:agreeButton];
        UIButton*rejectButton=[ZCControl createButtonWithFrame:CGRectMake(WIDTH-60, 0, 60, 30) ImageName:nil Target:self Action:@selector(rejectButtonClick:) Title:@"拒绝"];
        [cell.contentView addSubview:rejectButton];
    }
    cell.contentView.tag=indexPath.row;
    //读取数据源
    XMPPPresence*presence=self.dataArray[indexPath.row];
    //获取账号
    cell.textLabel.text=presence.from.user;

    return cell;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}
-(void)agreeButtonClick:(UIButton*)button{
    XMPPPresence*presence=self.dataArray[button.superview.tag];
    NSString*userName=presence.from.user;
    [[ZCXMPPManager sharedInstance]agreeRequest:userName];
    [self loadData];
}
-(void)rejectButtonClick:(UIButton*)button{
    XMPPPresence*presence=self.dataArray[button.superview.tag];
    NSString*userName=presence.from.user;
    [[ZCXMPPManager sharedInstance]reject:userName];
    [self loadData];
    
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
