//
//  SearchResultShowController.m
//  Share
//
//  Created by lose_sea on 2026/5/25.
//

#import "SearchResultShowController.h"

@interface SearchResultShowController ()

@end

@implementation SearchResultShowController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
}

- (void) setData {
    self.searchPageModel = [[SearchPageModel alloc] init];
    self.searchResultShowView = [[SearchResultShowView alloc] init];
    self.searchResultShowView.tableView.delegate = self;
    self.searchResultShowView.tableView.dataSource = self; 
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
