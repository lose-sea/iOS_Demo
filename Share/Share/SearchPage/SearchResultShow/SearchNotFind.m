//
//  SearchNotFind.m
//  Share
//
//  Created by lose_sea on 2026/5/25.
//

#import "SearchNotFind.h"

@interface SearchNotFind ()

@end

@implementation SearchNotFind

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor systemBackgroundColor];
    UILabel* label = [[UILabel alloc] init];
    label.text = @"没有找到相关信息";
    label.textColor = [UIColor labelColor];
    [self.view addSubview: label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(self.view).insets(UIEdgeInsetsMake(300, 0, 400, 0));
    }];
    label.font = [UIFont systemFontOfSize:40];
    label.textAlignment = NSTextAlignmentCenter;
    // Do any additional setup after loading the view.
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
