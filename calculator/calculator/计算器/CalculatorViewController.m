//
//  CalculatorViewController.m
//  calculator
//
//  Created by lose_sea on 2026/7/27.
//

#import "CalculatorViewController.h"

@interface CalculatorViewController ()
@property (nonatomic, assign) int pointNum;

@end

@implementation CalculatorViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//    NSLog(@"hello");
    //    NSLog(@"%lf", 8/0);
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
        // 全部清空
        [self removeAll];
    } else if ([title isEqualToString: @"="]) {
        
        [self pressEqual02];

    } else if ([title isEqualToString: @"⌫"]) {
        [self pressDelete02];
        
    } else if ([title isEqualToString: @"."] || [self isNumber: title]) {
        // 输入数字或者小数点
        [self pressNumber: title];
    } else if ([self isOperator: title] || [title isEqualToString: @"("] || [title isEqualToString: @")"]) {
        // 输入运算符或括号
        [self pressOperator: title];
    }
    NSLog(@"当前tempString: %@", self.calculatorModel.temporaryString);
    NSLog(@"当前downString: %@", self.calculatorModel.downString);
    
//    NSLog(@"numberStack: %@", self.calculatorModel.numberStack);
//    NSLog(@"operaStack: %@", self.calculatorModel.operatorsStack);
    [self reloadLabels];
}



// 点击 =
- (void) pressEqual02 {
    
    NSString* lastStr = [self.calculatorModel.downString substringFromIndex: self.calculatorModel.downString.length - 1];
    if ([self isNumber: lastStr]) {
        [self.calculatorModel pushNumber: self.calculatorModel.temporaryString];
        [self.calculatorModel.temporaryString setString: @""];
    }
    
    if ([lastStr isEqualToString: @"x"] || [lastStr isEqualToString: @"÷"]) {
        self.calculatorModel.upString = [self.calculatorModel.downString mutableCopy];
        [self.calculatorModel.downString setString: @"error"];
        return;
    }
    if ([lastStr isEqualToString: @"+"] || [lastStr isEqualToString: @"-"] || [lastStr isEqualToString: @"."] || [lastStr isEqualToString: @"("] || [lastStr isEqualToString: @")"]) {
        [self.calculatorModel.downString deleteCharactersInRange: NSMakeRange(self.calculatorModel.downString.length - 1,  1)];
    }
    if (self.calculatorModel.downString.length == 0) {
        return;
    }
    
    // 检验左右括号是否匹配
    NSInteger balance = 0;
    for (NSInteger i = 0; i < self.calculatorModel.downString.length; i++) {
        NSString* ch = [self.calculatorModel.downString substringWithRange: NSMakeRange(i, 1)];
        if ([ch isEqualToString: @"("]) {
            balance++;
        } else if ([ch isEqualToString: @")"]) {
            balance--;
        }
        if (balance < 0) {
            self.calculatorModel.upString = [self.calculatorModel.downString mutableCopy];
            [self.calculatorModel.downString setString: @"error"];
            return;
        }
    }
    
    if (balance > 0) {
        for (NSInteger i = 0; i < balance; i++) {
            [self.calculatorModel.downString appendString: @")"];
        }
    }
    
    
    // 当前完整的中缀表达式
//    NSString* infix = self.calculatorModel.downString;
    [self.calculatorModel.temporaryString  setString: @""];
//    [self.calculatorModel.numberStack removeAllObjects];
//    [self.calculatorModel.operatorsStack removeAllObjects];
    
    // 创建两个临时栈存储数字和运算符
    NSMutableArray* numStack = self.calculatorModel.numberStack;
    NSMutableArray* opStack = self.calculatorModel.operatorsStack;
    
    for (NSInteger i = 0; i < self.calculatorModel.downString.length; i++) {
        NSString* ch = [self.calculatorModel.downString substringWithRange: NSMakeRange(i,  1)];
        
        
        if ([self isNumber: ch] || [ch isEqualToString: @"."]) {
            NSMutableString* numStr = [NSMutableString string];
            while (((i < self.calculatorModel.downString.length) && ([self.calculatorModel.downString characterAtIndex: i] >= '0') && ([self.calculatorModel.downString characterAtIndex: i] <= '9')) || [self.calculatorModel.downString characterAtIndex: i] == '.') {
                [numStr appendFormat: @"%C", [self.calculatorModel.downString characterAtIndex: i]];
                i++;
            }
            i--;
            
            [self.calculatorModel pushNumber: numStr];
        } else if ([self isOperator: ch]) {
            NSString *currentOp = ch;
            int currentPriority = [self priority:currentOp];
            
            while (opStack.count > 0) {
                // 获取栈顶的运算符
                NSString *topOp = [opStack lastObject];
                
                // 如果是 ( ,直接压栈
                if ([topOp isEqualToString:@"("]) {
                    break;
                }
                
                int topPriority = [self priority:topOp];
                
                // 栈顶运算符优先级大于当前运算符优先级
                if (topPriority >= currentPriority) {
                    [self evaluateTop:numStack opStack:opStack];
                } else {
                    break;
                }
            }
            [opStack addObject:currentOp];
        } else if ([ch isEqualToString: @"("]) {
            [self.calculatorModel pushOperator: ch];
        } else if ([ch isEqualToString: @")"]) {
            // 如果是 ) ,一直计算直到遇到 (
            while (opStack.count > 0 && ![opStack.lastObject isEqualToString:@"("]) {
                [self evaluateTop:numStack opStack:opStack];
            
                if ([self.calculatorModel.downString isEqualToString:@"Error"]) {
                    return; 
                }
            }
            // 弹出左括号
            if (opStack.count > 0 && [opStack.lastObject isEqualToString:@"("]) {
                [opStack removeLastObject];
            }
        }
        
        while (self.calculatorModel.operatorsStack.count > 0) {
            [self evaluateTop: self.calculatorModel.numberStack opStack: self.calculatorModel.operatorsStack];
            if ([self.calculatorModel.downString isEqualToString:@"Error"]) {
                return;
            }
        }
        
        
        if (self.calculatorModel.numberStack.count == 0) {
            return;
        }
        
        NSDecimalNumber* result = [self.calculatorModel popNumber];
        
        self.calculatorModel.upString = [self.calculatorModel.downString mutableCopy];
        self.calculatorModel.downString = [NSMutableString stringWithFormat: @"%@", result];
    }
}


