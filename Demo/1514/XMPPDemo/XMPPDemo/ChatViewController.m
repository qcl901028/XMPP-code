//
//  ChatViewController.m
//  XMPPDemo
//
//  Created by lzxuan on 15/11/9.
//  Copyright (c) 2015年 lzxuan. All rights reserved.
//

#import "ChatViewController.h"
#import "WFMessageModel.h"
#import "WFMessageFrame.h"
#import "WFChatMessageCell.h"
#import "XMPPManager.h"
#import <CoreData/CoreData.h>
@interface ChatViewController ()<UITableViewDelegate,UITextFieldDelegate, XMPPStreamDelegate>
@property (weak, nonatomic) IBOutlet UITextField *inoutTextField;
/**
 *  聊天TableView
 */
@property (weak, nonatomic) IBOutlet UITableView *tableView;
/**
 *  数据源数组
 */
@property (nonatomic, strong) NSMutableArray *messageArray;


@end

@implementation ChatViewController

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // 创建数据源 (初始化)
    self.view.backgroundColor = [UIColor colorWithRed:166/225.0 green:166/225.0 blue:166/225.0 alpha:1.0];
    _messageArray = [NSMutableArray new];
    self.automaticallyAdjustsScrollViewInsets = NO;
    _tableView.backgroundColor = [UIColor clearColor];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBoardWillShow:) name:UIKeyboardWillChangeFrameNotification object:nil];
    UIView *leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 8, 0)];
    _inoutTextField.leftView = leftView;
    _inoutTextField.leftViewMode = UITextFieldViewModeAlways;
    
    _inoutTextField.delegate = self;
    
    
    [[XMPPManager defautManager].xmppStream addDelegate:self delegateQueue:dispatch_get_main_queue()];
    [self reloadMessage];
    

    
}

- (void)xmppStream:(XMPPStream *)sender didSendMessage:(XMPPMessage *)message {
    [self reloadMessage];
}

- (void)xmppStream:(XMPPStream *)sender didFailToSendMessage:(XMPPMessage *)message error:(NSError *)error {
    
}
- (void)xmppStream:(XMPPStream *)sender didReceiveMessage:(XMPPMessage *)message {
    [self reloadMessage];
    
}

- (void)reloadMessage {
    //得到上下文
    NSManagedObjectContext *context = [[XMPPManager defautManager] messageArchivingContext];
    //搜索对象
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    //创建一个实体描述
    NSEntityDescription *description = [NSEntityDescription entityForName:@"XMPPMessageArchiving_Message_CoreDataObject" inManagedObjectContext:context];
    [request setEntity:description];
    //查询条件
    NSPredicate *pre = [NSPredicate predicateWithFormat:@"streamBareJidStr = %@ AND bareJidStr = %@",[XMPPManager defautManager].xmppStream.myJID.bare,_friendJID.bare];
    request.predicate = pre;
    //排序方式
    NSSortDescriptor *sort = [[NSSortDescriptor alloc] initWithKey:@"timestamp" ascending:YES];
    request.sortDescriptors = @[sort];
    NSError *error = nil;
    NSArray *array = [context executeFetchRequest:request error:&error];
    
    if (_messageArray.count != 0) {
        [_messageArray removeAllObjects];
    }
    NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
    fmt.dateFormat = @"HH:mm";

    for (XMPPMessageArchiving_Message_CoreDataObject *object in array) {
        WFMessageModel *model = [WFMessageModel new];
        model.text = object.message.body;
        model.time = [fmt stringFromDate:object.timestamp];
        model.type = object.isOutgoing == YES?WFMessageTypeMe:WFMessageTypeOther;
        
        WFMessageFrame *lastMessageFrame = [_messageArray lastObject];
        model.notShowTime = [lastMessageFrame.messageModel.time isEqualToString:model.time];
        
        WFMessageFrame *mf = [[WFMessageFrame alloc] init];
        mf.messageModel = model;

        [_messageArray addObject:mf];
        
        
    }
    
    [self.tableView reloadData];
    if (_messageArray.count) {
        [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:_messageArray.count - 1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
    }
    
    
}



- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    //    [textField resignFirstResponder];
    
    XMPPMessage *message = [XMPPMessage messageWithType:@"chat" to:_friendJID];
    [message addBody:textField.text];
    [[XMPPManager defautManager].xmppStream sendElement:message];
    
    textField.text = @"";
    return YES;
}

- (void)keyBoardWillShow:(NSNotification *)notification {
    
    NSDictionary *dict = [notification userInfo];
    CGRect keyBoardRect = [[dict objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    NSLog(@"%@",NSStringFromCGRect(keyBoardRect));
    // 设置窗口的颜色
    self.view.window.backgroundColor = self.tableView.backgroundColor;
    [UIView animateWithDuration:[[dict objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue] animations:^{
        self.view.transform = CGAffineTransformMakeTranslation(0, keyBoardRect.origin.y - self.view.frame.size.height);
    } completion:^(BOOL finished) {
        
    }];
    
    
}




- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.messageArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identtifer = @"identtifer";
    WFChatMessageCell *cell = [tableView dequeueReusableCellWithIdentifier:identtifer];
    if (cell == nil) {
        cell = [[WFChatMessageCell alloc] initWithStyle:UITableViewCellStyleValue2 reuseIdentifier:identtifer];
    }
    cell.messageFrame = self.messageArray[indexPath.row];
    
    NSLog(@"%f",[self.messageArray[indexPath.row] cellHeight]);
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [self.messageArray[indexPath.row] cellHeight];
    
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [self.view endEditing:YES];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.view endEditing:YES];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
