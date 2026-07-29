//
//  CalculatorViewController.m
//  calculator
//
//  Created by lose_sea on 2026/7/27.
//

#import "CalculatorViewController.h"

@interface CalculatorViewController ()
@property (nonatomic, assign) int pointNum;
@property (nonatomic, assign) BOOL isValid;
@end

@implementation CalculatorViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    // Do any additional setup after loading the view.
    [self setUpData];
    [self setUpInterface];
    
//    NSLog(@"按钮数量:%lu", (unsigned long)self.calculatorView.keyboard.arrangedSubviews.count);
    
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
            [button addTarget:self action: @selector(pressBtn02: ) forControlEvents: UIControlEventTouchUpInside];
        }
    }
}


#pragma mark - 使用双栈
- (void) pressBtn02: (UIButton*) button {

    NSString* title = button.currentTitle;
    if ([title isEqualToString: @"AC"]) {
        if ([self checkLength]) {
            return;
        }
        // 全部清空
        [self removeAll];
    } else if ([title isEqualToString: @"="]) {
        
        [self pressEqual02];

    } else if ([title isEqualToString: @"⌫"]) {
        [self pressDelete02];
        
    } else if ([title isEqualToString: @"."] || [self isNumber: title]) {
        if ([self checkLength]) {
            return;
        }
        // 输入数字或者小数点
        [self pressNumber: title];
    } else if ([self isOperator: title] || [title isEqualToString: @"("] || [title isEqualToString: @")"]) {
        if ([self checkLength]) {
            return;
        }
        // 输入运算符或括号
        [self pressOperator: title];
    }
    
    NSLog(@"当前downString: %@", self.calculatorModel.downString);
    
//    NSLog(@"numberStack: %@", self.calculatorModel.numberStack);
    [self reloadLabels];
}



