//
//  ViewController.h
//  WCDB test
//
//  Created by lose_sea on 2026/8/8.
//

#import <UIKit/UIKit.h>
#import "View.h"
#import "MyWCDB.h"

@interface ViewController : UIViewController
@property (nonatomic, strong) MyWCDB* myWCDB; 
@property (nonatomic, strong) View* testview;

@end

