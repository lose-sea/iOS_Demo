//
//  ViewController.m
//  MVC
//
//  Created by lose_sea on 2026/8/4.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setUpData];
    [self setUpInterface];
}

- (void) setUpData {
    self.model = [[Model alloc] init];
    self.model.text = @"hello xinyan";
    
    self.testView = [[View alloc] init];
}

- (void) setUpInterface {
    [self.view addSubview: self.testView];
    [self.testView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.view);
    }];
    
    [self.testView setButtonTarget: self action:@selector(pressButton)]; 
}


- (void)pressButton {
    [self.testView updateText:self.model.text];
}



@end
