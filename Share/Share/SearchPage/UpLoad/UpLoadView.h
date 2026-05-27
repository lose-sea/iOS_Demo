//
//  UpLoadView.h
//  Share
//
//  Created by lose_sea on 2026/5/26.
//

#import <UIKit/UIKit.h>
#import <Masonry/Masonry.h> 
#import "tagCollectionVIewCell.h"
NS_ASSUME_NONNULL_BEGIN

@interface UpLoadView : UIView

@property (nonatomic, strong) UIImageView* locationView;
@property (nonatomic, strong) UICollectionView* collectionView;
@property (nonatomic, strong) UIButton* coverViewButton;
@property (nonatomic, strong) UITextField* textField;
@property (nonatomic, strong) UITextView* textView;
@property (nonatomic, strong) UILabel* label; 
@property (nonatomic, strong) UIButton* agreeDownLoadButton;
@property (nonatomic, strong) UIButton* upLoadButton;
@property (nonatomic, strong) UILabel* forbiddenDownLoad;
@property (nonatomic, strong) UITableView* tagTableView;
@end

NS_ASSUME_NONNULL_END
