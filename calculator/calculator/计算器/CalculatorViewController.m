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
            [button addTarget: self action: @selector(pressBtn:) forControlEvents: UIControlEventAllEvents];
        }
    }
}

- (void) pressBtn: (UIButton*) button {
    
    NSString* title = button.currentTitle;
    if ([title isEqualToString: @"AC"]) {
        // 全部清空
        [self removeAll];
        return;
    } else if ([title isEqualToString: @"="]) {
        [self pressEqual];
        return;

    } else if ([title isEqualToString: @"⌫"]) {
        [self pressDelete];
    } else {
        if ([title isEqualToString: @"."] || [self isNumber: title]) {
            if (self.calculatorModel.upString.length > 0) {
                [self removeAll];
            }
            [self.calculatorModel.downString appendString: title];
            [self.calculatorModel.temporaryString appendString: title];
        } else {
            NSString* lastStr = [self.calculatorModel.downString substringFromIndex: self.calculatorModel.downString.length - 1];
            if ([self isOperator: lastStr]) {
                [self.calculatorModel popOperator];
                [self.calculatorModel pushOperator: title];
                [self.calculatorModel.downString deleteCharactersInRange: NSMakeRange(self.calculatorModel.downString.length - 1, 1)];
            } else {
                
            }
            
        }
        [self.calculatorModel.downString appendString: title];
    }
    self.calculatorView.upLabel.text = self.calculatorModel.upString;
    self.calculatorView.downLabel.text = self.calculatorModel.downString;
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
- (void) pressEqual {
    if (self.calculatorModel.upString.length == 0) {

        [self.calculatorModel pushNumber: self.calculatorModel.temporaryString];
        
        [self calculate];
        self.calculatorModel.downString = [NSMutableString stringWithFormat: @"%@", [self.calculatorModel.numberStack lastObject]];
        if (self.calculatorModel.resultString.length > 0) {
            self.calculatorView.downLabel.text = self.calculatorModel.resultString;
        }
    }
}

// 点击退格
- (void) pressDelete {
    if (self.calculatorModel.upString.length > 0) {
        
        // 下方的数字转换为字符串,退格
        NSDecimalNumber* number = [self.calculatorModel popNumber];
        self.calculatorModel.temporaryString = [NSMutableString stringWithFormat: @"%@", number];
        [self.calculatorModel.temporaryString deleteCharactersInRange: NSMakeRange(self.calculatorModel.temporaryString.length - 1, 1)];
        
        
        // 将上面的字符转移下来, 上方清空
        self.calculatorModel.downString = self.calculatorModel.upString;
        [self.calculatorModel.upString setString: @""];
        [self.calculatorModel.downString deleteCharactersInRange: NSMakeRange(self.calculatorModel.downString.length - 1, 1)];
    } else if (self.calculatorModel.downString.length > 0) {
        
        NSString* lastStr = [self.calculatorModel.downString substringFromIndex: self.calculatorModel.downString.length - 1];
        if ([self isOperator: lastStr]) {
            [self.calculatorModel popOperator];
            
            NSDecimalNumber* number = [self.calculatorModel.numberStack lastObject];
            self.calculatorModel.temporaryString = [NSMutableString stringWithFormat: @"%@", number];
            
        } else {
            
            [self.calculatorModel.temporaryString deleteCharactersInRange: NSMakeRange(self.calculatorModel.temporaryString.length - 1, 1)];
        }
        [self.calculatorModel.downString deleteCharactersInRange: NSMakeRange(self.calculatorModel.downString.length - 1, 1)];
    }
}



#pragma mark - 辅助方法
- (void) calculate {
    NSLog(@"calculator");
}

- (BOOL) isNumber: (NSString*)title {
    unichar ch = [title characterAtIndex: 0];
    return (ch >= '0' && ch <= '9');
}

- (BOOL) isOperator:(NSString *)op {
    return ([op isEqualToString:@"+"] || [op isEqualToString:@"-"] || [op isEqualToString:@"×"] || [op isEqualToString:@"÷"]);
}

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





@end
