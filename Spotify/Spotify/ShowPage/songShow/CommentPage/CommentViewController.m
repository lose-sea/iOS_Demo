//
//  CommentViewController.m
//  Spotify
//
//  Created by lose_sea on 2026/10/4.
//

#import "CommentViewController.h"
#import "CommentModel.h"
#import "CommentView.h"
#import "NeteaseService.h"
#import <Masonry/Masonry.h>

static const NSInteger kPageSize = 20;

@interface CommentViewController () <UITableViewDataSource, UITableViewDelegate, CommentViewDelegate, UITextFieldDelegate>

@property (nonatomic, copy) NSString *songId;
@property (nonatomic, copy) NSString *songName;

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIView *inputBar;
@property (nonatomic, strong) UITextField *inputField;
@property (nonatomic, strong) UIButton *sendButton;
@property (nonatomic, strong) NSMutableArray<CommentModel *> *comments;
/// 头部热评，单独一段
@property (nonatomic, strong) NSMutableArray<CommentModel *> *hotComments;

@property (nonatomic, assign) NSInteger page;
/// total 用于标题「评论 (N)」
@property (nonatomic, assign) NSInteger total;
@property (nonatomic, assign) BOOL more;
@property (nonatomic, assign) BOOL isLoading;

/// 当前正在回复的评论（nil 表示发表一级评论）
@property (nonatomic, weak) CommentModel *replyTarget;

@end

@implementation CommentViewController

- (instancetype)initWithSongId:(NSString *)songId songName:(NSString *)songName {
    self = [super init];
    if (self) {
        _songId = [songId copy];
        _songName = [songName copy];
        _comments = [NSMutableArray array];
        _hotComments = [NSMutableArray array];
        _page = 0;
        _more = YES;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor systemBackgroundColor];
    [self setUpNavBar];
    [self setUpInputBar];   // 必须在 setUpTableView 之前：tableView 底部要钉到 inputBar.mas_top
    [self setUpTableView];
    [self setUpKeyboardObservers];

    [self fetchComments];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - 顶部导航栏

- (void)setUpNavBar {
    self.titleLabel = [[UILabel alloc] init];
    self.titleLabel.font = [UIFont systemFontOfSize:16 weight:UIFontWeightSemibold];
    self.titleLabel.text = @"评论";
    self.titleLabel.textAlignment = NSTextAlignmentCenter;

    UIButton *closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [closeButton setImage:[UIImage systemImageNamed:@"xmark"] forState:UIControlStateNormal];
    [closeButton addTarget:self action:@selector(pressClose) forControlEvents:UIControlEventTouchUpInside];
    closeButton.tintColor = [UIColor labelColor];

    UIView *bar = [[UIView alloc] init];
    [bar addSubview:self.titleLabel];
    [bar addSubview:closeButton];
    [self.view addSubview:bar];

    [bar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_safeAreaLayoutGuideTop);
        make.left.right.equalTo(self.view);
        make.height.mas_equalTo(44);
    }];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(bar);
    }];
    [closeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(bar).offset(-12);
        make.centerY.equalTo(bar);
        make.size.mas_equalTo(CGSizeMake(32, 32));
    }];
    // 分隔线
    UIView *line = [[UIView alloc] init];
    line.backgroundColor = [UIColor separatorColor];
    [bar addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(bar);
        make.height.mas_equalTo(0.5);
    }];
}

#pragma mark - 列表

- (void)setUpTableView {
    self.tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.estimatedRowHeight = 120;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    [self.tableView registerClass:CommentView.class forCellReuseIdentifier:@"CommentView"];
    [self.view addSubview:self.tableView];

    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_safeAreaLayoutGuideTop).offset(44);
        make.left.right.equalTo(self.view);
        make.bottom.equalTo(self.inputBar.mas_top);
    }];
}

