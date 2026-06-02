//
//  ImformationCell.h
//  Share
//
//  Created by lose_sea on 2026/6/1.
//

#import <UIKit/UIKit.h>
#import <Masonry/Masonry.h>
#import "Information.h"

NS_ASSUME_NONNULL_BEGIN

@interface ImformationCell : UITableViewCell
@property (nonatomic, strong) UILabel* label;

@property (nonatomic, strong) Information* information;

- (void) configWithInformation: (Information*) information;
@end

NS_ASSUME_NONNULL_END
