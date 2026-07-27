//
//  CalculatorView.m
//  calculator
//
//  Created by lose_sea on 2026/7/27.
//

#import "CalculatorView.h"

@implementation CalculatorView

- (instancetype) init {
    self = [super init];
    if (self) {
        [self setUpinterface]; 
    }
    return self;
}

- (void) setUpinterface {
    self.upLabel = [[UILabel alloc] init];
    self.downLabel = [[UILabel alloc] init];
    
    self.keyboard = [self createKeyboard];
    [self addSubview: self.keyboard];
    // 关闭frame,采用约束
    self.keyboard.translatesAutoresizingMaskIntoConstraints = NO;
    
    [self.keyboard mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self).insets(UIEdgeInsetsMake(0, 11, 20, 11));
        make.height.mas_equalTo(450);
    }];
    
    self.downLabel = [[UILabel alloc] init];
    [self addSubview: self.downLabel];
    [self.downLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.keyboard.mas_top).offset(-40);
        make.left.right.mas_equalTo(self);
        make.height.mas_equalTo(90);
    }];
    self.downLabel.adjustsFontSizeToFitWidth = YES;
    self.downLabel.textColor = [UIColor labelColor];
    self.downLabel.backgroundColor = [UIColor systemRedColor];
    
    self.upLabel = [[UILabel alloc] init];
    [self addSubview: self.upLabel];
    [self.upLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.downLabel.mas_top).offset(-20);
        make.left.right.mas_equalTo(self);
        make.height.mas_equalTo(60);
    }];
    self.upLabel.adjustsFontSizeToFitWidth = YES;
    self.upLabel.textColor = [UIColor labelColor];

    self.upLabel.backgroundColor = [UIColor systemCyanColor];
}


- (UIStackView *)createRowWithTitles:(NSArray<NSString *> *)titles {
    NSMutableArray *buttons = [NSMutableArray array];
    for (NSString *title in titles) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeSystem];
        [btn setTitle:title forState:UIControlStateNormal];
        btn.titleLabel.font = [UIFont systemFontOfSize: 30];
        btn.backgroundColor = [UIColor lightGrayColor];
        
        btn.backgroundColor = [UIColor colorWithWhite: 0.4 alpha: 0.7];
        [btn setTitleColor: [UIColor labelColor] forState: UIControlStateNormal]; 
        
        
        if (title == [titles lastObject]) {
            btn.backgroundColor = [UIColor systemOrangeColor];
        }
        [btn setBackgroundImage: [UIImage imageNamed: @"1.png"] forState: UIControlStateHighlighted];
        
        btn.clipsToBounds = YES;
        btn.layer.cornerRadius = 40;
        [buttons addObject:btn];
    }
    
    // 创建横向的UIStackView
    UIStackView *rowStack = [[UIStackView alloc] initWithArrangedSubviews:buttons];
    // 水平排列
    rowStack.axis = UILayoutConstraintAxisHorizontal;
    // 平分宽度
    rowStack.distribution = UIStackViewDistributionFillEqually;
    // 填充高度
    rowStack.alignment = UIStackViewAlignmentFill;
    // 按钮间距
    rowStack.spacing = 10;
    
    return rowStack;
}


- (UIStackView *)createKeyboard {
    // 模拟计算器的 4 行数据
    NSArray *rowData = @[
        @[@"AC", @"(", @")", @"÷"],
        @[@"7", @"8", @"9", @"×"],
        @[@"4", @"5", @"6", @"-"],
        @[@"1", @"2", @"3", @"+"],
        @[@"⌫", @"0", @".", @"="]
    ];
    
    NSMutableArray *rows = [NSMutableArray array];
    for (NSArray *titles in rowData) {
        UIStackView *row = [self createRowWithTitles:titles];
        [rows addObject:row];
        if (row == rows[0]) {
            for (NSInteger i = 0; i < 3 ; i++) {
                UIButton* btn = row.arrangedSubviews[i];
                btn.backgroundColor = [UIColor systemGrayColor];
                [btn setTitleColor: [UIColor systemBackgroundColor] forState: UIControlStateNormal];
            }
        }
    }
    
    UIStackView *keyboardStack = [[UIStackView alloc] initWithArrangedSubviews:rows];
    keyboardStack.axis = UILayoutConstraintAxisVertical;    // 垂直排列四行
    keyboardStack.distribution = UIStackViewDistributionFillEqually; // 四行平分高度
    keyboardStack.alignment = UIStackViewAlignmentFill;
    keyboardStack.spacing = 10;
    
    return keyboardStack;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
