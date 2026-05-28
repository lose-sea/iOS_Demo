//
//  UpLoadViewController.h
//  Share
//
//  Created by lose_sea on 2026/5/26.
//

#import <UIKit/UIKit.h>
#import "UpLoadModel.h"
#import "UpLoadView.h"
#import "tagCollectionVIewCell.h"
#import "ImageShowController.h"
NS_ASSUME_NONNULL_BEGIN

@interface UpLoadViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, UICollectionViewDelegate, UICollectionViewDataSource, UITextViewDelegate, ImageShowDelegate>
@property (nonatomic, strong) UpLoadModel* upLoadModel;
@property (nonatomic, strong) UpLoadView* upLoadView;
@property (nonatomic, strong) UIImage* coverImage;
@property (nonatomic, strong) UIAlertController* alertController;
@end

NS_ASSUME_NONNULL_END
