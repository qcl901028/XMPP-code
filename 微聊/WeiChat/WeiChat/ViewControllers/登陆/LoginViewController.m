//
//  LoginViewController.m
//  WeiChat
//
//  Created by 张诚 on 15/1/30.
//  Copyright (c) 2015年 zhangcheng. All rights reserved.
//

#import "LoginViewController.h"
#import "RegisterViewController1.h"
#import "MainSliderViewController.h"
@interface LoginViewController ()<UITextFieldDelegate>
{
    //背景图
    UIView*bgView;
    //logo
    UIImageView*logoImageView;
    //承载2个输入框
    UIImageView*textImageView;
    //用户名
    UITextField*userNameTextField;
    //密码
    UITextField*passWordTextField;
}
@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //创建背景图和logo
    [self createView];
    //创建输入框
    [self createTextField];
    
    //建立观察键盘
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(showKeyboard:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(hideKeyborad:) name:UIKeyboardWillHideNotification object:nil];
    //给bgView添加手势
    UITapGestureRecognizer*tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapClick)];
    [bgView addGestureRecognizer:tap];
    // Do any additional setup after loading the view.
}
#pragma mark 点击手势
-(void)tapClick{
    [self.view endEditing:YES];
}

#pragma mark 键盘弹出
-(void)showKeyboard:(NSNotification*)notification{
//计算键盘高度
    float y=[[ notification.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey]CGRectValue].size.height;
    //界面移动
    [UIView animateWithDuration:0.3 animations:^{
        bgView.frame=CGRectMake(0,0-(y/2), WIDTH, HEIGHT);
        logoImageView.transform=CGAffineTransformMakeScale(0.1, 0.1);
        //xcode6上面需要改为0.1才有效果，0则突然消失
        
    }];
    
}
#pragma makr 键盘消失
-(void)hideKeyborad:(NSNotification*)notification{
    [UIView animateWithDuration:0.3 animations:^{
        bgView.frame=self.view.frame;
        logoImageView.transform=CGAffineTransformMakeScale(1, 1);
    }];
}
-(void)createTextField{
    //临时的View
    UIImageView*userTempImageView=[ZCControl createImageViewWithFrame:CGRectMake(0, 0, 50, 40) ImageName:nil];
    UIImageView*userImageView=[ZCControl createImageViewWithFrame:CGRectMake(20, 10, 20, 20) ImageName:@"userName.png"];
    [userTempImageView addSubview:userImageView];
    
    userNameTextField=[ZCControl createTextFieldWithFrame:CGRectMake(0, 15, WIDTH-20, 40) placeholder:@"请输入用户名" passWord:NO leftImageView:userTempImageView rightImageView:nil Font:15 backgRoundImageName:nil];
    userNameTextField.delegate=self;
    [textImageView addSubview:userNameTextField];
    //临时的View
    UIImageView*passTempImageView=[ZCControl createImageViewWithFrame:CGRectMake(0, 0, 50, 40) ImageName:nil];
    UIImageView*passImageView=[ZCControl createImageViewWithFrame:CGRectMake(20, 10, 20, 20) ImageName:@"passWord.png"];
    [passTempImageView addSubview:passImageView];
    passWordTextField=[ZCControl createTextFieldWithFrame:CGRectMake(0, 70, WIDTH-20, 40) placeholder:@"请输入密码" passWord:YES leftImageView:passTempImageView rightImageView:nil Font:15 backgRoundImageName:nil];
    passWordTextField.delegate=self;
    
    [textImageView addSubview:passWordTextField];
    
    

}
-(void)createView{
    //背景图
    bgView=[ZCControl viewWithFrame:self.view.frame];
    //设置颜色
    bgView.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"logo_bg_2@2x.png"]];
    [self.view addSubview:bgView];
    
    //创建logo 预计是120*120
    logoImageView=[ZCControl createImageViewWithFrame:CGRectMake(WIDTH/2-60, 44, 120, 120) ImageName:@"logo_2.png"];
    //圆
    logoImageView.layer.cornerRadius=60;
    logoImageView.layer.masksToBounds=YES;
    [bgView addSubview:logoImageView];
    //输入框的图片
    textImageView=[ZCControl createImageViewWithFrame:CGRectMake(0, 0, WIDTH-20, 120) ImageName:@"login@2x.png"];
    //设置中心点
    textImageView.center=CGPointMake(WIDTH/2, 230);
    [bgView addSubview:textImageView];
    //设置登陆按钮
    
    UIButton*registerButton=[ZCControl createButtonWithFrame:CGRectMake(WIDTH/2-80, 340, 60, 30) ImageName:@"btn_login_bg_2.png" Target:self Action:@selector(registerClick) Title:@"注册"];
    [registerButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [bgView addSubview:registerButton];
    
    UIButton*loginButton=[ZCControl createButtonWithFrame:CGRectMake(WIDTH/2+20, 340, 60, 30) ImageName:@"btn_login_bg_2.png" Target:self Action:@selector(loginClick) Title:@"登陆"];
    [loginButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [bgView addSubview:loginButton];
    

}
#pragma mark 实现登陆按钮
-(void)loginClick{
    //收回键盘
    [self.view endEditing:YES];
    if (userNameTextField.text.length>0&&passWordTextField.text.length>0) {
        //执行登陆
        NSUserDefaults*user=[NSUserDefaults standardUserDefaults];
        [user setObject:userNameTextField.text forKey:kXMPPmyJID];
        //经常会出现的错误：[user setObject:userNameTextField forKey:kXMPPmyJID];
        [user setObject:passWordTextField.text forKey:kXMPPmyPassword];
        [user synchronize];
        
        //执行xmpp的登陆功能
        [[ZCXMPPManager sharedInstance]connectLogin:^(BOOL isSucceed) {
            
            if (isSucceed) {
                NSLog(@"登陆成功，进入主界面");
                MainSliderViewController*vc=(MainSliderViewController*)[MainSliderViewController sharedSliderController];
                UINavigationController*nc=[[UINavigationController alloc]initWithRootViewController:vc];
                [self presentViewController:nc animated:YES completion:nil];
                
                
            }else{
                NSLog(@"用户名密码错误");
                UIAlertView*al=[[UIAlertView alloc]initWithTitle:@"提示" message:@"用户名密码错误" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
                [al show];
            }
        }];
        
        
        
        
    }else{
        UIAlertView*al=[[UIAlertView alloc]initWithTitle:@"提示" message:@"请填写完整用户名密码" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [al show];
    }
    
}

#pragma mark 实现注册按钮
-(void)registerClick{
    RegisterViewController1*vc=[[RegisterViewController1 alloc]init];
    //默认动画是从下移动到上，修改默认动画为旋转
    vc.modalTransitionStyle=UIModalTransitionStyleFlipHorizontal;
    vc.title=@"请输入昵称（1/4）";
    
    UINavigationController*nc=[[UINavigationController alloc]initWithRootViewController:vc];
    [self presentViewController:nc animated:YES completion:nil];
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField==userNameTextField) {
        //成为第一响应对象
        [passWordTextField becomeFirstResponder];
    }else{
        [self loginClick];
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
