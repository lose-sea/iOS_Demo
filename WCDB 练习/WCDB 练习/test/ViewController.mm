//
//  ViewController.m
//  WCDB test
//
//  Created by lose_sea on 2026/8/8.
//

#import "ViewController.h"

@interface ViewController ()

@property (nonatomic, strong) WCTDatabase* dataBase;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    NSLog(@"%@", self.myWCDB.text);
    [self setUpData];
}



- (void) setUpData {
    self.myWCDB = [[MyWCDB alloc] init];
    self.testview = [[View alloc] init];
}

- (void) updateData {
    self.myWCDB.text = @"xinyan";
    self.myWCDB.array = @[@"xinyan", @"hello"];
}

@end
