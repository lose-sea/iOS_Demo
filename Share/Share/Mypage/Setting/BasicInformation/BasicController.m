//
//  BasicController.m
//  Share
//
//  Created by lose_sea on 2026/6/4.
//

#import "BasicController.h"

@interface BasicController ()

@end

@implementation BasicController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"基本资料";
    // Do any additional setup after loading the view.
    [self setUpData];
}

- (void) setUpData {
    self.basicView = [[BasicView alloc] init];
    self.basicModel = [[BasicModel alloc] init]; 
    self.user = [[UserModel alloc] init];
    
    [self.view addSubview: self.basicView];
    [self.basicView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.view);
    }];
    
    self.basicView.tableView.delegate = self;
    self.basicView.tableView.dataSource = self;
}


- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 5;
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
