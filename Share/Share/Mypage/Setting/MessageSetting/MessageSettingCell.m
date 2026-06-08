//
//  MessageSettingCell.m
//  Share
//
//  Created by lose_sea on 2026/6/8.
//

#import "MessageSettingCell.h"

@implementation MessageSettingCell
- (instancetype) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setUpInterface];
        [self configWithMessage: self.message];
    }
    return self;
}

- (void)setUpInterface {
    self.messageLabel = [[UILabel alloc] init];
    self.selectButton = [UIButton buttonWithType: UIButtonTypeCustom];
    
    [self.contentView addSubview: self.messageLabel];
    [self.messageLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.contentView).offset(20);
        make.top.mas_equalTo(self.contentView).offset(5);
        make.bottom.mas_equalTo(self.contentView).offset(-5);
        make.width.mas_equalTo(150);
    }];
    
    
    [self.contentView addSubview: self.selectButton];
    [self.selectButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.contentView);
        make.width.height.mas_equalTo(40);
        make.right.mas_equalTo(self.contentView).offset(-50);
    }];
    
    [self.selectButton setImage: [UIImage systemImageNamed: @"checkmark.rectangle.fill"]
                       forState: UIControlStateNormal];
    
    [self.selectButton addTarget: self action: @selector(pressSelectButton) forControlEvents: UIControlEventTouchUpInside];
}

- (void) pressSelectButton {
    self.message.isSelected = !self.message.isSelected;
    [self configWithMessage: self.message]; 
}

- (void) configWithMessage:(Message *)message {
    self.messageLabel.text = message.name; 
    if (message.isSelected == NO) {
        self.selectButton.tintColor = [UIColor systemGrayColor];
    } else {
        self.selectButton.tintColor = [UIColor systemCyanColor];
    }
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
