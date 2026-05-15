//
//  Mypage.h
//  zara
//
//  Created by lose_sea on 2026/5/5.
//

#import <UIKit/UIKit.h>
#import <Masonry/Masonry.h>
#import "Personal_Information.h"
#import "CustomCell.h"
#import "Model.h" 

NS_ASSUME_NONNULL_BEGIN

@interface Mypage : UIViewController <UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UIImage* avatar;
@property (nonatomic, strong) NSString* account;
@property (nonatomic, strong) NSString* NickName;
@property (nonatomic, strong) NSString* signature;
@end

NS_ASSUME_NONNULL_END
