//
//  ActivityController.m
//  Share
//
//  Created by lose_sea on 2026/5/28.
//

#import "ActivityController.h"

@interface ActivityController ()

@end

@implementation ActivityController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"活动";
    // Do any additional setup after loading the view.
    
    [self setData];
    [self setTableView];
}

- (void) setTableView {
    [self.view addSubview: self.activityView];
    [self.activityView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.view).insets(UIEdgeInsetsMake(0, 0, 40, 0));
    }];
    
    self.activityView.tableView.delegate = self;
    self.activityView.tableView.dataSource = self;
}

- (void) setData {
    self.activityModel = [[ActivityModel alloc] init];
    self.activityView = [[ActivityView alloc] init];
    
    for (int i = 0; i < 7; i++) {
        NSString* imageName = [NSString stringWithFormat: @"%d.jpg", i + 30];
        UIImage* image = [UIImage imageNamed: imageName];
        NSString* massage = @"这个家伙很懒, 什么也没有留下";
        Activity* activity = [[Activity alloc] initWithImage: image massage: massage];
        if (i == 0) {
            activity.isEnd = NO; 
        }
        [self.activityModel.activities addObject: activity];
    }
    
    
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.activityModel.activities.count;
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 200; 
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath  {
    ActivityCell* cell = [tableView dequeueReusableCellWithIdentifier: @"ActivityCellID" forIndexPath: indexPath];
    Activity* activity = self.activityModel.activities[indexPath.row];
    cell.activity = activity;
    [cell configWithActivity: cell.activity];
    return cell;
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
