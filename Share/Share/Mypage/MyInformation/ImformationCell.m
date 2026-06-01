//
//  ImformationCell.m
//  Share
//
//  Created by lose_sea on 2026/6/1.
//

#import "ImformationCell.h"

@implementation ImformationCell

- (instancetype) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.label = [[UILabel alloc] init];
        self.label.textAlignment = NSTextAlignmentCenter;
        self.label.font = [UIFont systemFontOfSize: 12];
        self.label.backgroundColor = [UIColor systemRedColor];
        
        self.label.layer.cornerRadius = 10;
        [self.contentView addSubview: self.label];
        [self.label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.contentView).offset(5);
            make.bottom.mas_equalTo(self.contentView).offset(-5);
            make.left.mas_equalTo(self.contentView.mas_right).offset(-40);
        }];
    }
    return self;
}


- (void) configWithInformation:(Information *)information {
    self.textLabel.text = information.name;
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
