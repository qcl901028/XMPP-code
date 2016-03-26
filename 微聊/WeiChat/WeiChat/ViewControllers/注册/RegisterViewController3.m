
//
//  RegisterViewController3.m
//  WeiChat
//
//  Created by 张诚 on 15/2/2.
//  Copyright (c) 2015年 zhangcheng. All rights reserved.
//

#import "RegisterViewController3.h"
#import "RegisterViewController4.h"
@interface RegisterViewController3 ()<UITextFieldDelegate>
{
    UITextField*phoneNumTextField;
    UITextField*passWordTextField;
}
@end

@implementation RegisterViewController3

- (void)viewDidLoad {
    [super viewDidLoad];
      self.view.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"logo_bg_2@2x.png"]];
    [self createNav];
    
    [self createTextField];
    // Do any additional setup after loading the view.
}
-(void)createTextField{
    UIImageView*tempPhoneNumImageView=[ZCControl createImageViewWithFrame:CGRectMake(0, 0, 60, 40) ImageName:nil];
    UIImageView*phoneNumImageView=[ZCControl createImageViewWithFrame:CGRectMake(20, 10, 20, 20) ImageName:@"icon_register_mobile.png"];
    [tempPhoneNumImageView addSubview:phoneNumImageView];
    
    phoneNumTextField=[ZCControl createTextFieldWithFrame:CGRectMake(0, 128, WIDTH, 40) placeholder:@"请输入手机号" passWord:NO leftImageView:tempPhoneNumImageView rightImageView:nil Font:15 backgRoundImageName:nil];
    phoneNumTextField.backgroundColor=[UIColor whiteColor];
    phoneNumTextField.delegate=self;
    [self.view addSubview:phoneNumTextField];
    
    UIImageView*tempPassWordImageView=[ZCControl createImageViewWithFrame:CGRectMake(0, 0, 60, 40) ImageName:nil];
    UIImageView*passWordImageView=[ZCControl createImageViewWithFrame:CGRectMake(20, 10, 20, 20) ImageName:@"icon_register_password.png"];
    [tempPassWordImageView addSubview:passWordImageView];
    
    
    passWordTextField=[ZCControl createTextFieldWithFrame:CGRectMake(0, 169, WIDTH, 40) placeholder:@"请输入密码" passWord:YES leftImageView:tempPassWordImageView rightImageView:nil Font:15 backgRoundImageName:nil];
    passWordTextField.backgroundColor=[UIColor whiteColor];
    //如果设置密码是否可见，可以设置该属性进行修改passWordTextField.secureTextEntry
    passWordTextField.delegate=self;
    [self.view addSubview:passWordTextField];
}
-(void)createNav{
    UIButton*button=[ZCControl createButtonWithFrame:CGRectMake(0, 0, 60, 30) ImageName:nil Target:self Action:@selector(nextClick) Title:@"下一步"];
    self.navigationItem.rightBarButtonItem=[[UIBarButtonItem alloc]initWithCustomView:button];
    

}
-(void)nextClick{
    [self.view endEditing:YES];
    if (phoneNumTextField.text.length>0&&passWordTextField.text.length>0) {
        RegisterManager*manager=[RegisterManager shareManager];
        manager.phoneNum=phoneNumTextField.text;
        manager.passWord=passWordTextField.text;
        RegisterViewController4*vc=[[RegisterViewController4  alloc]init];
        vc.title=@"完善资料（4/4）";
        [self.navigationController pushViewController:vc animated:YES];
        
    }else{
        UIAlertView*al=[[UIAlertView alloc]initWithTitle:@"提示" message:@"请填写完整资料" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
        [al show];
    
    }
    
   
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField==phoneNumTextField) {
        [passWordTextField becomeFirstResponder];
    }else{
        if (phoneNumTextField.text.length>0&&passWordTextField.text.length>0) {
            [self nextClick];
        }else{
            UIAlertView*al=[[UIAlertView alloc]initWithTitle:@"提示" message:@"请填写完整资料" delegate:nil cancelButtonTitle:@"" otherButtonTitles:nil];
            [al show];
        
        }
    
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
