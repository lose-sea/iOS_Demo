//
//  CalculatorModel.m
//  calculator
//
//  Created by lose_sea on 2026/7/27.
//

#import "CalculatorModel.h"

@implementation CalculatorModel
- (instancetype) init {
    self = [super init];
    if (self) {
        [self setUpData];
    }
    return self;
}

- (void) setUpData {
    self.upString = [NSMutableString string];
    self.downString = [NSMutableString string];
    self.resultString = [NSMutableString string];
    
    self.temporaryString = [NSMutableString string]; 
    
    self.numberStack = [[NSMutableArray alloc] init];
    self.operatorsStack = [[NSMutableArray alloc] init];
}


- (void) pushNumber: (NSString*) number {
    NSDecimalNumber* num = [NSDecimalNumber decimalNumberWithString: number];
    [self.numberStack addObject: num];
}

- (NSDecimalNumber*) popNumber {
    NSDecimalNumber* number = [self.numberStack lastObject];
    [self.numberStack removeLastObject];
    return number;
}

- (void) pushOperator: (NSString*) operation {
    [self.operatorsStack addObject: operation];
}
- (NSString*) popOperator {
    NSString* operator = [self.operatorsStack lastObject];
    [self.operatorsStack removeLastObject];
    return operator;
}
@end
