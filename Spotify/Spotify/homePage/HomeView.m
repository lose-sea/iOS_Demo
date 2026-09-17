////
////  HomeView.m
////  Spotify
////
////  Created by lose_sea on 2026/9/2.
////
//
//#import "HomeView.h"
//
//@implementation HomeView
//
///*
//// Only override drawRect: if you perform custom drawing.
//// An empty implementation adversely affects performance during animation.
//- (void)drawRect:(CGRect)rect {
//    // Drawing code
//}
//*/
//
//- (instancetype) init {
//    self = [super init];
//    if (self) {
//        [self setUpInterface];
//    }
//    return self;
//}
//
//
//- (void) setUpInterface {
//    
//}
//@end











//
//  HomeView.m
//  Spotify
//
//  Created by lose_sea on 2026/9/2.
//

#import "HomeView.h"

@implementation HomeView

- (instancetype)init {
    self = [super init];
    if (self) {
        [self setUpInterface];
    }
    return self;
}

- (void)setUpInterface {
    self.backgroundColor = [UIColor systemBackgroundColor];

    // tableView
    self.tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self addSubview:self.tableView];

    // mini player
    self.miniPlayerView = [[UIView alloc] init];
    self.miniPlayerView.backgroundColor = [UIColor secondarySystemBackgroundColor];
    self.miniPlayerView.layer.cornerRadius = 8;
    self.miniPlayerView.clipsToBounds = YES;
    [self addSubview:self.miniPlayerView];

    // cover
    self.playerCoverView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"cover.jpg"]];
    self.playerCoverView.contentMode = UIViewContentModeScaleAspectFill;
    self.playerCoverView.clipsToBounds = YES;
    self.playerCoverView.layer.cornerRadius = 6;
    [self.miniPlayerView addSubview:self.playerCoverView];

    // labels
    self.playerTitleLabel = [[UILabel alloc] init];
    self.playerTitleLabel.font = [UIFont boldSystemFontOfSize:14];
    self.playerTitleLabel.textColor = [UIColor labelColor];
    self.playerTitleLabel.text = @"Song Title";
    [self.miniPlayerView addSubview:self.playerTitleLabel];

    self.playerArtistLabel = [[UILabel alloc] init];
    self.playerArtistLabel.font = [UIFont systemFontOfSize:12];
    self.playerArtistLabel.textColor = [UIColor secondaryLabelColor];
    self.playerArtistLabel.text = @"Artist";
    [self.miniPlayerView addSubview:self.playerArtistLabel];

    // play button
    self.playerPlayButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [self.playerPlayButton setImage:[UIImage systemImageNamed:@"play.fill"] forState:UIControlStateNormal];
    self.playerPlayButton.tintColor = [UIColor labelColor];
    [self.miniPlayerView addSubview:self.playerPlayButton];

    // Masonry 布局
    [self.miniPlayerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(12);
        make.right.equalTo(self).offset(-12);
        make.bottom.equalTo(self).offset(-12);
        make.height.mas_equalTo(64);
    }];

    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self);
        make.bottom.equalTo(self.miniPlayerView.mas_top).offset(-12);
    }];

    [self.playerCoverView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.miniPlayerView).offset(8);
        make.centerY.equalTo(self.miniPlayerView);
        make.width.height.mas_equalTo(48);
    }];

    [self.playerPlayButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.miniPlayerView).offset(-8);
        make.centerY.equalTo(self.miniPlayerView);
        make.width.height.mas_equalTo(36);
    }];

    [self.playerTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.playerCoverView.mas_right).offset(8);
        make.top.equalTo(self.playerCoverView);
        make.right.equalTo(self.playerPlayButton.mas_left).offset(-8);
    }];

    [self.playerArtistLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.playerTitleLabel);
        make.top.equalTo(self.playerTitleLabel.mas_bottom).offset(2);
        make.right.equalTo(self.playerTitleLabel);
    }];

    // 注册一个通用 cell（Controller 会负责填充数据）
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"HomeSimpleCell"];
}

@end
