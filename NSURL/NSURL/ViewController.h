//
//  ViewController.h
//  NSURL
//
//  Created by lose_sea on 2026/7/14.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController
<
UITextFieldDelegate,
UITableViewDelegate,
UITableViewDataSource,
NSURLSessionDelegate
>

@property (nonatomic, strong) UITextField* textField;
@property (nonatomic, strong) UITableView* tableView;
@property (nonatomic, strong) NSMutableData* data;
@property (nonatomic, strong) NSMutableArray* cityArray; 

@end