// 点击 =
- (void) pressEqual02 {
    if (self.calculatorModel.operatorsStack.count == 0) {
        self.calculatorModel.upString = [self.calculatorModel.downString mutableCopy];
        return;  
    }
    // 计算式为空
    if (self.calculatorModel.downString.length == 0) {
        return;
    }
    
    NSString* lastStr = [self.calculatorModel.downString substringFromIndex: self.calculatorModel.downString.length - 1];
    if ([self isNumber: lastStr]) {
        // 最后一位如果是数字, 正常计算
        [self.calculatorModel.temporaryString setString: @""];
    }
    
    // 最后一位是 x 或 ÷, 错误
    if ([lastStr isEqualToString: @"x"] || [lastStr isEqualToString: @"÷"]) {
        self.calculatorModel.upString = [self.calculatorModel.downString mutableCopy];
        [self.calculatorModel.downString setString: @"error"];
        return;
    }
    
    // 最后一位是 + . - ( , 忽略正常计算
    if ([lastStr isEqualToString: @"+"] || [lastStr isEqualToString: @"-"] || [lastStr isEqualToString: @"."] || [lastStr isEqualToString: @"("]) {
        [self.calculatorModel.downString deleteCharactersInRange: NSMakeRange(self.calculatorModel.downString.length - 1,  1)];
    }
    
    if (self.calculatorModel.downString.length > 2) {
        // 如果数字后直接跟括号,在中间加上 x
        for (NSInteger i = 0; i < self.calculatorModel.downString.length - 1; i++) {
            NSString* currch = [self.calculatorModel.downString substringWithRange:NSMakeRange(i, 1)];
            NSString* nextch = [self.calculatorModel.downString substringWithRange:NSMakeRange(i + 1, 1)];
            if ([self isNumber: currch] && [nextch isEqualToString: @"("]) {
                [self.calculatorModel.downString insertString: @"x" atIndex: i + 1];
            }
            
        }
    }
    
    
    
    // 检验左右括号是否匹配
    // 补充右括号
    NSInteger balance = 0;
    for (NSInteger i = 0; i < self.calculatorModel.downString.length; i++) {
        NSString* ch = [self.calculatorModel.downString substringWithRange: NSMakeRange(i, 1)];
        if ([ch isEqualToString: @"("]) {
            balance++;
        } else if ([ch isEqualToString: @")"]) {
            balance--;
        }
        // 右括号多,匹配错误
        if (balance < 0) {
            self.calculatorModel.upString = [self.calculatorModel.downString mutableCopy];
            [self.calculatorModel.downString setString: @"error"];
            return;
        }
    }
    
    // 右括号少, 补充右括号
    if (balance > 0) {
        for (NSInteger i = 0; i < balance; i++) {
            [self.calculatorModel.downString appendString: @")"];
        }
    }
    
    NSString* expression = self.calculatorModel.downString;
    
    [self.calculatorModel.temporaryString  setString: @""];
    
    // 重置栈
    [self.calculatorModel.numberStack removeAllObjects];
    [self.calculatorModel.operatorsStack removeAllObjects];
    
    
    for (NSInteger i = 0; i < expression.length; i++) {
        
        // 当前遍历的字符
        NSString* ch = [expression substringWithRange: NSMakeRange(i,  1)];
        
        if ([self isNumber: ch] || [ch isEqualToString: @"."]) {
            
            // 用来拼接读取到的数字
            NSMutableString* numStr = [NSMutableString string];
            
            while (i < expression.length) {
               NSString* nextCh = [expression substringWithRange:NSMakeRange(i, 1)];
               if ([self isNumber:nextCh] || [nextCh isEqualToString:@"."]) {
                   [numStr appendString:nextCh];
                   i++;
               } else {
                   break;
               }
           }
            i--;
            
            [self.calculatorModel pushNumber: numStr];
            
        } else if ([self isOperator: ch]) {
            NSString *currentOp = ch;
            int currentPriority = [self priority: currentOp];
            
            while (self.calculatorModel.operatorsStack.count > 0) {
                // 获取栈顶的运算符
                NSString *topOp = [self.calculatorModel.operatorsStack lastObject];
                
                // 如果是 ( ,直接压栈
                if ([topOp isEqualToString:@"("]) {
                    break;
                }
                
                int topPriority = [self priority:topOp];
                
                // 栈顶运算符优先级大于等于当前运算符优先级, 进行运算
                if (topPriority >= currentPriority) {
                    [self evaluateTop:self.calculatorModel.numberStack opStack:self.calculatorModel.operatorsStack];
                } else {
                    
                    break;
                }
            }
            [self.calculatorModel pushOperator: currentOp];
            
        } else if ([ch isEqualToString: @"("]) {
            [self.calculatorModel pushOperator: ch];
            
        } else if ([ch isEqualToString: @")"]) {
            // 如果是 ) ,一直计算直到遇到 (
            while (self.calculatorModel.operatorsStack.count > 0 && ![self.calculatorModel.operatorsStack.lastObject isEqualToString:@"("]) {
                [self evaluateTop:self.calculatorModel.numberStack opStack:self.calculatorModel.operatorsStack];
                
                if ([self.calculatorModel.downString isEqualToString:@"error"]) {
                    return;
                }
            }
            // 弹出左括号
            if (self.calculatorModel.operatorsStack.count > 0 && [self.calculatorModel.operatorsStack.lastObject isEqualToString:@"("]) {
                [self.calculatorModel.operatorsStack removeLastObject];
            }
        }
    }
        
    while (self.calculatorModel.operatorsStack.count > 0) {
        [self evaluateTop: self.calculatorModel.numberStack opStack: self.calculatorModel.operatorsStack];
        if ([self.calculatorModel.downString isEqualToString:@"error"]) {
            return;
        }
    }
    
    
    if (self.calculatorModel.numberStack.count == 1) {
        NSDecimalNumber* result = [self.calculatorModel.numberStack lastObject];
        
        // 设置最多保留10位小数
        NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
        // 十进制风格
        formatter.numberStyle = NSNumberFormatterDecimalStyle;
        // 最多保留10位小数
        formatter.maximumFractionDigits = 8;
        // 最少保留0位小数
        formatter.minimumFractionDigits = 0;
        // 四舍五入
        formatter.roundingMode = NSNumberFormatterRoundHalfUp;
        
        // 格式化结果
        NSString *formattedResult = [formatter stringFromNumber:result];
        
        self.calculatorModel.upString = [self.calculatorModel.downString mutableCopy];
        self.calculatorModel.downString = [NSMutableString stringWithFormat: @"%@", formattedResult];
        
//        self.calculatorModel.upString = [self.calculatorModel.downString mutableCopy];
//        self.calculatorModel.downString = [NSMutableString stringWithFormat: @"%@", result];
    }
    
}


