//
//  NewViewController.m
//  WeiChat
//
//  Created by 张诚 on 15/2/2.
//  Copyright (c) 2015年 zhangcheng. All rights reserved.
//

#import "NewViewController.h"
#import "ZCZBarViewController.h"
#import "SearchRoomViewController.h"
@interface NewViewController ()
@property(nonatomic,strong)NSArray*imageNameArray;

@end

@implementation NewViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createTableView];
    [self loadData];
    // Do any additional setup after loading the view.
}
-(void)loadData{
    self.dataArray=[NSMutableArray arrayWithObjects:@"微空间",@"扫一扫",@"摇一摇",@"附近人",@"附近群",@"雷达",nil];
self.imageNameArray=@[@"icon_beiguanzhu_1.png",@"icon_code.png",@"icon_phone.png",@"icon_near.png",@"icon_friend_1@2x.png",@"icon_tuijian_1.png"];
    
    [_tableView reloadData];

}
-(void)createTableView{
    _tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT-64-49) style:UITableViewStyleGrouped];
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
    cell.imageView.image=[UIImage imageNamed:self.imageNameArray[indexPath.row]];
    cell.textLabel.text=self.dataArray[indexPath.row];
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.row) {
        case 0:
            //微空间  基本UI搞笑妹子之类的
            break;
        case 1:
            //扫一扫  ZBar
        {
            ZCZBarViewController*vc=[[ZCZBarViewController alloc]initWithBlock:^(NSString *str, BOOL isSucceed) {
                if (isSucceed) {
                    //添加好友
                    [[ZCXMPPManager sharedInstance]addSomeBody:str Newmessage:nil];
                }
                
            }];
            [self presentViewController:vc animated:YES completion:nil];
        
        }
            break;
        case 2:
            //摇一摇 重力感应
            break;
        case 3:
            //附近人 定位
            break;
        case 4:
            //附近群 搜索群
        {
            SearchRoomViewController*vc=[[SearchRoomViewController alloc]init];
            vc.hidesBottomBarWhenPushed=YES;
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case 5:
            //雷达  Ibeacon
            break;
        default:
            break;
    }

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
