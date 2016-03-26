//
//  RootViewController.h
//  WeiChat
//
//  Created by 张诚 on 15/2/2.
//  Copyright (c) 2015年 zhangcheng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RootViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>
{
    UITableView*_tableView;

}
@property(nonatomic,strong)NSMutableArray*dataArray;
@property(nonatomic,copy)NSString*path;
-(void)createNotificationTheme;
@end