- (void)evaluateTop:(NSMutableArray *)numStack opStack:(NSMutableArray *)opStack {
    if (numStack.count < 2 || opStack.count == 0) {
        return;
    }
    NSDecimalNumber *right = [self.calculatorModel popNumber];
    
    NSDecimalNumber *left = [self.calculatorModel popNumber];
    
    NSString *op = [self.calculatorModel popOperator];
    
    NSDecimalNumber *result = nil;
    if ([op isEqualToString:@"+"]) {
        result = [left decimalNumberByAdding:right];
    } else if ([op isEqualToString:@"-"]) {
        result = [left decimalNumberBySubtracting:right];
    } else if ([op isEqualToString:@"x"]) {
        result = [left decimalNumberByMultiplyingBy:right];
    } else if ([op isEqualToString:@"÷"]) {
        if ([right isEqualToNumber:[NSDecimalNumber zero]]) {
            // 除零错误
            self.calculatorModel.upString = self.self.calculatorModel.downString;
            self.calculatorModel.downString = [NSMutableString stringWithString:@"error"];
            [self reloadLabels];
            return;
        }
        result = [left decimalNumberByDividingBy:right];
    }
    if (result) {
        [self.calculatorModel.numberStack addObject:result];
    }
}



//     点击退格
- (void) pressDelete02 {
//    NSLog(@"点击 delete");
    if (self.calculatorModel.upString.length > 0) {

        
        [self removeAll];
        return;
    } else if (self.calculatorModel.downString.length > 0) {
        
        // 获取当前最后一个字符
        NSString* lastStr = [self.calculatorModel.downString substringFromIndex: self.calculatorModel.downString.length - 1];
        
        // 如果是数字或小数点, 直接删除临时字符串的最后一个字符
        if ([lastStr isEqualToString: @"."] || [self isNumber: lastStr]) {
            
            // 记录数字中的小数点个数
            if ([lastStr isEqualToString: @"."]) {
                self.pointNum--;
            }
            
            [self.calculatorModel.temporaryString deleteCharactersInRange: NSMakeRange(self.calculatorModel.temporaryString.length - 1, 1)];
            // 删除计算式的最后一个字符
            [self.calculatorModel.downString deleteCharactersInRange: NSMakeRange(self.calculatorModel.downString.length - 1, 1)];
            return;
        }
        
        // 如果是 - ,根据前面判断是 负号 还是 减号
        if ([lastStr isEqualToString: @"-"]) {
            
            // 如果 - 位于计算式的开头,为负号
            if (self.calculatorModel.downString.length == 1) {
                [self.calculatorModel.temporaryString deleteCharactersInRange: NSMakeRange(self.calculatorModel.temporaryString.length - 1, 1)];
                // 删除计算式的最后一个字符
                [self.calculatorModel.downString deleteCharactersInRange: NSMakeRange(self.calculatorModel.downString.length - 1, 1)];
                return;
            } else {
                // 如果 - 前面是(,为负号
                NSString* frontStr = [self.calculatorModel.downString substringWithRange: NSMakeRange(self.calculatorModel.downString.length - 2, 1)];
                if ([frontStr isEqualToString: @"("]) {
                    
                    [self.calculatorModel.temporaryString deleteCharactersInRange: NSMakeRange(self.calculatorModel.temporaryString.length - 1, 1)];
                    // 删除计算式的最后一个字符
                    [self.calculatorModel.downString deleteCharactersInRange: NSMakeRange(self.calculatorModel.downString.length - 1, 1)];
                    return;
                }
            }
        }
        
        // 最后一个字符是运算符或者右括号
        if ([self isOperator: lastStr] || [lastStr isEqualToString: @")"]) {
            // 弹出栈顶的运算符
            [self.calculatorModel popOperator];
            [self.calculatorModel.downString deleteCharactersInRange: NSMakeRange(self.calculatorModel.downString.length - 1, 1)];
            
            // 弹出运算符之后判断前面的是数字还是括号
            NSString* frontStr = [self.calculatorModel.downString substringWithRange: NSMakeRange(self.calculatorModel.downString.length - 1, 1)];
            
            // 是数字, 将数字栈中最后一个数字取出来进行编辑
            if ([self isNumber: frontStr]) {
                NSDecimalNumber* number = [self.calculatorModel.numberStack lastObject];
                self.calculatorModel.temporaryString = [NSMutableString stringWithFormat: @"%@", number];
                
                // 遍历取出来的数字字符串,记录小数点个数
                for (NSInteger i = 0; i < self.calculatorModel.temporaryString.length; i++) {
                    NSString* ch = [self.calculatorModel.temporaryString substringWithRange: NSMakeRange(i, 1)];
                    if (([ch isEqualToString: @"."])) {
                        self.pointNum++;
                        break;
                    }
                }
            }
            
        }
        
        // 最后一个字符是左括号
        if ([lastStr isEqualToString: @"("]) {
            [self.calculatorModel.downString deleteCharactersInRange: NSMakeRange(self.calculatorModel.downString.length - 1, 1)];
            [self.calculatorModel popOperator];
        }
    }
    return;
}
 


