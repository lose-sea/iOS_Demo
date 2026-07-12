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
    }
    return self;
}

- (void)setUpInterface {
    self.scrollView = [[UIScrollView alloc] init];
    [self.contentView addSubview: self.scrollView];
    [self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.contentView);
    }];

    self.scrollContentView = [[UIView alloc] init];
    [self.scrollView addSubview: self.scrollContentView];
    [self.scrollContentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.left.mas_equalTo(self.scrollView);
        make.width.mas_equalTo(self.scrollView).multipliedBy(3);
    }];
    
    self.musicTableView = [[UITableView alloc] init];
    [self.scrollContentView addSubview: self.musicTableView];
    [self.musicTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.scrollContentView);
        make.top.bottom.width.mas_equalTo(self.scrollView);
    }];
    self.musicTableView.tag = 101;
    [self.musicTableView registerClass: [PlayListCell class] forCellReuseIdentifier: @"MusicCellID"];
    
    
    self.playTableView = [[UITableView alloc] init];
    [self.scrollContentView addSubview: self.playTableView];
    [self.playTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.musicTableView.mas_right);
        make.top.bottom.width.mas_equalTo(self.scrollView);
    }];
    self.playTableView.tag = 102;
    [self.playTableView registerClass: [PlayListCell class] forCellReuseIdentifier: @"playTableCellID"];
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
