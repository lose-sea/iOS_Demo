//
//  MypageController.h
//  zara
//
//  Created by lose_sea on 2026/5/16.
//

#import <UIKit/UIKit.h>
#import "UserModel.h"
#import "Mypage.h"

NS_ASSUME_NONNULL_BEGIN

@interface MypageController : UIViewController
     
@property (nonatomic, strong) UserModel* model;
@property (nonatomic, strong) Mypage* mypage;

@end

NS_ASSUME_NONNULL_END
