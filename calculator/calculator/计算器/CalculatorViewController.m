//
//  CalculatorViewController.m
//  calculator
//
//  Created by lose_sea on 2026/7/27.
//

#import "CalculatorViewController.h"

@interface CalculatorViewController ()

@end

@implementation CalculatorViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSLog(@"hello");
    //    NSLog(@"%lf", 8/0);
    // Do any additional setup after loading the view.
    [self setUpData];
    [self setUpInterface];
    
}

- (void)setUpData {
    self.calculatorModel = [[CalculatorModel alloc] init];
    self.calculatorView = [[CalculatorView alloc] init];
}

- (void) setUpInterface {
    [self.view addSubview: self.calculatorView];
    [self.calculatorView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.view);
    }];
    
    for (UIStackView* rowStackView in self.calculatorView.keyboard.arrangedSubviews) {
        for (UIButton* button in rowStackView.arrangedSubviews) {
            [button addTarget: self action: @selector(pressBtn01:) forControlEvents: UIControlEventTouchUpInside];
        }
    }
}




#pragma mark - 使用NSExpression
- (void) pressBtn01: (UIButton*) button {
    NSString* title = button.currentTitle;
    if ([title isEqualToString: @"AC"]) {
        // 全部清空
        [self removeAll];
    } else if ([title isEqualToString: @"="]) {
        [self pressEqual01];
    } else if ([title isEqualToString: @"⌫"]) {
        [self pressDelete01];
    } else {
        if (self.calculatorModel.downString.length < 15) {
            if (([self isNumber: title] || [title isEqualToString: @"."] || [title isEqualToString: @"("]) && self.calculatorModel.upString.length > 0) {
                [self removeAll];
            }
            if (self.calculatorModel.upString.length > 0) {
                [self.calculatorModel.upString setString: @""];
            }
            [self.calculatorModel.downString appendString: title];
        }
    }
    [self reloadLabels];
}



#pragma mark - 输入运算
// 点击AC
- (void) removeAll {
    [self.calculatorModel.numberStack removeAllObjects];
    [self.calculatorModel.operatorsStack removeAllObjects];
    [self.calculatorModel.upString setString: @""];
    [self.calculatorModel.downString setString: @""];
    [self.calculatorModel.temporaryString setString: @""];
    [self.calculatorModel.resultString setString: @""];
    
    self.calculatorView.upLabel.text = @"";
    self.calculatorView.downLabel.text = @"";
}

// 点击 =
- (void) pressEqual01 {
    if (self.calculatorModel.downString.length == 0)  {
        return;
    }
    
    self.calculatorModel.upString = [NSMutableString stringWithFormat:@"%@", self.calculatorModel.downString];
    
    // 计算表达式
    NSString *result = [self calculateExpression:self.calculatorModel.downString];
    if (result) {
        self.calculatorModel.downString = [NSMutableString stringWithString:result];
    } else {
        self.calculatorModel.downString = [NSMutableString stringWithString:@"error"];
    }
    [self reloadLabels];
}

// 点击退格
- (void) pressDelete01 {
    if (self.calculatorModel.upString.length > 0) {
        
        // 将上面的字符转移下来, 上方清空
        self.calculatorModel.downString = [self.calculatorModel.upString mutableCopy];
        [self.calculatorModel.upString setString: @""];
        
    }
    if (self.calculatorModel.downString.length > 0) {
        [self.calculatorModel.downString deleteCharactersInRange: NSMakeRange(self.calculatorModel.downString.length - 1, 1)];
    }
}

// 点击 = 进行计算
- (NSString *)calculateExpression:(NSString *)expression {
    // 表达式是否合法
    if (![self isValidExpression:expression]) {
        return nil;
    }
    
    // 替换显示符号为计算符号
    NSString *expr = [expression stringByReplacingOccurrencesOfString:@"x" withString:@"*"];
    expr = [expr stringByReplacingOccurrencesOfString:@"÷" withString:@"/"];
    
    // 给末尾如果是整数就加上.0,可以计算浮点数
    
    // 调用 NSExpression 计算
    // 转换为可以计算的 NSExpression对象
    NSExpression *nsExpr = [NSExpression expressionWithFormat:expr];
    
    id result = [nsExpr expressionValueWithObject:nil context:nil];
    
    // 检查结果类型
    if ([result isKindOfClass:[NSNumber class]]) {
        NSNumber *num = (NSNumber *)result;
        // 除零会返回 NaN
        if ([num isEqualToNumber:[NSDecimalNumber notANumber]]) {
            return nil;
        }
        
        // 格式化NSNumber对象
        NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
        formatter.numberStyle = NSNumberFormatterDecimalStyle;
        // 最多显示小数
        formatter.maximumFractionDigits = 10;
        // 最少显示小数
        formatter.minimumFractionDigits = 0;
        // 不用千位分隔符
        formatter.usesGroupingSeparator = NO;
        
        return [formatter stringFromNumber:num];
    }
    return nil;
}