- (void)setUpInputBar {
    self.inputBar = [[UIView alloc] init];
    self.inputBar.backgroundColor = [UIColor secondarySystemBackgroundColor];

    self.inputField = [[UITextField alloc] init];
    self.inputField.borderStyle = UITextBorderStyleRoundedRect;
    self.inputField.placeholder = @"说点什么...";
    self.inputField.font = [UIFont systemFontOfSize:14];
    self.inputField.delegate = self;
    self.inputField.returnKeyType = UIReturnKeySend;

    self.sendButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.sendButton setTitle:@"发送" forState:UIControlStateNormal];
    [self.sendButton setTitleColor:[UIColor systemBlueColor] forState:UIControlStateNormal];
    self.sendButton.titleLabel.font = [UIFont systemFontOfSize:15 weight:UIFontWeightMedium];
    [self.sendButton addTarget:self action:@selector(pressSend) forControlEvents:UIControlEventTouchUpInside];

    [self.inputBar addSubview:self.inputField];
    [self.inputBar addSubview:self.sendButton];
    [self.view addSubview:self.inputBar];

    [self.inputBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.bottom.equalTo(self.view.mas_safeAreaLayoutGuideBottom);
        make.height.mas_equalTo(52);
    }];
    [self.inputField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.inputBar).offset(12);
        make.top.equalTo(self.inputBar).offset(8);
        make.bottom.equalTo(self.inputBar).offset(-8);
        make.right.equalTo(self.sendButton.mas_left).offset(-8);
    }];
    [self.sendButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.inputBar).offset(-12);
        make.centerY.equalTo(self.inputBar);
    }];
}

#pragma mark - 键盘

- (void)setUpKeyboardObservers {
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillChangeFrameNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
}

- (void)keyboardWillShow:(NSNotification *)note {
    CGRect frame = [note.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGFloat kbH = frame.size.height;
    CGFloat safeBottom = self.view.safeAreaInsets.bottom;
    [self updateInputBarOffset:-(kbH - safeBottom)];
}

- (void)keyboardWillHide:(NSNotification *)note {
    [self updateInputBarOffset:0];
}

/// 用 Masonry 的 update 约束改 inputBar 底部偏移（上移以避开键盘）
- (void)updateInputBarOffset:(CGFloat)offset {
    [self.inputBar mas_updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.view.mas_safeAreaLayoutGuideBottom).offset(offset);
    }];
    [UIView animateWithDuration:0.25 animations:^{
        [self.view layoutIfNeeded];
    }];
}

#pragma mark - 数据

- (void)fetchComments {
    if (self.isLoading || !self.more) return;
    self.isLoading = YES;

    __weak typeof(self) weakSelf = self;
    [[NeteaseService sharedInstance] fetchCommentsWithId:self.songId
                                                    page:self.page
                                              sortNewest:NO
                                              completion:^(NSArray<CommentModel *> *hot,
                                                           NSArray<CommentModel *> *comments,
                                                           NSInteger total,
                                                           BOOL more,
                                                           NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            weakSelf.isLoading = NO;
            if (error) {
                NSLog(@"评论加载失败: %@", error.localizedDescription);
                // 失败也至少展示标题
                [weakSelf updateTitle];
                return;
            }
            if (weakSelf.page == 0) {
                [weakSelf.hotComments removeAllObjects];
                [weakSelf.hotComments addObjectsFromArray:hot];
                [weakSelf.comments removeAllObjects];
                weakSelf.total = total;
            }
            [weakSelf.comments addObjectsFromArray:comments];
            weakSelf.more = more;
            weakSelf.page += 1;
            [weakSelf updateTitle];
            [weakSelf.tableView reloadData];
        });
    }];
}

- (void)updateTitle {
    if (self.total > 0) {
        self.titleLabel.text = [NSString stringWithFormat:@"评论 (%@)", [CommentModel shortCount:self.total]];
    } else {
        self.titleLabel.text = @"评论";
    }
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2; // 0: 热评  1: 全部
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return section == 0 ? self.hotComments.count : self.comments.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CommentView *cell = [tableView dequeueReusableCellWithIdentifier:@"CommentView" forIndexPath:indexPath];
    cell.delegate = self;
    CommentModel *model = indexPath.section == 0
        ? self.hotComments[indexPath.row]
        : self.comments[indexPath.row];
    [cell configureWithComment:model];
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if (section == 0 && self.hotComments.count > 0) return @"热门评论";
    if (section == 1 && self.comments.count > 0) return @"最新评论";
    return nil;
}

