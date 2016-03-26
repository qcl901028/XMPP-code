//
//  ThemeViewController.m
//  WeiChat
//
//  Created by 张诚 on 15/2/4.
//  Copyright (c) 2015年 zhangcheng. All rights reserved.
//

#import "ThemeViewController.h"
#import "HttpDownLoadBlock.h"
#import "UIImageView+WebCache.h"
#import "ThemeManager.h"
@interface ThemeViewController ()

@end

@implementation ThemeViewController
-(void)viewWillAppear:(BOOL)animated
{
    self.navigationController.navigationBarHidden=NO;
}
-(void)viewWillDisappear:(BOOL)animated
{
    self.navigationController.navigationBarHidden=YES;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self createTableView];
    [self loadData];
    // Do any additional setup after loading the view.
}
-(void)loadData{
    HttpDownLoadBlock*request=[[HttpDownLoadBlock alloc]initWithStrUrl:@"http://imgcache.qq.com/club/item/theme/json/data_4.6+_3.json?callback=json" Block:^(BOOL isSucceed, HttpDownLoadBlock *http) {
        //需要注意的是这个地址不是常规地址，无法获得解析结果，需要进行对字符串进行操作，之后才能解析
        [self jsonValue:http];
        
        
    }];

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
        UIImageView*imageView=[ZCControl createImageViewWithFrame:CGRectMake(10, 5, 80, 45) ImageName:@"logo_2.png"];
        imageView.tag=200;
        [cell.contentView addSubview:imageView];
        
        UILabel*label=[ZCControl createLabelWithFrame:CGRectMake(100, 5, 100, 30) Font:15 Text:nil];
        label.tag=300;
        [cell.contentView addSubview:label];
        
    }
    //数据源
    NSDictionary*dic=self.dataArray[indexPath.row];
    //获取id值
    NSString*idStr=dic[@"id"];
    NSString*num=[NSString stringWithFormat:@"%d",[idStr intValue]%10];
    //拼接图片的网络地址http://i.gtimg.cn/club/item/theme/img/8/1008/mobile_list.jpg?max_age=31536000&t=0
    NSString*imageUrlStr=[NSString stringWithFormat:@"http://i.gtimg.cn/club/item/theme/img/%@/%@/mobile_list.jpg?max_age=31536000&t=0",num,idStr];
    
    
    /* 原生控件在网络请求，适配是问题，所以我们自定义
    [cell.imageView sd_setImageWithURL:[NSURL URLWithString:imageUrlStr] placeholderImage:[UIImage imageNamed:@"logo_2.png"]];
    cell.textLabel.text=dic[@"name"];
     */
    //寻找200和300的控件
    UIImageView*imageView=(UIImageView*)[cell.contentView viewWithTag:200];
    UILabel*label=(UILabel*)[cell.contentView viewWithTag:300];
    [imageView sd_setImageWithURL:[NSURL URLWithString:imageUrlStr] placeholderImage:[UIImage imageNamed:@"logo_2.png"]];
    label.text=dic[@"name"];

    return cell;

}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}
-(void)jsonValue:(HttpDownLoadBlock*)http{
//把获取的数据转换为字符串
    NSString*str=[[NSString alloc]initWithData:http.data encoding:NSUTF8StringEncoding];
    NSRange range=[str rangeOfString:@"("];
    NSRange range1=[str rangeOfString:@")"];
    str=[str substringWithRange:NSMakeRange(range.location+1, range1.location-range.location-1)];
    NSLog(@"%@",str);
    
    //解析
    NSDictionary*dic=[NSJSONSerialization JSONObjectWithData:[str dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableContainers error:nil];
    NSDictionary*dic1=dic[@"detailList"];
    self.dataArray=[NSMutableArray arrayWithArray:[dic1 allValues]];
    [_tableView reloadData];
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //获取数据源
    NSDictionary*dic=self.dataArray[indexPath.row];
    UIAlertView*alertView=[[UIAlertView alloc]initWithTitle:nil message:@"下载中，请稍后。。。" delegate:nil cancelButtonTitle:nil otherButtonTitles:nil];
    ThemeManager*manager=[ThemeManager shareManager];
    
    BOOL isSucceed=[manager themeDownLoadData:dic Block:^(BOOL isOk) {
        [alertView dismissWithClickedButtonIndex:0 animated:YES];
    }];
    if (isSucceed==NO) {
        [alertView show];
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
