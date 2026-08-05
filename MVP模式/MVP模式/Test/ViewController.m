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
    [self setUpPresenter];
//    [self loadView];
//    [self userDidTapRefresh];
//    [self controlView];
    

}

- (void) setUpData {
//    self.model = [[ViewModel alloc] init];
//    self.model.text = @"hello xinyan";
    
    self.testView = [[View alloc] init];
}

- (void) setUpInterface {
    [self.view addSubview: self.testView];
    [self.testView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.view);
    }];
    
    [self.testView.button addTarget: self action: @selector(userDidTapRefresh) forControlEvents: UIControlEventTouchUpInside];
}


// 实现协议方法
- (void) setUpPresenter {
    // 创建Presenter时, 将 self 注入
    self.presenter = [[ViewPresenter alloc] initWithView: self];
    
    // 告诉 Presenter 开始加载数据
    [self.presenter loadData];
}


- (void) displayText:(NSString *)text {
    self.testView.label.text = text;
}


- (void) userDidTapRefresh {
    [self.presenter updateDataWithNewText: @"Refreshed Data"]; 
}

//- (void) controlView {
//    self.testView.label.text = self.model.text;
//}


@end