#pragma mark - 判断表达式合法
// 验证表达式合法
- (BOOL)isValidExpression:(NSString *)expression {
    // 空字符串不合法
    if (expression.length == 0) {
        return NO;
    }
    
    
    //  括号匹配检查
    NSInteger balance = 0;
    for (NSInteger i = 0; i < expression.length; i++) {
        unichar ch = [expression characterAtIndex:i];
        if (ch == '(') {
            balance++;
        } else if (ch == ')') {
            balance--;
            if (balance < 0) { // 右括号比左括号多
                return NO;
            }
        }
    }
    if (balance != 0) { // 括号数量不匹配
        return NO;
    }
    
    
    // 不能以运算符或左括号结尾
    NSString *lastChar = [expression substringFromIndex:expression.length - 1];
    if ([self isOperator:lastChar] || [lastChar isEqualToString:@"("] || [lastChar isEqualToString: @"."]) {
        return NO;
    }
    
    
    // 不能以运算符开头（除了左括号或负号）
    NSString *firstChar = [expression substringToIndex:1];
    if ([self isOperator:firstChar] && ![firstChar isEqualToString:@"-"]) {
        return NO;
    }
    
    
    for (NSInteger i = 0; i < expression.length - 1; i++) {
        NSString *current = [expression substringWithRange:NSMakeRange(i, 1)];
        NSString *next = [expression substringWithRange:NSMakeRange(i+1, 1)];
        // 操作符后接操作符
        if ([self isOperator:current] && [self isOperator:next]) {
            return NO;
        }
        
        // 小数点后接操作符
        if([current isEqualToString: @"."] && ([self isOperator:next])) {
            return NO;
        }
    }
    
    // 判断每一个数字是否包含多个小数点
    if (![self isValidNumberFormat:expression]) {
        return NO;
    }
    
    return YES;
}

- (BOOL)isValidNumberFormat:(NSString *)expression {
    NSMutableString *currentNumber = [NSMutableString string];
    BOOL isNumber = NO;
    
    for (NSInteger i = 0; i < expression.length; i++) {
        unichar ch = [expression characterAtIndex:i];
        
        // 如果是数字或小数点
        if ((ch >= '0' && ch <= '9') || ch == '.') {
            [currentNumber appendFormat:@"%C", ch];
            isNumber = YES;
        } else {
            // 遇到运算符或括号，检查之前的数字
            if (isNumber) {
                // 统计数字中的小数点个数
                NSInteger dotCount = 0;
                for (NSInteger j = 0; j < currentNumber.length; j++) {
                    if ([currentNumber characterAtIndex:j] == '.') {
                        dotCount++;
                    }
                }
                // 如果小数点大于1个，非法
                if (dotCount > 1) {
                    return NO;
                }
                [currentNumber setString:@""];
                isNumber = NO;
            }
        }
    }
    
    // 检查最后一个数字
    if (isNumber) {
        NSInteger potCount = 0;
        for (NSInteger j = 0; j < currentNumber.length; j++) {
            if ([currentNumber characterAtIndex:j] == '.') {
                potCount++;
            }
        }
        if (potCount > 1) {
            return NO;
        }
    }
    
    return YES;
}


#pragma mark - 辅助方法

// 刷新显示
- (void) reloadLabels {
    self.calculatorView.upLabel.text = self.calculatorModel.upString;
    self.calculatorView.downLabel.text = self.calculatorModel.downString;
}

// 进行计算
- (void) calculate {
    NSLog(@"calculator");
}

