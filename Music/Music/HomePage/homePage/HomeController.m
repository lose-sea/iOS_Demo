//
//  HomeController.m
//  Music
//
//  Created by lose_sea on 2026/6/11.
//

#import "HomeController.h"
@interface HomeController ()

@end

@implementation HomeController      
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"推荐";
    
    // Do any additional setup after loading the view.
    
    [self setUpData];
}

- (void)setUpData {
    self.homeModel = [[HomeModel alloc] init];
    for (int i = 0; i < 10; i++) {
        NSString* imageName = [NSString stringWithFormat: @"%d", i + 1];
        UIImage* image = [UIImage imageNamed: imageName];
        [self.homeModel.recommendImages addObject: image];
    }
    
    for (int i = 0; i < 10; i++) {
        NSString* imageName = [NSString stringWithFormat: @"%d", i + 11];
        UIImage* image = [UIImage imageNamed: imageName];
        [self.homeModel.songersImages addObject: image];
    }
    
    self.homeView = [[HomeView alloc] init];
    [self.view addSubview: self.homeView];
    [self.homeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.view);
    }];
    
    self.homeView.tableView.delegate = self;
    self.homeView.tableView.dataSource = self;
}

- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}
 
- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return self.homeModel.recommendImages.count;
    } if (section == 1) {
        return self.homeModel.songersImages.count;
    } else {
        return 3;
    }
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
