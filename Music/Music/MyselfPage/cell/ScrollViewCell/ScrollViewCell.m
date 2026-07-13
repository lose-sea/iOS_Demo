//
//  ScrollViewCell.m
//  Music
//
//  Created by lose_sea on 2026/7/12.
//

#import "ScrollViewCell.h"

@implementation ScrollViewCell

- (instancetype) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setUpInterface];
        [self setUpSubTableView];
    }
    return self;
}

- (void)setUpInterface {
    self.scrollView = [[UIScrollView alloc] init];
    [self.contentView addSubview: self.scrollView];
    [self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.contentView);
    }];
    self.scrollView.scrollEnabled = YES;
    self.scrollView.pagingEnabled = YES;
    
}

- (void) setUpSubTableView {
    self.musicTableView = [[UITableView alloc] init];
    [self.scrollView addSubview: self.musicTableView];
    [self.musicTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.equalTo(self.scrollView);
        make.width.equalTo(self.contentView);
        make.height.equalTo(self.contentView);
    }];
    
    
    self.musicTableView.tag = 101;
    [self.musicTableView registerClass: [PlayListCell class] forCellReuseIdentifier: @"MusicCellID"];
    
    
    self.playTableView = [[UITableView alloc] init];
    [self.scrollView addSubview: self.playTableView];
    [self.playTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.musicTableView.mas_right);
        make.top.equalTo(self.musicTableView);
        make.width.equalTo(self.contentView);
        make.height.equalTo(self.contentView);
    }];
    self.playTableView.tag = 102;
    [self.playTableView registerClass: [PlayListCell class] forCellReuseIdentifier: @"playTableCellID"];
    
    self.musicTableView.scrollEnabled = NO;
    self.playTableView.scrollEnabled = NO;
    
    
    
    self.noteView = [[UIView alloc] init];
    [self.scrollView addSubview: self.noteView];
    [self.noteView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.playTableView.mas_right);
        make.top.mas_equalTo(self.playTableView);
        make.width.height.mas_equalTo(self.contentView);
    }];
    UIView* view = [[UIView alloc] init];
    [self.noteView addSubview: view];
    [view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.mas_equalTo(self.noteView);
        make.height.mas_equalTo(60);
    }];
    
//    view.backgroundColor = [UIColor systemCyanColor];
    
    UIButton* button = [UIButton buttonWithType: UIButtonTypeCustom];
    button.tintColor = [[UIColor systemRedColor] colorWithAlphaComponent: 0.6];
    [view addSubview: button];
    [button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(view).offset(5);
        make.bottom.mas_equalTo(view).offset(-5);
        make.left.mas_equalTo(view).offset(20);
        make.width.height.mas_equalTo(50);
    }];
    
    UIImageSymbolConfiguration* config = [UIImageSymbolConfiguration configurationWithPointSize: 50];
    UIImage* image = [UIImage systemImageNamed: @"play.circle.fill" withConfiguration: config];
    [button setImage: image forState: UIControlStateNormal];
    button.layer.cornerRadius = 25;
    button.clipsToBounds = YES;
    
    UILabel* playLabel = [[UILabel alloc] init];
    [view addSubview: playLabel];
    [playLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(button.mas_right).offset(20);
        make.top.height.mas_equalTo(button);
        make.width.mas_equalTo(200);
    }];
    playLabel.text = @"播放全部";
    playLabel.font = [UIFont boldSystemFontOfSize: 17];
    playLabel.textColor = [UIColor systemGrayColor];
    
    UIButton* menuButton = [UIButton buttonWithType: UIButtonTypeCustom];
    [view addSubview: menuButton];
    [menuButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(view.mas_right).offset(-60);
        make.top.mas_equalTo(button).offset(10);
        make.width.height.mas_equalTo(40);
    }];
    [menuButton setImage: [UIImage systemImageNamed: @"square.grid.2x2"] forState: UIControlStateNormal];
    menuButton.tintColor = [UIColor systemGrayColor];
    
    UILabel* label = [[UILabel alloc] init];
    [self.noteView addSubview: label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.noteView);
        make.width.mas_equalTo(250);
        make.height.mas_equalTo(20);
        make.top.mas_equalTo(view.mas_bottom).offset(50);
    }];
    label.text = @"暂无笔记, 分享你的音乐生活吧";
    label.textAlignment = NSTextAlignmentCenter; 
    label.textColor = [UIColor systemGrayColor];
    label.font = [UIFont systemFontOfSize: 15];
    
    

}

- (void)layoutSubviews {
    [super layoutSubviews];
    CGFloat width = self.contentView.bounds.size.width;
    CGFloat height = self.contentView.bounds.size.height;
    self.scrollView.contentSize = CGSizeMake(width * 3,  height);
}







- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
