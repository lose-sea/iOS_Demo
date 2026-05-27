//
//  ImageShowController.h
//  Share
//
//  Created by lose_sea on 2026/5/26.
//

#import <UIKit/UIKit.h>
#import "ImageShowModel.h"
#import "ImageShowView.h"
#import <Masonry/Masonry.h>
#import "ImageShowCell.h"



@interface ImageShowController : UIViewController <UICollectionViewDelegate, UICollectionViewDataSource>
@property (nonatomic, strong) ImageShowView* imageShowView;
@property (nonatomic, strong) ImageShowModel* imageShowModel;
@property (nonatomic, strong) UIAlertController* alertController;
@end


