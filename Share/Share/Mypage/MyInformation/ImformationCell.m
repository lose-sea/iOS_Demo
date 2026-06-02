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
        self.label.font = [UIFont systemFontOfSize: 14];
        self.label.backgroundColor = [UIColor systemRedColor];
        
        self.label.layer.masksToBounds = YES;
        self.label.layer.cornerRadius = 10;
        
        self.label.textColor = [UIColor systemBackgroundColor]; 
        
        [self.contentView addSubview: self.label];
        [self.label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.contentView).offset(15);
            make.bottom.mas_equalTo(self.contentView).offset(-15);
            make.left.mas_equalTo(self.contentView.mas_right).offset(-30);
            make.width.mas_equalTo(20);
        }];
        self.label.text = [NSString stringWithFormat: @"%ld", (long)self.information.count];
        
        self.label.hidden = YES;
        
    }
    return self;
}


- (void) configWithInformation:(Information *)information {
    self.textLabel.text = information.name;
    self.label.text = [NSString stringWithFormat: @"%ld", self.information.count]; 
    if (self.information != nil && self.information.count > 0) {
        self.label.hidden = NO;
    } else {
        self.label.hidden = YES;
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
