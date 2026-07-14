//
//  SongListView.m
//  Music
//
//  Created by lose_sea on 2026/7/13.
//

#import "SongListView.h"

@implementation SongListView

- (instancetype) init {
    self = [super init];
    if (self) {
        [self setUpInterface]; 
    }
    return self;
}

- (void) setUpInterface {
    self.backgroundColor = [[UIColor systemGrayColor] colorWithAlphaComponent: 0.7];
    
    self.coverView = [[UIImageView alloc] init];
    self.nameLabel = [[UILabel alloc] init];
    self.authorLabel = [[UILabel alloc] init];
    self.playButton = [UIButton buttonWithType: UIButtonTypeCustom];
    self.shareButton = [UIButton buttonWithType: UIButtonTypeCustom];
    self.commentButton = [UIButton buttonWithType: UIButtonTypeCustom];
    self.tableView = [[UITableView alloc] init];
    self.playView = [[PlayView alloc] init];
    
    
    [self addSubview: self.coverView];
    [self.coverView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self).offset(150);
        make.left.mas_equalTo(self).offset(30);
        make.width.height.mas_equalTo(90);
    }];
    self.coverView.clipsToBounds = YES;
    self.coverView.layer.cornerRadius = 10;
    
    [self addSubview: self.nameLabel];
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.coverView).offset(-10);
        make.left.mas_equalTo(self.coverView.mas_right).offset(20);
        make.right.mas_equalTo(self).offset(-20);
    }];
    self.nameLabel.font = [UIFont boldSystemFontOfSize: 19];
//    self.nameLabel.textAlignment = NSTextAlignmentCenter;
    self.nameLabel.numberOfLines = 0;
//    self.coverView.backgroundColor = [UIColor systemRedColor];
    
    [self addSubview: self.authorLabel];
    [self.authorLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.nameLabel);
        make.top.mas_equalTo(self.nameLabel.mas_bottom).offset(5);
        make.right.mas_equalTo(self).offset(-20);
        make.height.mas_equalTo(30);
    }];
    self.authorLabel.textColor = [UIColor systemGrayColor];
    
    [self addSubview: self.playButton];
    [self.playButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.coverView);
        make.top.mas_equalTo(self.coverView.mas_bottom).mas_equalTo(20);
        make.width.mas_equalTo(100);
        make.height.mas_equalTo(40);
    }];
    [self.playButton setImage:[UIImage systemImageNamed: @"play.circle.fill"] forState: UIControlStateNormal];
    [self.playButton setTitle: @"播放全部" forState: UIControlStateNormal];
    [self.playButton setTitleColor: [UIColor labelColor] forState: UIControlStateNormal];
    self.playButton.backgroundColor = [UIColor colorWithWhite: 0.6 alpha: 0.4];
    self.playButton.tintColor = [UIColor systemRedColor];
    self.playButton.clipsToBounds = YES;
    self.playButton.layer.cornerRadius = 15;
//    self.playButton.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 10);    // 图片向右偏移10pt，即间距增大
//    self.playButton.titleEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0);    // 文字向左偏移10pt，两者之间多出20pt
    
    [self addSubview: self.shareButton];
    [self.shareButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.playButton.mas_right).offset(20);
        make.top.width.height.mas_equalTo(self.playButton);
    }];
    [self.shareButton setImage:[UIImage systemImageNamed: @"arrowshape.turn.up.right.fill"] forState: UIControlStateNormal];
    [self.shareButton setTitle: @"转发" forState: UIControlStateNormal];
    [self.shareButton setTitleColor: [UIColor labelColor] forState: UIControlStateNormal];
    self.shareButton.backgroundColor = [UIColor colorWithWhite: 0.6 alpha: 0.4];
    self.shareButton.tintColor = [UIColor labelColor];
    self.shareButton.clipsToBounds = YES;
    self.shareButton.layer.cornerRadius = 15;
    
    
    [self addSubview: self.commentButton];
    [self.commentButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.shareButton.mas_right).offset(20);
        make.top.width.height.mas_equalTo(self.shareButton);
    }];
    [self.commentButton setImage:[UIImage systemImageNamed: @"text.bubble.fill"] forState: UIControlStateNormal];
    [self.commentButton setTitle: @"评论" forState: UIControlStateNormal];
    [self.commentButton setTitleColor: [UIColor labelColor] forState: UIControlStateNormal];
    self.commentButton.backgroundColor = [UIColor colorWithWhite: 0.6 alpha: 0.4];
    self.commentButton.tintColor = [UIColor labelColor];
    self.commentButton.clipsToBounds = YES;
    self.commentButton.layer.cornerRadius = 15;
    
    
    [self addSubview: self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.playButton.mas_bottom).offset(30);
        make.left.right.bottom.mas_equalTo(self);
    }];
    self.tableView.layer.cornerRadius = 30;
    
    [self.tableView registerClass: [songCell class] forCellReuseIdentifier: @"SongCellID"];
    
    self.playView = [[PlayView alloc] init];
    [self addSubview: self.playView];
    [self.playView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.mas_bottom).offset(-20);
        make.left.mas_equalTo(self).offset(10);
        make.right.mas_equalTo(self).offset(-10);
        make.height.mas_equalTo(50);
    }];
    self.playView.backgroundColor = [[UIColor systemGrayColor] colorWithAlphaComponent: 0.6]; 
    
    self.playView.clipsToBounds = YES;
    self.playView.layer.cornerRadius = 25;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
