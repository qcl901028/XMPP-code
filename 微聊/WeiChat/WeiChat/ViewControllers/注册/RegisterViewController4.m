
//
//  RegisterViewController4.m
//  WeiChat
//
//  Created by 张诚 on 15/2/2.
//  Copyright (c) 2015年 zhangcheng. All rights reserved.
//

#import "RegisterViewController4.h"
#import "MainSliderViewController.h"
@interface RegisterViewController4 ()<UITextFieldDelegate>
{
    UITextField*qmdTextField;
    UITextField*addressTextField;

    UIAlertView*alert;
}
@end

@implementation RegisterViewController4

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"logo_bg_2@2x.png"]];
    [self createNav];
    [self createView];
    // Do any additional setup after loading the view.
}
-(void)createView{
    UIImageView*tempQmdImageView=[ZCControl createImageViewWithFrame:CGRectMake(0, 0, 60, 40) ImageName:nil];
    UIImageView*qmdImageView=[ZCControl createImageViewWithFrame:CGRectMake(20, 10, 20, 20) ImageName:@"icon_edit.png"];
    [tempQmdImageView addSubview:qmdImageView];
    
    qmdTextField=[ZCControl createTextFieldWithFrame:CGRectMake(0, 128, WIDTH, 40) placeholder:@"起一个狂拽炫酷的签名" passWord:NO leftImageView:tempQmdImageView rightImageView:nil Font:15 backgRoundImageName:nil];
    qmdTextField.delegate=self;
    qmdTextField.backgroundColor=[UIColor whiteColor];
    [self.view addSubview:qmdTextField];
    
    UIImageView*tempAddressImageView=[ZCControl createImageViewWithFrame:CGRectMake(0, 0, 60, 40) ImageName:nil];
    UIImageView*addressImageView=[ZCControl createImageViewWithFrame:CGRectMake(20, 10, 20, 20) ImageName:@"feed_loc_new.png"];
    [tempAddressImageView addSubview:addressImageView];
    
    addressTextField=[ZCControl createTextFieldWithFrame:CGRectMake(0, 169, WIDTH, 40) placeholder:@"请输入地址" passWord:NO leftImageView:tempAddressImageView rightImageView:nil Font:15 backgRoundImageName:nil];
    addressTextField.backgroundColor=[UIColor whiteColor];
    addressTextField.delegate=self;
    [self.view addSubview:addressTextField];
    


}
-(void)createNav{
    UIButton*rightButton=[ZCControl createButtonWithFrame:CGRectMake(0, 0, 60, 30) ImageName:nil Target:self Action:@selector(doneClick) Title:@"完成"];
    self.navigationItem.rightBarButtonItem=[[UIBarButtonItem alloc]initWithCustomView:rightButton];

}
#pragma mark 完成，开始注册
-(void)doneClick{
    if (qmdTextField.text.length>0&&addressTextField.text.length>0) {
        RegisterManager*manager=[RegisterManager shareManager];
        manager.qmd=qmdTextField.text;
        manager.address=addressTextField.text;
        
        
        
        //注册
        NSUserDefaults *user=[NSUserDefaults standardUserDefaults];
        [user setObject:manager.userName forKey:kXMPPmyJID];
        [user setObject:manager.passWord forKey:kXMPPmyPassword];
        [user synchronize];
        alert=[[UIAlertView alloc]initWithTitle:nil message:@"小苍正在拼命赶来，请耐心等待" delegate:nil cancelButtonTitle:nil otherButtonTitles:nil];
        [alert show];
        [[ZCXMPPManager sharedInstance]registerMothod:^(BOOL isSucceed) {
            [alert dismissWithClickedButtonIndex:0 animated:YES];
            if (isSucceed) {
                //登陆
                [[ZCXMPPManager sharedInstance]connectLogin:^(BOOL isOk) {
                    if (isOk) {
                        //登陆成功，获取个人信息资料Vcard，进行更新
                        [[ZCXMPPManager sharedInstance]getMyVcardBlock:^(BOOL succeed, XMPPvCardTemp *myVcard) {
                            if (succeed) {
                                //开始更新
                                if (manager.headerImage) {
                                myVcard.photo=UIImageJPEGRepresentation(manager.headerImage, 0.1);
                                }
                                
                                //需要注意的是vcard不支持中文，中文需要转码，否则无法上传成功
                                if (manager.nickName) {
                                    myVcard.nickname=CODE(manager.nickName);
                                }
                                //自定义的Vcard
                                //phoneNum为数字为什么还需要转码 一零三七
                                if (manager.phoneNum) {
                                    [[ZCXMPPManager sharedInstance]customVcardXML:CODE(manager.phoneNum) name:PHONENUM myVcard:myVcard];
                                }
                                if (manager.address) {
                                    [[ZCXMPPManager sharedInstance]customVcardXML:CODE(manager.address) name:ADDRESS myVcard:myVcard];
                                }
                                if (manager.birthday) {
                                    [[ZCXMPPManager sharedInstance]customVcardXML:CODE(manager.birthday) name:BYD myVcard:myVcard];
                                }
                                if (manager.sex) {
                                    [[ZCXMPPManager sharedInstance]customVcardXML:CODE(manager.sex) name:SEX myVcard:myVcard];
                                }
                                if (manager.qmd) {
                                    [[ZCXMPPManager sharedInstance]customVcardXML:CODE(manager.qmd) name:QMD myVcard:myVcard];
                                }
                                //更新在服务器上
                                [[ZCXMPPManager sharedInstance]upData:myVcard];
                                //进入主界面
                                
                                MainSliderViewController*vc=(MainSliderViewController*)[MainSliderViewController sharedSliderController];
                                [self.navigationController pushViewController:vc animated:YES];
                               
                                
                            }
                        }];
                        
                        
                    }else{
                    //登陆失败
                    }
                    
                }];
                
                
                
                
                
            }else{
                //提示用户，用户名错误，需要给用户重新申请一个新的数字账号
                manager.userName=[NSString stringWithFormat:@"%ld",DTAETIME];
                [self doneClick];
            }
        }];
        
        
        
    }else{
        UIAlertView*al=[[UIAlertView alloc]initWithTitle:@"提示" message:@"干巴爹，还差最后一步了，苍老师就在前面！" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"", nil];
        [al show];
    
    }

}
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField==qmdTextField) {
        [addressTextField becomeFirstResponder];
    }else{
        [self doneClick];
    }
    
    return YES;
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
