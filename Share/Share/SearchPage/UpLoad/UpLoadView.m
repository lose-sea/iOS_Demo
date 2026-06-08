//
//  UpLoadView.m
//  Share
//
//  Created by lose_sea on 2026/5/26.
//

#import "UpLoadView.h"

@implementation UpLoadView
- (instancetype) init {
    self = [super init];
    if (self) {
        [self setInterface]; 
    }
    return self;
}

- (void) setInterface {
    [self setCoverView];
    [self setLocationView];
    [self setTagTableView];
    [self setCollectionView];
    [self setTextView];
    [self setUpLoadButton];
    [self setAgreeDownLoadButton];
    [self setForbiddenDownLoad];
}

- (void) setCoverView {
    self.coverViewButton = [UIButton buttonWithType: UIButtonTypeCustom];
    self.coverViewButton.titleLabel.font = [UIFont systemFontOfSize: 24];
    [self.coverViewButton setTitle: @"选择照片" forState: UIControlStateNormal];
    [self.coverViewButton setTitleColor: [UIColor blackColor] forState: UIControlStateNormal];
    self.coverViewButton.backgroundColor = [UIColor systemGrayColor];
    [self addSubview: self.coverViewButton];
    [self.coverViewButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(10);
            make.top.mas_equalTo(20);
            make.width.mas_equalTo(220);
            make.height.mas_equalTo(160);
    }];
    self.coverViewButton.contentMode = UIViewContentModeScaleAspectFill;
    self.clipsToBounds = YES; 
}

- (void) setLocationView {
    self.locationView = [[UIImageView alloc] init];
    [self addSubview: self.locationView];
    [self.locationView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.coverViewButton.mas_top).offset(10);
        make.left.mas_equalTo(self.coverViewButton.mas_right).offset(10);
        make.width.mas_equalTo(140);
        make.height.mas_equalTo(30);
    }];
    UIImageView* iView = [[UIImageView alloc] initWithImage: [UIImage systemImageNamed: @"location.fill"]];
    [self.locationView addSubview: iView];
    [iView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.locationView).offset(5);
        make.top.mas_equalTo(self.locationView).offset(5);
        make.width.mas_equalTo(20);
        make.height.mas_equalTo(20);
    }];
    UILabel* label = [[UILabel alloc] init];
    label.clipsToBounds = YES;
    label.layer.cornerRadius = 5;

    label.backgroundColor = [UIColor systemBlueColor];
    label.font = [UIFont systemFontOfSize: 15];
    label.text = @"陕西省,西安市";
    label.textColor = [UIColor whiteColor];
    [self.locationView addSubview: label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.locationView).offset(5);
            make.left.mas_equalTo(self.locationView).offset(30);
            make.width.mas_equalTo(100);
            make.height.mas_equalTo(20);
    }];
}

- (void) setTagTableView {
    self.tagTableView = [[UITableView alloc] init];
    [self addSubview: self.tagTableView];
    [self.tagTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.coverViewButton.mas_right).offset(10);
        make.top.mas_equalTo(self.locationView.mas_bottom).offset(10);
        make.width.mas_equalTo(150);
        make.height.mas_equalTo(110);
    }];
//    self.tagTableView.backgroundColor = [UIColor systemRedColor]; 
    [self.tagTableView registerClass: [UITableViewCell class] forCellReuseIdentifier: @"tagTableViewCellID"];
}

- (void) setCollectionView {
    // 布局
    UICollectionViewFlowLayout* flowLayout = [[UICollectionViewFlowLayout alloc] init];
    // 每个cell的大小
    flowLayout.itemSize = CGSizeMake(80, 30);
    // 同一行中 cell 之间的间隔
    flowLayout.minimumLineSpacing = 10;
    // 行与行之间的间隔
    flowLayout.minimumInteritemSpacing = 10;
    
    self.collectionView = [[UICollectionView alloc] initWithFrame: CGRectZero collectionViewLayout: flowLayout];
    
    [self addSubview: self.collectionView];
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self).offset(10);
        make.right.mas_equalTo(self).offset(-10);
        make.top.mas_equalTo(self.coverViewButton.mas_bottom).offset(20);
        make.height.mas_equalTo(70);
    }];
    // 注册cell
    [self.collectionView registerClass: [tagCollectionVIewCell class] forCellWithReuseIdentifier: @"collectionViewCellID"];
}

- (void) setTextView {
    self.textView = [[UITextView alloc] init];
    self.textView.font = [UIFont systemFontOfSize: 15];
    self.textView.textColor = [UIColor blackColor];
//    self.textView.backgroundColor = [UIColor systemGrayColor];
    self.backgroundColor = [UIColor whiteColor];
    self.label = [[UILabel alloc] init];
    self.label.text = @"请输入文本作为作品介绍...";
    self.label.textColor = [UIColor systemGrayColor];
    [self.textView addSubview: self.label];
    [self.label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(self.textView).insets(UIEdgeInsetsMake(5, 10, 50, 40));
    }];
    [self addSubview: self.textView];
    [self.textView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.collectionView.mas_bottom).offset(20);
            make.left.mas_equalTo(self).offset(10);
            make.right.mas_equalTo(self).offset(-10);
            make.height.mas_equalTo(150);
    }];
}
- (void) setUpLoadButton {
    self.upLoadButton = [[UIButton alloc] init];
    // 使用动态颜色设置黑色
    [self.upLoadButton setTitle: @"发布" forState: UIControlStateNormal];
    [self.upLoadButton setTitleColor: [UIColor systemBackgroundColor] forState: UIControlStateNormal];
    self.upLoadButton.backgroundColor = [UIColor systemBlueColor];
    [self addSubview: self.upLoadButton];
    [self.upLoadButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.textView.mas_bottom).offset(20);
        make.left.mas_equalTo(self).offset(10);
        make.right.mas_equalTo(self).offset(-10);
        make.height.mas_equalTo(40);
    }];
    self.upLoadButton.backgroundColor = [UIColor systemBlueColor];
}

- (void) setAgreeDownLoadButton {
    self.agreeDownLoadButton = [UIButton buttonWithType: UIButtonTypeCustom];
    [self.agreeDownLoadButton setImage: [UIImage systemImageNamed: @"square"] forState: UIControlStateNormal];
    [self addSubview: self.agreeDownLoadButton];
    [self.agreeDownLoadButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.upLoadButton.mas_bottom).offset(10);
            make.left.mas_equalTo(self.collectionView).offset(10);
            make.width.mas_equalTo(20);
            make.height.mas_equalTo(20);
    }];
//    self.agreeDownLoadButton.backgroundColor = [UIColor systemBlueColor];
}

- (void) setForbiddenDownLoad {
    self.forbiddenDownLoad = [[UILabel alloc] init];
    self.forbiddenDownLoad.text = @"禁止下载";
    self.forbiddenDownLoad.textColor = [UIColor labelColor];
    [self addSubview: self.forbiddenDownLoad];
    [self.forbiddenDownLoad mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.agreeDownLoadButton.mas_right).offset(10);
            make.top.mas_equalTo(self.agreeDownLoadButton);
            make.width.mas_equalTo(70);
            make.height.mas_equalTo(20);
    }];
    
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
 
@end
