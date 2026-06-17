//
//  MenuController.h
//  Music
//
//  Created by lose_sea on 2026/6/15.
//

#import <UIKit/UIKit.h>
#import "MenuView.h"
#import "MenuModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface MenuViewController : UIViewController <UITableViewDelegate, UITableViewDataSource> 
@property (nonatomic, strong) MenuModel* menuModel;
@property (nonatomic, strong) MenuView* menuView;

@property (nonatomic, strong) UISwitch* mySwitch;
@end

NS_ASSUME_NONNULL_END
