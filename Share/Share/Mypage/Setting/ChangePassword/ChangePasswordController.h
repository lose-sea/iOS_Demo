//
//  ChangePasswordController.h
//  Share
//
//  Created by lose_sea on 2026/6/5.
//

#import <UIKit/UIKit.h>
#import <Masonry/Masonry.h> 
#import "ChangePasswordCell.h"
#import "ChangePasswordView.h"
#import "ChangePasswordModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface ChangePasswordController : UIViewController <UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate> 
@property (nonatomic, strong) ChangePasswordView* changePasswordView;
@property (nonatomic, strong) ChangePasswordModel* changePasswordModel; 
@end

NS_ASSUME_NONNULL_END
