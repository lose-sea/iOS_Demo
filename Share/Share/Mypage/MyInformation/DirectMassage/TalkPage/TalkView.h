//
//  TalkView.h
//  Share
//
//  Created by lose_sea on 2026/6/3.
//

#import <UIKit/UIKit.h>
#import <Masonry/Masonry.h>
#import "TalkCell.h"

NS_ASSUME_NONNULL_BEGIN

@interface TalkView : UIView
@property (nonatomic, strong) UITableView* tableView;

@property (nonatomic, strong) UITextView* textView;

@property (nonatomic, strong) UIButton* sendButton; 
@end

NS_ASSUME_NONNULL_END
