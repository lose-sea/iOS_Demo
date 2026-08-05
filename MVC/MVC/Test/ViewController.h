//
//  ViewController.h
//  MVC
//
//  Created by lose_sea on 2026/8/4.
//

#import <UIKit/UIKit.h>
#import "View.h"
#import "Model.h"

@interface ViewController : UIViewController 

@property (nonatomic, strong) Model* model;

@property (nonatomic, strong) View* testView;

@end

