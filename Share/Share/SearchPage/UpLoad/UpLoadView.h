//
//  UpLoadView.h
//  Share
//
//  Created by lose_sea on 2026/5/26.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UpLoadView : UIView

@property (nonatomic, strong) UILabel* locationLabel;
@property (nonatomic, strong) UITableView* tagTableView;
@property (nonatomic, strong) UICollectionView* collectionView;
@property (nonatomic, strong) UIImageView* coverView;
@property (nonatomic, strong) UITextField* textField;
@property (nonatomic, strong) UITextView* textView;
@property (nonatomic, strong) UIButton* agreeDownLoadButton;
@property (nonatomic, strong) UIButton* upLoadButton;
@property (nonatomic, strong) UILabel* forbiddenDownLoad;

@end

NS_ASSUME_NONNULL_END
