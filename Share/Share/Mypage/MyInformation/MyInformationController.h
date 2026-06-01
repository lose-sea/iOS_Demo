//
//  MyInformationController.h
//  Share
//
//  Created by lose_sea on 2026/6/1.
//

#import <UIKit/UIKit.h>
#import "MyInformationView.h"
#import "MyImformationModel.h"
#import "Information.h"

NS_ASSUME_NONNULL_BEGIN

@interface MyInformationController : UIViewController <UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) MyInformationView* myInformationView;
@property (nonatomic, strong) MyImformationModel* myImformationModel;
@end

NS_ASSUME_NONNULL_END