// 输入数字或者小数点
- (void) pressNumber: (NSString*) title {
//    NSLog(@"点击number");
    // 清空上一次计算数据
    if (self.calculatorModel.upString.length > 0) {
        [self removeAll];
    }
    
    if (self.calculatorModel.downString.length == 0) {
        [self.calculatorModel.temporaryString appendString: title];
        [self.calculatorModel.downString appendString: title];
        return;
    }
    
    NSString* lastStr = [self.calculatorModel.downString substringFromIndex: self.calculatorModel.downString.length - 1];

        
    // ) 后面直接接数字,输入无效
    if ([lastStr isEqualToString: @")"]) {
        return;
    }
    
     
    // 如果已经存在小数点,输入无效
    if ([title isEqualToString: @"."]) {
        if (self.pointNum > 0) {
            return;
        } else if ([self isOperator: lastStr]) {
            // 运算符后直接跟小数字点, 无效
            return;
        } else {
            self.pointNum++;
        }
    }
    [self.calculatorModel.temporaryString appendString: title];
    [self.calculatorModel.downString appendString: title];
    return;
}


// 输入运算符或者括号
- (void) pressOperator: (NSString*) title {
    if (self.calculatorModel.upString.length > 0) {
        [self.calculatorModel.upString setString: @""];
    }
    
//    NSLog(@"点击了operator");
    if (self.calculatorModel.downString.length == 0) {
        if ([title isEqualToString: @"-"]) {
            [self.calculatorModel.temporaryString appendString: title];
            [self.calculatorModel.downString appendString: title];
            return;
        } else if ([title isEqualToString: @"("]) {
            [self.calculatorModel.downString appendString: title];
            [self.calculatorModel pushOperator: title];
            return;
        } else {
            return;
        }
    }
    
    
    NSString* lastStr = [self.calculatorModel.downString substringFromIndex: self.calculatorModel.downString.length - 1];

    // 输入运算符
    if ([self isOperator: title]) {
        // 小数点后直接跟运算符, 不合法, 输入无效
        // 左括号后直接跟运算符, 不合法
        if ([lastStr isEqualToString: @"."] || [lastStr isEqualToString: @"("]) {
            return;
        }
        
        // 最后一个是运算符, 替换
        if ([self isOperator: lastStr]) {
            if (self.calculatorModel.downString.length == 1) {
                return;
            } else if ([lastStr isEqualToString: @"-"]) {
                NSString* frontStr = [self.calculatorModel.downString substringWithRange:NSMakeRange(self.calculatorModel.downString.length - 2, 1)];
                if ([frontStr isEqualToString: @"("]) {
                    return;
                }
            }
                
                
            [self.calculatorModel popOperator];
            [self.calculatorModel.downString deleteCharactersInRange: NSMakeRange(self.calculatorModel.downString.length - 1, 1)];
            [self.calculatorModel pushOperator: title];
            [self.calculatorModel.downString appendString: title];
            return;
        } else {
        
            // 输入 - ,判断负号还是减号
            if ([title isEqualToString: @"-"]) {
                // 如果 - 位于算式的开头,为负号
                if (self.calculatorModel.downString.length == 0) {
                    [self.calculatorModel.temporaryString appendString: title];
                    [self.calculatorModel.downString appendString: title];
                    return;
                } else {
                    // 如果 - 前面是(,为负号
                    if ([lastStr isEqualToString: @"("]) {
                        [self.calculatorModel.temporaryString appendString: title];
                        [self.calculatorModel.downString appendString: title];
                        return;
                    }
                }
            }
            
            // 将当前的数字压入栈
            [self.calculatorModel pushNumber: self.calculatorModel.temporaryString];
            [self.calculatorModel.temporaryString setString: @""];
            [self.calculatorModel pushOperator: title];
            self.pointNum = 0;
            
        }
    } else if ([title isEqualToString: @"("]) {
        
        // ( 前为 . 或 ), 不合法
        if ([lastStr isEqualToString: @"."] || [lastStr isEqualToString: @")"]) {
            return;
        } else {
            [self.calculatorModel pushOperator: title];
        }

    } else if ([title isEqualToString: @")"]) {
        
        // ) 前为 . 或 ( 或 运算符, 不合法, 输入无效
        if ([lastStr isEqualToString: @"."] || [lastStr isEqualToString: @"("] || [self isOperator: lastStr]) {
            return;
        } else if ([self isNumber: lastStr]) {
            [self.calculatorModel pushNumber: self.calculatorModel.temporaryString];
            [self.calculatorModel.temporaryString setString: @""];
            [self.calculatorModel pushOperator: title];
        } else {
            [self.calculatorModel pushOperator: title];
        }
    }
    [self.calculatorModel.downString appendString: title];
    return;
}






