//
//  TalkView.m
//  Share
//
//  Created by lose_sea on 2026/6/3.
//

#import "TalkView.h"

@implementation TalkView
- (instancetype) init {
    self = [super init];
    if (self) {
        [self setUpTableView];
        [self setUpTextView];
        [self setUpSendButton];
    }
    return self; 
}

- (void)setUpTableView {
    self.tableView = [[UITableView alloc] init];
    self.tableView.backgroundColor = [UIColor whiteColor];
    
    // 删除cell之间的分割线
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [self addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self);
        make.bottom.equalTo(self).offset(-50);
    }];
    [self.tableView registerClass:[TalkCell class] forCellReuseIdentifier:@"TalkCellID"];
}

- (void)setUpTextView {
    self.textView = [[UITextView alloc] init];
    self.textView.backgroundColor = [UIColor lightGrayColor];
    [self addSubview:self.textView];
    [self.textView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.tableView.mas_bottom).offset(10);
        make.height.mas_greaterThanOrEqualTo(40);
        make.left.mas_equalTo(self).offset(30);
        make.right.mas_equalTo(self).offset(-100);
    }];
    self.textView.backgroundColor = [UIColor systemBackgroundColor];

    
    self.textView.layer.borderWidth = 1.0;
    self.textView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.textView.layer.cornerRadius = 8.0;
    self.textView.layer.masksToBounds = YES;
    
    self.textView.font = [UIFont systemFontOfSize: 16];
}


- (void) setUpSendButton {
    self.sendButton = [UIButton buttonWithType: UIButtonTypeSystem];
    [self addSubview: self.sendButton];
    [self.sendButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.mas_equalTo(self.textView);
        make.left.mas_equalTo(self.textView.mas_right).offset(10);
        make.right.mas_equalTo(self).offset(-10);
    }];
    
    [self.sendButton setTitle: @"发送" forState: UIControlStateNormal];
    self.sendButton.backgroundColor = [UIColor systemCyanColor];
    self.sendButton.tintColor = [UIColor labelColor];
    
    self.sendButton.layer.masksToBounds = YES;
    self.sendButton.layer.cornerRadius = 8;
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
