//
//  CalculatorViewController.h
//  calculator
//
//  Created by lose_sea on 2026/7/27.
//

#import <UIKit/UIKit.h>
#import "CalculatorModel.h"
#import "CalculatorView.h"

NS_ASSUME_NONNULL_BEGIN

@interface CalculatorViewController : UIViewController
@property (nonatomic, strong) CalculatorModel* calculatorModel;
@property (nonatomic, strong) CalculatorView* calculatorView;
@end

NS_ASSUME_NONNULL_END
