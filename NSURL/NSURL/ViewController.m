//
//  ViewController.m
//  NSURL
//
//  Created by lose_sea on 2026/7/14.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.textField = [[UITextField alloc] init];
    self.textField.delegate = self;
    self.textField.frame = CGRectMake(50, 100, self.view.bounds.size.width - 100,  50);
    [self.view addSubview: self.textField];
    self.textField.borderStyle = UITextBorderStyleRoundedRect;
    self.textField.keyboardType = UIKeyboardTypeDefault;
    [self creatTableView];
}

- (void) creatTableView {
    self.tableView = [[UITableView alloc] init];
    
}


@end
