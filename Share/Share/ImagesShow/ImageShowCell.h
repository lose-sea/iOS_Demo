//
//  ImageShowCell.h
//  Share
//
//  Created by lose_sea on 2026/5/27.
//

#import <UIKit/UIKit.h>
#import <Masonry/Masonry.h>



@interface ImageShowCell : UICollectionViewCell
@property (nonatomic, assign) BOOL isSelected;
@property (nonatomic, strong) UIImageView* iView; 
@property (nonatomic, strong) UIImageView* selectImageView;
@property (nonatomic, strong) UILabel* selectedLabel;
@end


