//
//  ChatViewController.m
//  WeiChat
//
//  Created by 张诚 on 15/2/5.
//  Copyright (c) 2015年 zhangcheng. All rights reserved.
//

#import "ChatViewController.h"
#import "ZCFaceToolBar.h"
#import "MessageCell.h"
#import "Photo.h"
@interface ChatViewController ()
{
    ZCXMPPManager*manager;
    ZCFaceToolBar*toolBar;
}
@property(nonatomic)UIImage*friendImage;
@property(nonatomic)UIImage*myImage;
@end

@implementation ChatViewController
-(void)dealloc{
//销毁观察者
    [toolBar removeObserver:self forKeyPath:@"frame" context:nil];
    [manager valuationChatPersonName:nil IsPush:NO MessageBlock:nil];

}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self createTableView];
    [self createFaceToolBar];
    [self loadData];
    [self createVcard];
    
    // Do any additional setup after loading the view.
}
//获得vcard
-(void)createVcard{
[[ZCXMPPManager sharedInstance]getMyVcardBlock:^(BOOL isSucceed, XMPPvCardTemp *myVcard) {
    if (myVcard.photo) {
        self.myImage=[UIImage imageWithData:myVcard.photo];
    }else{
        self.myImage=[UIImage imageNamed:@"logo_2.png"];
    }
    
    [_tableView reloadData];
}];
[[ZCXMPPManager sharedInstance]friendsVcard:[[self.friendJid componentsSeparatedByString:@"@"]firstObject ] Block:^(BOOL isSucceed, XMPPvCardTemp *friendVcard) {
    if (friendVcard.photo) {
        self.friendImage=[UIImage imageWithData:friendVcard.photo];
    }else{
        self.friendImage=[UIImage imageNamed:@"logo_2.png"];
    }
    
    [_tableView reloadData];
}];
    
    
}
-(void)createFaceToolBar{
    toolBar=[[ZCFaceToolBar alloc]initWithFrame:CGRectMake(0, 0, 100, 100) voice:nil ViewController:self Block:^(NSString *sign, NSString *message) {
        
        [manager sendMessageWithJID:self.friendJid Message:message Type:sign];
        [self loadData];
        
    }];
    [self.view addSubview:toolBar];
    
    //使用kvo观察键盘的弹出和消失
    [toolBar addObserver:self forKeyPath:@"frame" options:NSKeyValueObservingOptionNew context:nil];

}
-(void)loadData{
    //配置消息界面
    manager=[ZCXMPPManager sharedInstance];
    [manager valuationChatPersonName:self.friendJid IsPush:YES MessageBlock:^(ZCMessageObject *object) {
        //获取消息
        [self loadData];
    }];
    //获取消息
    NSArray*array= [manager messageRecord];
    if (array) {
        self.dataArray=[NSMutableArray arrayWithArray:array];
    }else{
        self.dataArray=[NSMutableArray arrayWithCapacity:0];
    }
    //刷新界面
    if (self.dataArray.count) {
        
        [_tableView reloadData];
        //产生偏移
        [_tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:self.dataArray.count-1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
    }
    

}
-(void)createTableView{
    _tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT-64-49) style:UITableViewStyleGrouped];
    _tableView.delegate=self;
    _tableView.dataSource=self;
    _tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_tableView];
    //对tableView添加手势
    UITapGestureRecognizer*tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapClick:)];
    [_tableView addGestureRecognizer:tap];
    
}
-(void)tapClick:(UITapGestureRecognizer*)tap{
//添加手势收回键盘
    [toolBar dismissKeyBoard];

}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MessageCell*cell=[tableView dequeueReusableCellWithIdentifier:@"ID"];
    if (!cell) {
        cell=[[MessageCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"ID"];
        cell.backgroundColor=[UIColor clearColor];
        //设置选择的颜色
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
    }
    //获取数据
    XMPPMessageArchiving_Message_CoreDataObject*object=self.dataArray[indexPath.row];
    [cell configFriendImage:self.friendImage myImage:self.myImage message:object];
    
    
    return cell;
}
-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    _tableView.frame=CGRectMake(0, 0, WIDTH, toolBar.frame.origin.y);
    //移动时候刷新数据
    if (self.dataArray.count) {
        [_tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:self.dataArray.count-1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
    }
}

//设置行高
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
//获取内容
    XMPPMessageArchiving_Message_CoreDataObject*object=self.dataArray[indexPath.row];
    NSString*str=object.message.body;
    
    if ([str hasPrefix:MESSAGE_STR]) {
        CGFloat height=[str boundingRectWithSize:CGSizeMake(200, 1000) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:10]} context:nil].size.height;
        
        return height+40;
    }else{
        if ([str hasPrefix:MESSAGE_IMAGESTR]) {
            UIImage*image=[Photo string2Image:[str substringFromIndex:3]];
            return image.size.height>200?220:image.size.height;
        }else{
            if ([str hasPrefix:MESSAGE_BIGIMAGESTR]) {
                return 210;
            }else{
                return 70;
            }
        
        }
    
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