- (void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section {
    if ([view isKindOfClass:UITableViewHeaderFooterView.class]) {
        UITableViewHeaderFooterView *hv = (UITableViewHeaderFooterView *)view;
        hv.textLabel.font = [UIFont systemFontOfSize:13 weight:UIFontWeightSemibold];
        hv.textLabel.textColor = [UIColor secondaryLabelColor];
    }
}

#pragma mark - 上拉加载更多

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat offsetY = scrollView.contentOffset.y;
    CGFloat contentH = scrollView.contentSize.height;
    CGFloat height = scrollView.frame.size.height;
    if (offsetY > contentH - height - 200 && self.more && !self.isLoading) {
        [self fetchComments];
    }
}

#pragma mark - CommentViewDelegate

- (void)commentView:(CommentView *)view didTapLike:(CommentModel *)comment {
    // 本地乐观切换（真实点赞需要登录态 cookie，Demo 里只改本地模型）
    comment.liked = !comment.liked;
    comment.likedCount += comment.liked ? 1 : -1;
    if (comment.likedCount < 0) comment.likedCount = 0;
    [self reloadCellForComment:comment];
}

- (void)commentView:(CommentView *)view didTapReply:(CommentModel *)comment {
    self.replyTarget = comment;
    self.inputField.placeholder = [NSString stringWithFormat:@"回复 @%@：", comment.nickname ?: @""];
    [self.inputField becomeFirstResponder];
}

- (void)commentView:(CommentView *)view didToggleExpand:(CommentModel *)comment {
    comment.isExpanded = !comment.isExpanded;
    [self reloadCellForComment:comment];
}

/// 根据 comment 对象找到所在 indexPath 并只刷新那一行（保留展开态 / 点赞态）
- (void)reloadCellForComment:(CommentModel *)comment {
    NSIndexPath *ip = [self indexPathForComment:comment];
    if (ip) {
        [self.tableView reloadRowsAtIndexPaths:@[ip] withRowAnimation:UITableViewRowAnimationAutomatic];
    }
}

- (NSIndexPath *)indexPathForComment:(CommentModel *)comment {
    NSInteger row = [self.hotComments indexOfObject:comment];
    if (row != NSNotFound) return [NSIndexPath indexPathForRow:row inSection:0];
    row = [self.comments indexOfObject:comment];
    if (row != NSNotFound) return [NSIndexPath indexPathForRow:row inSection:1];
    return nil;
}

#pragma mark - 发送

- (void)pressSend {
    NSString *text = [self.inputField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    if (text.length == 0) return;

    CommentModel *newComment = [[CommentModel alloc] init];
    newComment.commentId = [NSString stringWithFormat:@"local_%ld", (long)arc4random()];
    newComment.userId = @"me";
    newComment.nickname = @"我";
    newComment.avatarURL = nil;
    newComment.content = text;
    newComment.likedCount = 0;
    newComment.liked = NO;
    newComment.time = (long long)([[NSDate date] timeIntervalSince1970] * 1000);
    newComment.isMine = YES;

    if (self.replyTarget) {
        // 楼中楼回复：挂到目标评论的 replies 下
        NSMutableArray *arr = [self.replyTarget.replies mutableCopy] ?: [NSMutableArray array];
        [arr addObject:newComment];
        self.replyTarget.replies = [arr copy];
        self.replyTarget.isExpanded = YES;     // 发完自动展开，让用户看到自己发的
        [self reloadCellForComment:self.replyTarget];
        self.total += 1;
    } else {
        // 一级评论：插到最新评论顶部
        [self.comments insertObject:newComment atIndex:0];
        self.total += 1;
        [self.tableView reloadData];
    }

    [self updateTitle];
    self.inputField.text = @"";
    self.replyTarget = nil;
    self.inputField.placeholder = @"说点什么...";
    [self.inputField resignFirstResponder];
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [self pressSend];
    return YES;
}

#pragma mark - 关闭

- (void)pressClose {
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
