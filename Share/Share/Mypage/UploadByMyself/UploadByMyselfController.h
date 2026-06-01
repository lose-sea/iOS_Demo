//
//  UploadByMyselfController.h
//  Share
//
//  Created by lose_sea on 2026/5/31.
//

#import <UIKit/UIKit.h>
#import "UploadByMyselfModel.h"
#import "UploadByMyselfView.h"

NS_ASSUME_NONNULL_BEGIN

@interface UploadByMyselfController : UIViewController <UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate> 
@property (nonatomic, strong) UploadByMyselfModel* upLoadModel;
@property (nonatomic, strong) UploadByMyselfView* upLoadView; 
@end

NS_ASSUME_NONNULL_END