- (void)evaluateTop:(NSMutableArray *)numStack opStack:(NSMutableArray *)opStack {
    if (numStack.count < 2 || opStack.count == 0) {
        return;
    }
    NSDecimalNumber *right = [numStack lastObject]; [numStack removeLastObject];
    NSDecimalNumber *left = [numStack lastObject]; [numStack removeLastObject];
    NSString *op = [opStack lastObject]; [opStack removeLastObject];
    
    NSDecimalNumber *result = nil;
    if ([op isEqualToString:@"+"]) result = [left decimalNumberByAdding:right];
    else if ([op isEqualToString:@"-"]) result = [left decimalNumberBySubtracting:right];
    else if ([op isEqualToString:@"x"]) result = [left decimalNumberByMultiplyingBy:right];
    else if ([op isEqualToString:@"÷"]) {
        if ([right isEqualToNumber:[NSDecimalNumber zero]]) {
            // 除零错误
            self.calculatorModel.downString = [NSMutableString stringWithString:@"Error"];
            [self reloadLabels];
            return;
        }
        result = [left decimalNumberByDividingBy:right];
    }
    if (result) [numStack addObject:result];
}



//     点击退格
- (void) pressDelete02 {
//    NSLog(@"点击 delete");
    if (self.calculatorModel.upString.length > 0) {

//        // 下方的数字转换为字符串,退格
//        // 数字栈弹出前一个计算的答案, 放到临时字符串中继续编辑, 退格
//        NSDecimalNumber* number = [self.calculatorModel popNumber];
//        self.calculatorModel.temporaryString = [NSMutableString stringWithFormat: @"%@", number];
//        [self.calculatorModel.temporaryString deleteCharactersInRange: NSMakeRange(self.calculatorModel.temporaryString.length - 1, 1)];
//
//        // 将上面的字符转移下来, 上方清空
//        self.calculatorModel.downString = self.calculatorModel.upString;
//        [self.calculatorModel.upString setString: @""];
        
        [self removeAll];
        return;
    } else if (self.calculatorModel.downString.length > 0) {
        
        // 获取当前最后一个字符
        NSString* lastStr = [self.calculatorModel.downString substringFromIndex: self.calculatorModel.downString.length - 1];
        
        // 如果是数字或小数点, 直接删除临时字符串的最后一个字符
        if ([lastStr isEqualToString: @"."] || [self isNumber: lastStr]) {
            if ([lastStr isEqualToString: @"."]) {
                // 记录数字中的小数点个数
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
    
    if (self.calculatorModel.downString.length > 0) {
        NSString* lastStr = [self.calculatorModel.downString substringFromIndex: self.calculatorModel.downString.length - 1];
        // ) 后面直接接数字,输入无效
        if ([lastStr isEqualToString: @")"]) {
            return;
        }
    }
     
    // 如果已经存在小数点,输入无效
    if ([title isEqualToString: @"."]) {
        if (self.pointNum > 0) {
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





//// 执行计算
//- (void)calculate {
//    if (self.calculatorModel.numberStack.count < 2) {
//        return;
//    }
//    if (self.calculatorModel.operatorsStack.count == 0) {
//        return;
//    }
//    
//    // 弹出右操作数
//    NSDecimalNumber *right = [self.calculatorModel popNumber];
//    // 弹出左操作数
//    NSDecimalNumber *left = [self.calculatorModel popNumber];
//    
//    // 弹出运算符
//    NSString *op = [self.calculatorModel popOperator];
//    
//    NSDecimalNumber *result = nil;
//    
//    if ([op isEqualToString:@"+"]) {
//        result = [left decimalNumberByAdding:right];
//        
//    } else if ([op isEqualToString:@"-"]) {
//        result = [left decimalNumberBySubtracting:right];
//        
//    } else if ([op isEqualToString:@"x"]) {
//        result = [left decimalNumberByMultiplyingBy:right];
//        
//    } else if ([op isEqualToString:@"÷"]) {
//        
//        if ([right isEqualToNumber:[NSDecimalNumber zero]]) {
//            // 除零错误
//            self.calculatorModel.downString = [NSMutableString stringWithString:@"Error"];
//            [self reloadLabels];
//            return;
//        }
//        result = [left decimalNumberByDividingBy:right];
//    }
//    
//    if (result) {
//        [self.calculatorModel.numberStack addObject:result];
//        // 更新临时字符串
//        self.calculatorModel.temporaryString = [NSMutableString stringWithFormat:@"%@", result];
//    }
//}
//




















































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
