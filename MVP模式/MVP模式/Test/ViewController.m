//
//  ViewController.m
//  MVC
//
//  Created by lose_sea on 2026/8/4.
//

#import "ViewController.h"

@interface ViewController ()

// 不再持有 Model, 改为持有 Presenter
@property (nonatomic, strong) ViewPresenter* presenter;

@property (nonatomic, strong) View* testView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setUpData];
    [self setUpInterface];
    [self setUpPresenter];
    

}

- (void) setUpData {
    self.testView = [[View alloc] init];
    
}

- (void) setUpInterface {
    [self.view addSubview: self.testView];
    [self.testView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.view);
    }];
    
    [self.testView setButtonTarget: self action: @selector(pressButton)];
}


// 实现协议方法
- (void) setUpPresenter {
    // 创建Presenter时, 将 view 注入
    self.presenter = [[ViewPresenter alloc] initWithView: self.testView];
    
    // 告诉 Presenter 开始加载数据
    [self.presenter loadData];
}



- (void) pressButton {
    [self.presenter refreshData];
}


@end
