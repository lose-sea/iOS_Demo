//
//  CuntomCellController.h
//  zara
//
//  Created by lose_sea on 2026/5/16.
//

#import <UIKit/UIKit.h>
#import "CustomCell.h"
#import "UserModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface CuntomCellController : UIViewController
@property (nonatomic, strong) UserModel* model;
@property (nonatomic, strong) CustomCell* customCell; 
@end

NS_ASSUME_NONNULL_END
