
//
//  RegisterViewController2.m
//  WeiChat
//
//  Created by 张诚 on 15/2/2.
//  Copyright (c) 2015年 zhangcheng. All rights reserved.
//

#import "RegisterViewController2.h"
#import "RegisterViewController3.h"
@interface RegisterViewController2 ()<UINavigationControllerDelegate,UIImagePickerControllerDelegate,UIActionSheetDelegate>
{
//头像按钮
    UIButton*headerImageButton;
//选择生日按钮
    UIControl*birthdayControl;
//生日的图标
    UIImageView*birthdayImageView;
//生日的日期
    UILabel*birthdayLabel;
//生日的右箭头
    UIImageView*birthdayRightImageView;
//生日的背景图
    UIView*birthdayView;

//选择性别按钮
    UIControl*sexControl;
//性别的图标
    UIImageView*sexImageView;
//性别的结果
    UILabel*sexLabel;
//性别的右箭头
    UIImageView*sexRightImageView;
//性别的背景图
    UIView*sexView;
    
//选择日期的滚筒控件
    UIDatePicker*_dataPicker;
    
    
//记录是否有值
    BOOL isHeaderImage;
    BOOL isBirthDay;
}
@end

@implementation RegisterViewController2
-(void)viewWillAppear:(BOOL)animated
{
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
}
- (void)viewDidLoad {
    [super viewDidLoad];
     self.view.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"logo_bg_2@2x.png"]];
    //设置导航
    [self createNav];
    //设置页面
    [self createView];
}
-(void)createView{
    headerImageButton=[ZCControl createButtonWithFrame:CGRectMake(WIDTH/2-50,74, 100, 100) ImageName:@"icon_register_camera@2x.png" Target:self Action:@selector(headerImageButtonClick) Title:nil];
    headerImageButton.backgroundColor=[UIColor whiteColor];
    //button切圆角
    headerImageButton.layer.cornerRadius=8;
    headerImageButton.layer.masksToBounds=YES;
    [self.view addSubview:headerImageButton];
    
    //生日的界面
    birthdayView=[ZCControl viewWithFrame:CGRectMake(0, 194, WIDTH, 40)];
    birthdayView.backgroundColor=[UIColor whiteColor];
    [self.view addSubview:birthdayView];
    //设置生日图片
    birthdayImageView=[ZCControl createImageViewWithFrame:CGRectMake(20, 10, 20, 20) ImageName:@"icon_register_birthday.png"];
    [birthdayView addSubview:birthdayImageView];
    //设置生日的label
    birthdayLabel=[ZCControl createLabelWithFrame:CGRectMake(60, 10, 200, 20) Font:10 Text:@"请选择你的生日"];
    birthdayLabel.textColor=[UIColor grayColor];
    [birthdayView addSubview:birthdayLabel];
    //设置右边的箭头
    birthdayRightImageView=[ZCControl createImageViewWithFrame:CGRectMake(WIDTH-50,10 , 20, 20) ImageName:@"btn_forward_disabled.png"];
    [birthdayView addSubview:birthdayRightImageView];
    //增加点击事件
    birthdayControl=[[UIControl alloc]initWithFrame:CGRectMake(0, 0, WIDTH, 40)];
    [birthdayControl addTarget:self action:@selector(birthdayClick) forControlEvents:UIControlEventTouchUpInside];
    [birthdayView addSubview:birthdayControl];
    
//性别
    sexView=[ZCControl viewWithFrame:CGRectMake(0, 235, WIDTH, 40)];
    sexView.backgroundColor=[UIColor whiteColor];
    [self.view addSubview:sexView];
    
    sexImageView=[ZCControl createImageViewWithFrame:CGRectMake(20, 10, 20, 20) ImageName:@"icon_register_gender.png"];
    [sexView addSubview:sexImageView];
    
    sexLabel=[ZCControl createLabelWithFrame:CGRectMake(60, 10, 200, 20) Font:10 Text:@"请选择性别"];
    sexLabel.textColor=[UIColor grayColor];
    [sexView addSubview:sexLabel];
    
    sexRightImageView=[ZCControl createImageViewWithFrame:CGRectMake(WIDTH-50, 10, 20, 20) ImageName:@"btn_forward_disabled.png"];
    [sexView addSubview:sexRightImageView];
    
    sexControl=[[UIControl alloc]initWithFrame:CGRectMake(0, 0, WIDTH, 40)];
    [sexControl addTarget:self action:@selector(sexClick) forControlEvents:UIControlEventTouchUpInside];
    [sexView addSubview:sexControl];
    
    
    UILabel*infoLabel=[ZCControl createLabelWithFrame:CGRectMake(20, 280, WIDTH, 20) Font:10 Text:@"性别选择后，不允许修改，请谨慎操作"];
    infoLabel.textColor=[UIColor grayColor];
    [self.view addSubview:infoLabel];
    
  

}
#pragma mark 选择性别
-(void)sexClick{
    UIActionSheet*sheet=[[UIActionSheet alloc]initWithTitle:@"请选择性别" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"男",@"女", nil];
    sheet.tag=200;
    [sheet showInView:self.view];

}
#pragma mark 点击手势
-(void)tapClick{
    if (_dataPicker.frame.origin.y!=HEIGHT) {
        [UIView animateWithDuration:0.3 animations:^{
            _dataPicker.frame=CGRectMake(0, HEIGHT, WIDTH, 216);
        }];
        
    }

}
#pragma mark 选择生日
-(void)birthdayClick{
    
    if (_dataPicker) {
        //移动坐标
        [UIView  animateWithDuration:0.3 animations:^{
            _dataPicker.frame=CGRectMake(0, HEIGHT-216, WIDTH, 216);
        }];
    }else{
        _dataPicker=[[UIDatePicker alloc]initWithFrame:CGRectMake(0, HEIGHT, WIDTH, 216)];
        //设置日期最大值
        [_dataPicker setMaximumDate:[NSDate date]];
        //设置最小值
        NSDateFormatter*formatter=[[NSDateFormatter alloc]init];
        [formatter setDateFormat:@"yyyy-MM-dd"];
        NSDate*minDate=[formatter dateFromString:@"1920-01-01"];
        [_dataPicker setMinimumDate:minDate];
        //设置滚筒模式
        _dataPicker.datePickerMode=UIDatePickerModeDate;
        //添加触发事件
        [_dataPicker addTarget:self action:@selector(datePickerClick:) forControlEvents:UIControlEventValueChanged];
        [self.view addSubview:_dataPicker];
        [UIView animateWithDuration:0.3 animations:^{
            _dataPicker.frame=CGRectMake(0, HEIGHT-216, WIDTH, 216);
        }];
        
    
    }
    

}
#pragma mark 日期滚筒触发方式
-(void)datePickerClick:(UIDatePicker*)picker
{
    NSDate*date=picker.date;
    NSDateFormatter*formatter=[[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    birthdayLabel.text=[formatter stringFromDate:date];
    RegisterManager*manager=[RegisterManager shareManager];
    manager.birthday=birthdayLabel.text;
}
#pragma mark 选择相机相册
-(void)headerImageButtonClick{
    UIActionSheet*sheet=[[UIActionSheet alloc]initWithTitle:@"提示" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"相机",@"相册", nil];
    sheet.tag=100;
    [sheet showInView:self.view];

}
-(void)createNav{
    UIButton*rightButton=[ZCControl createButtonWithFrame:CGRectMake(0, 0, 60, 30) ImageName:nil Target:self Action:@selector(rightClick) Title:@"下一步"];
    self.navigationItem.rightBarButtonItem=[[UIBarButtonItem alloc]initWithCustomView:rightButton];
    

}
#pragma mark 右按钮
-(void)rightClick{
    
    
    RegisterViewController3*vc=[[RegisterViewController3 alloc]init];
    vc.title=@"登陆信息（3/4）";
    [self.navigationController pushViewController:vc animated:YES];

}
#pragma mark UIActionSheetDelegate
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex==2) {
        //取消按钮
        return;
    }
    if (actionSheet.tag==100) {
        //相机相册的选择
        UIImagePickerController*picker=[[UIImagePickerController alloc]init];
        picker.delegate=self;
        if (buttonIndex==0) {
            //相机
            if ([UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceFront]) {
                picker.sourceType=UIImagePickerControllerSourceTypeCamera;
            }
            
        }
        
        [self presentViewController:picker animated:YES completion:nil];
        
        
    }else{
        if (buttonIndex) {
            //女
            sexLabel.text=@"女";
            sexImageView.image=[UIImage imageNamed:@"icon_register_woman.png"];
        }else{
            //男
            sexLabel.text=@"男";
            sexImageView.image=[UIImage imageNamed:@"icon_register_man.png"];
            
        }
        RegisterManager*manager=[RegisterManager shareManager];
        manager.sex=sexLabel.text;
        
    
    }

}
#pragma mark UIImagePickerControllerDelegate

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    //获取image
    UIImage*image=[info objectForKey:UIImagePickerControllerOriginalImage];
    [headerImageButton setBackgroundImage:image forState:UIControlStateNormal];
    //用于记录修改过
    isHeaderImage=YES;
    RegisterManager*manager=[RegisterManager shareManager];
    manager.headerImage=image;
    
    [self dismissViewControllerAnimated:YES completion:nil];
}
-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self dismissViewControllerAnimated:YES completion:nil];
}


-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self tapClick];
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
