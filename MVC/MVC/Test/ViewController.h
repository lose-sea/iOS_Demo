//
//  ViewController.h
//  MVC
//
//  Created by lose_sea on 2026/8/4.
//

#import <UIKit/UIKit.h>
#import "View.h"
#import "ViewModel.h"
#import "ViewPresenter.h"


@interface ViewController : UIViewController <ViewProtocol>


//@property (nonatomic, strong) ViewModel* model;

// 不再持有 Model, 改为持有 Presenter
@property (nonatomic, strong) ViewPresenter* presenter;

@property (nonatomic, strong) View* testView;

@end

