//
//  TalkController.m
//  Share
//
//  Created by lose_sea on 2026/6/3.
//

#import "TalkController.h"

@interface TalkController ()

@end

@implementation TalkController
//  在载入了聊天界面的时候隐藏tabBar
- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = YES;
}

- (void) viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.tabBarController.tabBar.hidden = NO; 
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUpData]; 
    // Do any additional setup after loading the view.
    
    // 注册键盘通知
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(keyboardWillHide:)
                                                     name:UIKeyboardWillHideNotification
                                                   object:nil];
    
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyboard)];
    // 不取消其他触摸事件，让 cell 的点击仍然有效
    tap.cancelsTouchesInView = NO;
    [self.talkView.tableView addGestureRecognizer:tap];
}

- (void)dismissKeyboard {
    [self.view endEditing:YES];  // 收起键盘
}

- (void)keyboardWillShow:(NSNotification *)notification {
    // 获取键盘高度
    NSDictionary *userInfo = notification.userInfo;
    CGRect keyboardFrame = [userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGFloat keyboardHeight = keyboardFrame.size.height;
    
    self.talkView.frame = CGRectMake(0, -keyboardHeight, self.view.frame.size.width, self.view.frame.size.height);
    
}

- (void)keyboardWillHide:(NSNotification *)notification {
    
    self.talkView.frame = CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height);
}
- (void) setUpData {
    self.talkModel = [[TalkModel alloc] init];
    self.talkView = [[TalkView alloc] init];
    self.isMyself = NO;
    [self.view addSubview: self.talkView];
    [self.talkView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.view);
    }];
    
    self.user = [[Follower alloc] initWithUser: [[UserModel alloc] init]];
    
    self.talkView.tableView.delegate = self;
    self.talkView.tableView.dataSource = self;
    
    
    [self.talkView.sendButton addTarget: self action: @selector(pressSend) forControlEvents: UIControlEventTouchUpInside];
}

// 使tableView始终滚动到最底部
- (void)scrollToBottom {
    NSInteger rows = [self.talkView.tableView numberOfRowsInSection:0];
    if (rows == 0) return;
    NSIndexPath *lastPath = [NSIndexPath indexPathForRow:rows - 1 inSection:0];
    [self.talkView.tableView scrollToRowAtIndexPath:lastPath atScrollPosition:UITableViewScrollPositionBottom animated:YES];
}



- (void) pressSend {
    NSLog(@"点击了发送");
    if (self.talkView.textView.text.length > 0) {
        [self.talkModel.messages addObject: self.talkView.textView.text];

        [self.talkView.tableView reloadData];
        [self scrollToBottom];  // 滚动到底部
        self.talkView.textView.text = nil;
    }
}


- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.talkModel.messages.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath  {
    TalkCell* cell = [tableView dequeueReusableCellWithIdentifier: @"TalkCellID" forIndexPath: indexPath];
    if (indexPath.row % 2 == 0) {
        self.isMyself = NO;
        cell.user = self.other;
        [cell configWithFollower: self.other Message: self.talkModel.messages[indexPath.row] isMyself: NO];
    } else {
        self.isMyself = YES;
        cell.user = self.user;
        [cell configWithFollower: self.user Message: self.talkModel.messages[indexPath.row] isMyself: YES];
    }
    return cell;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [self.view endEditing: YES]; 
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath: indexPath animated: YES];
    [self.talkView endEditing: YES]; 
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
