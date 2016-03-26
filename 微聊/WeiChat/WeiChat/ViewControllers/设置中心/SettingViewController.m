
//
//  SettingViewController.m
//  WeiChat
//
//  Created by 张诚 on 15/2/2.
//  Copyright (c) 2015年 zhangcheng. All rights reserved.
//

#import "SettingViewController.h"
#import "AppDelegate.h"
#import "MainSliderViewController.h"
#import "LoginViewController.h"
#import "MyVcardViewController.h"
#import "ThemeViewController.h"
@interface SettingViewController ()
{
    //上面的大图片
    UIImageView*headerImageView;
    //头像
    UIImageView*myHeaderImageView;
    //前面
    UILabel*qmdLabel;
    //昵称
    UILabel*nickName;
    

}
@property(nonatomic,strong)NSArray*imageNameArray;
@end

@implementation SettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createView];
    
    [self createTableView];
    
    [self loadData];
    
    [self createLogin];
    
    // Do any additional setup after loading the view.
}
-(void)createLogin{
    
    NSUserDefaults*user=[NSUserDefaults standardUserDefaults];
    //判断isLogin是否有值
    if ([user objectForKey:isLogin]) {
        UIAlertView*al=[[UIAlertView alloc]initWithTitle:nil message:@"正在登陆中" delegate:nil cancelButtonTitle:nil otherButtonTitles:nil, nil];
        //登陆过，在这里需要再次执行登陆
        [[ZCXMPPManager sharedInstance]connectLogin:^(BOOL isSucceed) {
            [al dismissWithClickedButtonIndex:0 animated:YES];
            if (isSucceed) {
                NSLog(@"登陆成功");
                [self createMyVcard];

            }
        }];
        
    }else{
        //从注册或者登陆界面过来的，从登陆后者注册界面过来的，那么就是已经登陆过的，不需要再次登陆，但是需要记录isLogin有值
        [user setObject:isLogin forKey:isLogin];
        [user synchronize];
        
        [self createMyVcard];

    }

}
-(void)createMyVcard{
    
    [[ZCXMPPManager sharedInstance]getMyVcardBlock:^(BOOL isSucceed, XMPPvCardTemp *myVcard) {
        
        if (myVcard.photo) {
            myHeaderImageView.image=[UIImage imageWithData:myVcard.photo];
            
        }
        if (myVcard.nickname) {
            nickName.text=UNCODE(myVcard.nickname);
        }
        
        NSString*qmd=[myVcard elementForName:QMD].stringValue;
        if (qmd) {
            qmdLabel.text=UNCODE(qmd);
        }
        
        
    }];

}
-(void)loadData{
    self.dataArray=[NSMutableArray arrayWithObjects:@"个人资料",@"主题设置",@"气泡设置",@"聊天背景",@"关于我们",@"反馈",nil];
self.imageNameArray=@[@"buddy_header_icon_circle_small.png",@"found_icons_readcenter.png",@"circle_schoolmate.png",@"file_icon_picture.png",@"buddy_header_icon_troopGroup_small.png",@"buddy_header_icon_discussGroup_small.png"];

    [_tableView reloadData];
}

-(void)createTableView{
    _tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, HEIGHT/4, WIDTH/2, HEIGHT/4*3) style:UITableViewStyleGrouped];
    _tableView.delegate=self;
    _tableView.dataSource=self;
    [self.view addSubview:_tableView];
}
-(void)createNotificationTheme
{
NSString*imagePath=[NSString stringWithFormat:@"%@header_bg.png",self.path];
headerImageView.image=[UIImage imageWithContentsOfFile:imagePath];
}

-(void)createView{
    NSString*imagePath=[NSString stringWithFormat:@"%@header_bg.png",self.path];
    headerImageView=[ZCControl createImageViewWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT/4) ImageName:nil];
    headerImageView.image=[UIImage imageWithContentsOfFile:imagePath];
    [self.view addSubview:headerImageView];
    
    //头像
    myHeaderImageView=[ZCControl createImageViewWithFrame:CGRectMake(20, HEIGHT/4-84, 64, 64) ImageName:@"logo_2.png"];
    myHeaderImageView.layer.cornerRadius=32;
    myHeaderImageView.layer.masksToBounds=YES;
    [headerImageView addSubview:myHeaderImageView];
    //用户的昵称
    nickName=[ZCControl createLabelWithFrame:CGRectMake(94, HEIGHT/4-84, 100, 20) Font:15 Text:@"昵称"];
    nickName.textColor=[UIColor whiteColor];
    [headerImageView addSubview:nickName];
    //签名
    qmdLabel=[ZCControl createLabelWithFrame:CGRectMake(20, HEIGHT/4-20, 200, 20) Font:10 Text:nil];
    qmdLabel.textColor=[UIColor grayColor];
    [headerImageView addSubview:qmdLabel];
}
-(void)logOut{
    //注销 先切断网络连接 如果你不切断网络连接，就替换UI，会造成网络数据请求回来，赋值野指针
    [[NSUserDefaults standardUserDefaults]removeObjectForKey:isLogin];
    [[ZCXMPPManager sharedInstance]disconnect];

    //找到appDelegate指针
    AppDelegate*app=[UIApplication sharedApplication].delegate;
    //找到侧滑指针
    MainSliderViewController*vc=(MainSliderViewController*)[MainSliderViewController sharedSliderController];
    LoginViewController*login=[[LoginViewController alloc]init];
    [UIView animateWithDuration:1 animations:^{
       
        app.window.rootViewController=login;
    }completion:^(BOOL finished) {
        [vc releaseClick];
    }];
    
    
}
#pragma mark tableViewDelegate
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
    cell.textLabel.text=self.dataArray[indexPath.row];
    cell.imageView.image=[UIImage imageNamed:self.imageNameArray[indexPath.row]];
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 44;
}
-(UIView*)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIButton*logOutButton=[ZCControl createButtonWithFrame:CGRectMake(0, 10, 160, 30) ImageName:nil Target:self Action:@selector(logOut) Title:@"退出当前账号"];

    logOutButton.backgroundColor=[UIColor redColor];
    [logOutButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    //圆角
    logOutButton.layer.cornerRadius=10;
    logOutButton.layer.masksToBounds=YES;
    UIView*view=[[UIView alloc]initWithFrame:CGRectMake(0, 0, 100, 20)];
    [view addSubview:logOutButton];
    
    return view;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
     MainSliderViewController*vc=(MainSliderViewController*)[MainSliderViewController sharedSliderController];
    switch (indexPath.row) {
        case 0:
            //个人资料
        {
           
            MyVcardViewController*myVcardVc=[[MyVcardViewController alloc]initWithBlock:^{
                [self createMyVcard];
            }];
            
            [vc closeSideBarWithAnimate:YES complete:^(BOOL finished) {
                [self.navigationController pushViewController:myVcardVc animated:YES];
                
            }];
           
            
        
        }
            break;
        case 1:
            //主题设置
        {
            ThemeViewController*themeVc=[[ThemeViewController alloc] init];
            [vc closeSideBarWithAnimate:YES complete:^(BOOL finished) {
                [self.navigationController pushViewController:themeVc animated:YES];
            }];
            
        }
            break;
        case 2:
            //气泡设置
            break;
        case 3:
            //聊天背景
            break;
        case 4:
            //关于我们
            break;
        case 5:
            //反馈
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
