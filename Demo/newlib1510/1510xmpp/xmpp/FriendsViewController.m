//
//  FriendsViewController.m
//  xmpp
//
//  Created by 张广洋 on 15/10/13.
//  Copyright © 2015年 张广洋. All rights reserved.
//

#import "FriendsViewController.h"

#import "XMPPManager.h"

#import "SayViewController.h"

@interface FriendsViewController ()
{
    NSMutableArray * _friendsArr;
    int num;
}
@end

@implementation FriendsViewController

- (void)viewDidLoad {
    NSLog(@"%@",[[XMPPManager share]getFriends]);
    _friendsArr =[[NSMutableArray alloc]init];
    [_friendsArr addObjectsFromArray:[[XMPPManager share]getFriends]];
    for (XMPPUserCoreDataStorageObject * oneObject in _friendsArr) {
        NSLog(@"jidStr:%@",oneObject.jidStr);
        NSLog(@"nickname:%@",oneObject.nickname);
        NSLog(@"displayname:%@",oneObject.displayName);
        NSLog(@"photo:%@",oneObject.photo);
    }
    
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _friendsArr.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell * cell=[tableView dequeueReusableCellWithIdentifier:@"xxxx" forIndexPath:indexPath];
    XMPPUserCoreDataStorageObject * oneFriend=_friendsArr[indexPath.row];
    cell.textLabel.text=oneFriend.jidStr;
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    num=indexPath.row;
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([segue.identifier isEqualToString:@"say"]) {
        SayViewController * sayV= segue.destinationViewController;
        XMPPUserCoreDataStorageObject * oneFriend=_friendsArr[num];
        NSLog(@"%@",oneFriend.jidStr);
        sayV.jidStr=oneFriend.jidStr;
    }
}

- (IBAction)back:(id)sender {
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}

@end
