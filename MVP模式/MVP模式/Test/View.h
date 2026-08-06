//
//  View.h
//  MVC
//
//  Created by lose_sea on 2026/8/4.
//

#import <UIKit/UIKit.h>
#import <Masonry/Masonry.h> 
NS_ASSUME_NONNULL_BEGIN

@protocol ViewProtocol <NSObject>

- (void) displayText: (NSString*) text;
- (void) showLoading;
- (void) hideLoading;

@end



@interface View : UIView <ViewProtocol>


- (void) setButtonTarget: (id)target action: (SEL) action; 
@end

NS_ASSUME_NONNULL_END
