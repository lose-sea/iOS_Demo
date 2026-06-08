//
//  MessageSettingCell.h
//  Share
//
//  Created by lose_sea on 2026/6/8.
//

#import <UIKit/UIKit.h>
#import <Masonry/Masonry.h>
#import "Message.h"

NS_ASSUME_NONNULL_BEGIN

@interface MessageSettingCell : UITableViewCell
@property (nonatomic, strong) UILabel* messageLabel;
@property (nonatomic, strong) UIButton* selectButton;
@property (nonatomic, strong) Message* message; 

- (void) configWithMessage: (Message*) message; 
@end

NS_ASSUME_NONNULL_END
