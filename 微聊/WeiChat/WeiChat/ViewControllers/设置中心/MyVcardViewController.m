
//
//  MyVcardViewController.m
//  WeiChat
//
//  Created by 张诚 on 15/2/3.
//  Copyright (c) 2015年 zhangcheng. All rights reserved.
//

#import "MyVcardViewController.h"

@interface MyVcardViewController ()<UIImagePickerControllerDelegate,UINavigationControllerDelegate,UIActionSheetDelegate,UIAlertViewDelegate>
{
//记录是否修改了
    BOOL isUpDate;

}
//用于记录vcard
@property(nonatomic,assign)XMPPvCardTemp*myVcard;
//字典 用于记录原始数据
@property(nonatomic,strong)NSMutableDictionary*dataDic;
@end

@implementation MyVcardViewController
-(instancetype)initWithBlock:(void (^)())a
{
    if (self=[super init]) {
        self.myVcardBlock=a;
    }
    return self;
}
-(void)viewWillAppear:(BOOL)animated
{
    self.navigationController.navigationBarHidden=NO;
    //解决进入相册后状态条颜色发生改变为黑色
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
}
-(void)viewWillDisappear:(BOOL)animated
{
    self.navigationController.navigationBarHidden=YES;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self createTableView];
    [self loadData];
    //重写导航的左按钮
    [self createLeftNav];
    // Do any additional setup after loading the view.
}
-(void)createLeftNav{
    UIButton*leftButton=[ZCControl createButtonWithFrame:CGRectMake(0, 0, 60, 30) ImageName:nil Target:self Action:@selector(backClick) Title:@"返回"];
    self.navigationItem.leftBarButtonItem=[[UIBarButtonItem alloc]initWithCustomView:leftButton];

}
-(void)backClick{
    if (isUpDate) {
        [[ZCXMPPManager sharedInstance]upData:self.myVcard];
        if (self.myVcardBlock) {
            self.myVcardBlock();
        }
        
    }
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)loadData{
    //获取Vcard，并且记录
    [[ZCXMPPManager sharedInstance]getMyVcardBlock:^(BOOL isSucceed, XMPPvCardTemp *vcard) {
        if (isSucceed) {
            self.myVcard=vcard;
            //组装数据
            //获取头像
            NSData*headerImageData;
            if (self.myVcard.photo) {
                headerImageData=self.myVcard.photo;
            }else{
                headerImageData=UIImagePNGRepresentation([UIImage imageNamed:@"logo_2.png"]);
            }
            NSString*nickName;
            if (self.myVcard.nickname) {
                nickName=self.myVcard.nickname;
            }else{
                nickName=[[NSUserDefaults standardUserDefaults]objectForKey:kXMPPmyJID];
            }
            NSString*qmd;
            qmd=[self.myVcard elementForName:QMD].stringValue;
            if (qmd==nil) {
                qmd=@"这家伙很懒，没留下什么";
            }
            NSString*sex;
            sex=[self.myVcard elementForName:SEX].stringValue;
            if (sex==nil) {
                sex=@"无性繁殖？";
            }
            NSString*address;
            address=[self.myVcard elementForName:ADDRESS].stringValue;
            if (address==nil) {
                address=@"居住地：火星";
            }
            NSString*qr;
            qr=[[NSUserDefaults standardUserDefaults]objectForKey:kXMPPmyJID];
            NSString*phoneNum;
            phoneNum=[self.myVcard elementForName:PHONENUM].stringValue;
            if (phoneNum==nil) {
                phoneNum=@"脚下有我电话，包小姐";
            }
            
            //初始化数组
//            self.dataArray=[NSMutableArray arrayWithObjects:@[@"头像",headerImageData],@[@"昵称",nickName],@[@"签名",qmd],@[@"性别",sex],@[@"地区",address],@[@"二维码",qr],@[@"手机号",phoneNum], nil];
            
            self.dataArray=[NSMutableArray arrayWithObjects:@"头像",@"昵称",@"签名",@"性别",@"地区",@"二维码",@"手机号", nil];
        
            self.dataDic=[NSMutableDictionary dictionaryWithObjectsAndKeys:headerImageData,@"头像",UNCODE(nickName),@"昵称",UNCODE(qmd),@"签名",UNCODE(sex),@"性别",UNCODE(address),@"地区",qr,@"二维码",UNCODE(phoneNum),@"手机号", nil];
            [_tableView reloadData];
            
        }
        
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
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"ID"];
        cell.detailTextLabel.textColor=[UIColor grayColor];
        //创建imageView
        UIImageView*imageView=[ZCControl createImageViewWithFrame:CGRectMake(WIDTH-60, 0, 40, 40) ImageName:nil];
        imageView.layer.cornerRadius=20;
        imageView.layer.masksToBounds=YES;
        imageView.tag=100;
        [cell.contentView addSubview:imageView];
    
    }
    //头像和二维码需要设置为图片
    cell.detailTextLabel.text=nil;
    //寻找imageView的tag值为100的指针
    UIImageView*imageView=(UIImageView*)[cell.contentView viewWithTag:100];
    imageView.hidden=YES;
    cell.textLabel.text=self.dataArray[indexPath.row];
    if (indexPath.row==0) {
        //头像
        imageView.hidden=NO;
        imageView.image=[UIImage imageWithData:self.dataDic[self.dataArray[indexPath.row]]];
        
    }else{
        if (indexPath.row==5) {
            //二维码
            imageView.hidden=NO;
            
            
        }else{
            cell.detailTextLabel.text=self.dataDic[self.dataArray[indexPath.row]];
        }
    
    }
    
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
//进行修改
    if (indexPath.row==0) {
        UIActionSheet*sheet=[[UIActionSheet alloc]initWithTitle:@"选择照片" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"相机",@"相册", nil];
        [sheet showInView:self.view];
    }else{
        if (indexPath.row!=3&&indexPath.row!=5) {
            UITableViewCell*cell=[_tableView cellForRowAtIndexPath:indexPath];
            [self createAlertShowTitle:[NSString stringWithFormat:@"请输入%@",cell.textLabel.text] tag:indexPath.row];
        }
    
    }


}
-(void)createAlertShowTitle:(NSString*)title tag:(NSInteger)tag{
     UIAlertView*alert=[[UIAlertView alloc]initWithTitle:title message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    alert.tag=tag;
    alert.alertViewStyle=UIAlertViewStylePlainTextInput;
    [alert show];

}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex==0) {
        return;
    }
    
    //获取输入框
    UITextField*textField=[alertView textFieldAtIndex:0];
    //获取文字
    if (textField.text.length==0) {
        return;
    }
    
    switch (alertView.tag) {
        case 1:
            //昵称
            self.myVcard.nickname=CODE(textField.text);
            [self.dataDic setObject:textField.text forKey:@"昵称"];
            break;
        case 2:
            //签名
            [[ZCXMPPManager sharedInstance]customVcardXML:CODE(textField.text) name:QMD myVcard:self.myVcard];
            [self.dataDic setObject:textField.text forKey:@"签名"];

            break;
        case 4:
            //地区
            [[ZCXMPPManager sharedInstance]customVcardXML:CODE(textField.text) name:ADDRESS myVcard:self.myVcard];
            [self.dataDic setObject:textField.text forKey:@"地区"];

            break;
        case 6:
            //手机号
            [[ZCXMPPManager sharedInstance]customVcardXML:CODE(textField.text) name:PHONENUM myVcard:self.myVcard];
            [self.dataDic setObject:textField.text forKey:@"手机号"];
            break;
        

        default:
            break;
    }
    isUpDate=YES;
    [_tableView reloadData];
    
    
    
}

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex==2) {
        return;
    }
    UIImagePickerController*picker=[[UIImagePickerController alloc]init];
    picker.delegate=self;
    if (!buttonIndex) {
        if ([UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceFront]) {
            picker.sourceType=UIImagePickerControllerSourceTypeCamera;
        }
    }
    [self presentViewController:picker animated:YES completion:nil];
}
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    //获取图片
    UIImage*image=[info objectForKey:UIImagePickerControllerOriginalImage];
    [self.dataDic setObject:UIImagePNGRepresentation(image) forKey:@"头像"];
    // 同时修改数据源头像
    self.myVcard.photo=UIImageJPEGRepresentation(image, 0.1);
    //并且记录修改
    isUpDate=YES;
    //刷新数据
    [_tableView reloadData];
    [self dismissViewControllerAnimated:YES completion:nil];
}
-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self dismissViewControllerAnimated:YES completion:nil];
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
