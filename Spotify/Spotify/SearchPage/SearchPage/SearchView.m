//
//  SearchView.m
//  Spotify
//
//  Created by lose_sea on 2026/9/10.
//

#import "SearchView.h"
#import <Masonry/Masonry.h>

static const CGFloat kMiniPlayerReservedHeight = 64.0 + 24.0;

@interface SearchView ()

@property (nonatomic, strong, readwrite) UITableView *tableView;

@end

@implementation SearchView

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
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.contentInset = UIEdgeInsetsMake(0, 0, kMiniPlayerReservedHeight, 0);
    self.tableView.scrollIndicatorInsets = self.tableView.contentInset;
    if (@available(iOS 15.0, *)) {
        self.tableView.sectionHeaderTopPadding = 0;
    }
    [self addSubview:self.tableView];

    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
}

@end
