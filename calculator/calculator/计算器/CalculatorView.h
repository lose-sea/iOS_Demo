//
//  CalculatorView.h
//  calculator
//
//  Created by lose_sea on 2026/7/27.
//

#import <UIKit/UIKit.h>
#import <Masonry/Masonry.h>
#import "CalculatorModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface CalculatorView : UIView
@property (nonatomic, strong) UILabel* upLabel;
@property (nonatomic, strong) UILabel* downLabel;

@property (nonatomic, strong) UIStackView* keyboard;
@end

NS_ASSUME_NONNULL_END
