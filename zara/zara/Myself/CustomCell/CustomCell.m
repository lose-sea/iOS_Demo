//
//  CustomCell.m
//  
//
//  Created by lose_sea on 2026/5/12.
//

#import "CustomCell.h"

@implementation CustomCell

- (instancetype) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle: style reuseIdentifier: reuseIdentifier];
    if (self) {
        // 自定义视图 (圆形图片)
        self.avatarView = [[UIImageView alloc] init];
        self.avatarView.layer.cornerRadius = 25;
        // 裁剪
        self.avatarView.clipsToBounds = YES;
        self.avatarView.contentMode = UIViewContentModeScaleAspectFill;
        [self.contentView addSubview: self.avatarView];
        
        [self.avatarView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.contentView).offset(40);
            make.centerY.mas_equalTo(self.contentView);
            make.height.mas_equalTo(50);
            make.width.mas_equalTo(50);
        }];
        
        self.NickTextLabel = [[UILabel alloc] init];
        self.accountTextLabel = [[UILabel alloc] init]; 

        [self.contentView addSubview: self.NickTextLabel];
        [self.contentView addSubview: self.accountTextLabel];
        
        
        [self.NickTextLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.avatarView.mas_right).offset(12);
            make.bottom.mas_equalTo(self.contentView.mas_centerY).offset(-4);
        }];
        
        //  设置 detailTextLabel 约束
        [self.accountTextLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.avatarView.mas_right).offset(12);
            make.top.mas_equalTo(self.contentView.mas_centerY).offset(4);
        }];
    }
    
    
    return self;
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