// 判断是否数字
- (BOOL) isNumber: (NSString*)title {
    unichar ch = [title characterAtIndex: 0];
    return (ch >= '0' && ch <= '9');
}

// 判断是否运算符
- (BOOL) isOperator:(NSString *)op {
    return ([op isEqualToString:@"+"] || [op isEqualToString:@"-"] || [op isEqualToString:@"x"] || [op isEqualToString:@"÷"]);
}


// 判断是否更优先
- (BOOL) isprior: (NSString*) title {
    NSString* lastStr = self.calculatorModel.operatorsStack.lastObject;
    if ([title isEqualToString: @"x"] || [title isEqualToString: @"÷"]) {
        if (([lastStr isEqualToString: @"+"] )|| [lastStr isEqualToString: @"-"]) {
            return YES;
        } else {
            return NO;
        }
    } else if ([title isEqualToString: @"("]) {
        return YES;
    } else if ([title isEqualToString: @")"]) {
        return NO;
    }
    return NO; 
}










#pragma mark - 使用双栈
- (void) pressBtn02: (UIButton*) button {

    NSString* title = button.currentTitle;
    if ([title isEqualToString: @"AC"]) {
        // 全部清空
        [self removeAll];
    } else if ([title isEqualToString: @"="]) {
        [self pressEqual02];

    } else if ([title isEqualToString: @"⌫"]) {
        [self pressDelete02];
    } else {
        if ([title isEqualToString: @"."] || [self isNumber: title]) {
            [self pressNumber: title];
        } else {
            NSString* lastStr = [self.calculatorModel.downString substringFromIndex: self.calculatorModel.downString.length - 1];
            if ([self isOperator: lastStr]) {
                // 最后一个是运算符, 替换
                [self.calculatorModel popOperator];
                [self.calculatorModel.downString deleteCharactersInRange: NSMakeRange(self.calculatorModel.downString.length - 1, 1)];
                [self.calculatorModel pushOperator: title];
            } else {
                if ([self isprior: title]) {
                    [self.calculatorModel pushOperator: title];
                } else {
                    [self calculate];
                }
            }
        }
    }
    [self reloadLabels];
}



// 点击 =
- (void) pressEqual02 {
    if (self.calculatorModel.upString.length == 0) {

        [self.calculatorModel pushNumber: self.calculatorModel.temporaryString];
        
        [self calculate];
        self.calculatorModel.downString = [NSMutableString stringWithFormat: @"%@", [self.calculatorModel.numberStack lastObject]];
        if (self.calculatorModel.resultString.length > 0) {
            self.calculatorView.downLabel.text = self.calculatorModel.resultString;
            return;
        }
    }
}



//     点击退格
- (void) pressDelete02 {
    if (self.calculatorModel.upString.length > 0) {

        // 下方的数字转换为字符串,退格
        NSDecimalNumber* number = [self.calculatorModel popNumber];
        self.calculatorModel.temporaryString = [NSMutableString stringWithFormat: @"%@", number];
        [self.calculatorModel.temporaryString deleteCharactersInRange: NSMakeRange(self.calculatorModel.temporaryString.length - 1, 1)];

        // 将上面的字符转移下来, 上方清空
        self.calculatorModel.downString = self.calculatorModel.upString;
        [self.calculatorModel.upString setString: @""];

    } else if (self.calculatorModel.downString.length > 0) {

        NSString* lastStr = [self.calculatorModel.downString substringFromIndex: self.calculatorModel.downString.length - 1];
        if ([self isOperator: lastStr]) {
            [self.calculatorModel popOperator];

            NSDecimalNumber* number = [self.calculatorModel.numberStack lastObject];
            self.calculatorModel.temporaryString = [NSMutableString stringWithFormat: @"%@", number];

        } else {

            [self.calculatorModel.temporaryString deleteCharactersInRange: NSMakeRange(self.calculatorModel.temporaryString.length - 1, 1)];
        }
    }
    [self.calculatorModel.downString deleteCharactersInRange: NSMakeRange(self.calculatorModel.downString.length - 1, 1)];
}

// 输入数字
- (void) pressNumber: (NSString*) title {
    if (self.calculatorModel.upString.length > 0) {
        [self removeAll];
    }
    [self.calculatorModel.downString appendString: title];
    [self.calculatorModel.temporaryString appendString: title];
    return;
}


@end
