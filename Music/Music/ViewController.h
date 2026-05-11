//  ViewController.h
//  NetEaseMusicDemo
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController <UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UIScrollViewDelegate>

@property (nonatomic, strong) UIScrollView *mainScrollView;
@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, strong) NSMutableArray *bannerImages;
@property (nonatomic, strong) NSMutableArray *recommendPlaylists;
@property (nonatomic, strong) NSMutableArray *hotSongs;

@end
