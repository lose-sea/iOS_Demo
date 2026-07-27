//
//  CalculatorModel.h
//  calculator
//
//  Created by lose_sea on 2026/7/27.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface CalculatorModel : NSObject
@property (nonatomic, strong) NSMutableString* upString;
@property (nonatomic, strong) NSMutableString* downString;

@property (nonatomic, strong) NSMutableString* temporaryString; 

@property (nonatomic, strong) NSMutableArray* numberStack;
@property (nonatomic, strong) NSMutableArray* operatorsStack;

@property (nonatomic, strong) NSMutableString* resultString; 

- (void) pushNumber: (NSString*) number;
- (NSDecimalNumber*) popNumber;

- (void) pushOperator: (NSString*) operation;
- (NSString*) popOperator;

@end

NS_ASSUME_NONNULL_END
