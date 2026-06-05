//
//  ChangePasswordCell.h
//  Share
//
//  Created by lose_sea on 2026/6/5.
//

#import <UIKit/UIKit.h>
#import <Masonry/Masonry.h> 
NS_ASSUME_NONNULL_BEGIN

@interface ChangePasswordCell : UITableViewCell
@property (nonatomic, strong) UILabel* tagLabel;
@property (nonatomic, strong) UITextField* textField;

@property (nonatomic, strong) UILabel* warnLabel; 
@end

NS_ASSUME_NONNULL_END