#pragma mark - 辅助方法
//清除
- (void) removeAll {
    [self.calculatorModel.numberStack removeAllObjects];
    [self.calculatorModel.operatorsStack removeAllObjects];
    [self.calculatorModel.upString setString: @""];
    [self.calculatorModel.downString setString: @""];
    [self.calculatorModel.temporaryString setString: @""];
    [self.calculatorModel.resultString setString: @""];
    
    self.calculatorView.upLabel.text = @"";
    self.calculatorView.downLabel.text = @"";
    
    self.pointNum = 0;
}

- (BOOL) checkLength {
    if (self.calculatorModel.downString.length > 20) {
        return YES;
    }
    return NO;
}


// 刷新显示
- (void) reloadLabels {
    self.calculatorView.upLabel.text = self.calculatorModel.upString;
    self.calculatorView.downLabel.text = self.calculatorModel.downString;
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

 
// 获取运算符优先级
- (int)priority:(NSString *)op {
    if ([op isEqualToString:@"x"] || [op isEqualToString:@"÷"]) {
        return 2;
    }
    if ([op isEqualToString:@"+"] || [op isEqualToString:@"-"]) {
        return 1;
    }
    if ([op isEqualToString:@"("]) {
        return 0;
    }
    return -1;
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
     
    expr = [self convertIntegersToFloats: expr];
    
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
        
        NSString* result = [formatter stringFromNumber:num];
        if ([result isEqualToString: @"-0"]) {
            result = @"0";
        }
        return result;
    }
    return nil;
}

// 将表达式中的整数转为浮点数格式
- (NSString *)convertIntegersToFloats:(NSString *)expression {
    NSMutableString *result = [NSMutableString string];
    NSMutableString *currentNumber = [NSMutableString string];
    // 是否包含小数点
    BOOL hasDecimal = NO;
    
    BOOL isNumber = NO;
    
    for (NSInteger i = 0; i < expression.length; i++) {
        unichar ch = [expression characterAtIndex:i];
        
        // 如果是数字或小数点
        if ((ch >= '0' && ch <= '9') || ch == '.') {
            if (ch == '.') {
                hasDecimal = YES;
            }
            [currentNumber appendFormat:@"%C", ch];
            isNumber = YES;
        } else {
            // 遇到运算符或括号，处理之前的数字
            if (isNumber) {
                if (!hasDecimal) {
                    // 整数 → 转为浮点数格式
                    [result appendFormat:@"%@.0", currentNumber];
                } else {

                    [result appendString:currentNumber];
                }
                [currentNumber setString:@""];
                hasDecimal = NO;
                isNumber = NO;
            }
            // 添加运算符
            [result appendFormat:@"%C", ch];
        }
    }
    
    // 处理最后一个数字
    if (isNumber) {
        if (!hasDecimal) {
            [result appendFormat:@"%@.0", currentNumber];
        } else {
            [result appendString:currentNumber];
        }
    }
    
    return result;
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
        
        // 除以 0
        if ([current isEqualToString: @"÷"] && [next isEqualToString: @"0"]) {
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
@end
