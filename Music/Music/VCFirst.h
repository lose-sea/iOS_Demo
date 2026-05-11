//
//  VCFirst.h
//  Music
//
//  Created by lose_sea on 2026/4/29.
//

#import <UIKit/UIKit.h>
#import <Masonry/Masonry.h>

NS_ASSUME_NONNULL_BEGIN

@interface VCFirst : UIViewController <UICollectionViewDelegate, UICollectionViewDataSource>
@property (nonatomic) UIScrollView* scrollView;
@property (nonatomic) NSMutableArray* array;
@end

NS_ASSUME_NONNULL_END
