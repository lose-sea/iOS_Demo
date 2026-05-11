//
//  Mypage.h
//  zara
//
//  Created by lose_sea on 2026/5/5.
//

#import <UIKit/UIKit.h>
#import <Masonry/Masonry.h>
#import "Personal_Information.h"

NS_ASSUME_NONNULL_BEGIN

@interface Mypage : UIViewController <UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UIImage* avatar;
@end

NS_ASSUME_NONNULL_END
