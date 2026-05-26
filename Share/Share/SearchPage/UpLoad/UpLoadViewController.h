//
//  UpLoadViewController.h
//  Share
//
//  Created by lose_sea on 2026/5/26.
//

#import <UIKit/UIKit.h>
#import "UpLoadModel.h"
#import "UpLoadView.h"

NS_ASSUME_NONNULL_BEGIN

@interface UpLoadViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UpLoadModel* upLoadModel;
@property (nonatomic, strong) UpLoadView* upLoadView; 
@end

NS_ASSUME_NONNULL_END
