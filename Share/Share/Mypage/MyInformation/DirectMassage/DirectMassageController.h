//
//  DirectMassageController.h
//  Share
//
//  Created by lose_sea on 2026/6/2.
//

#import <UIKit/UIKit.h>
#import "DirectMassageModel.h"
#import "DirectMassageView.h"

NS_ASSUME_NONNULL_BEGIN

@interface DirectMassageController : UIViewController <UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) DirectMassageModel* directMassageModel;
@property (nonatomic, strong) DirectMassageView* directMassageView;

@end

NS_ASSUME_NONNULL_END
