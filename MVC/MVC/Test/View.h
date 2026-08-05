//
//  View.h
//  MVC
//
//  Created by lose_sea on 2026/8/4.
//

#import <UIKit/UIKit.h>
#import <Masonry/Masonry.h> 
NS_ASSUME_NONNULL_BEGIN

@interface View : UIView


- (void)updateText:(NSString *)text;
- (void)setButtonTarget:(id)target action:(SEL)action;

@end

NS_ASSUME_NONNULL_END
