//
//  HomeView.m
//  Spotify
//
//  Created by lose_sea on 2026/9/2.
//

#import "HomeView.h"
#import <Masonry/Masonry.h>

/// 底部给全局 mini player 预留的高度
static const CGFloat kMiniPlayerReservedHeight = 64.0 + 24.0;

@interface HomeView ()

@property (nonatomic, strong, readwrite) UITableView *tableView;

@end

@implementation HomeView

- (instancetype)init {
    return [self initWithFrame:CGRectZero];
}

- (instancetype)initWithFrame:(CGRect)frame {
    if ((self = [super initWithFrame:frame])) {
        [self setUpInterface];
    }
    return self;
}

- (void)setUpInterface {
    self.backgroundColor = [UIColor systemBackgroundColor];

    self.tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    self.tableView.backgroundColor = [UIColor systemBackgroundColor];
    
    //  去掉cell之间的分隔细线
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    // 底部留白, 防止播放器将最后一行遮盖
    self.tableView.contentInset = UIEdgeInsetsMake(0, 0, kMiniPlayerReservedHeight, 0);
    
    // 给滚动条留白, 让滑动条不会滑倒最底部  
    self.tableView.scrollIndicatorInsets = self.tableView.contentInset;
    
//  iOS 15 起，UITableView 的 section header 上方默认有额外间距，这里把它设为 0。
    if (@available(iOS 15.0, *)) {
        self.tableView.sectionHeaderTopPadding = 0;
    }
    [self addSubview:self.tableView];

    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
}

@end
