//
//  UpLoadViewController.m
//  Share
//
//  Created by lose_sea on 2026/5/26.
//

#import "UpLoadViewController.h"

@interface UpLoadViewController ()

@end

@implementation UpLoadViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setData];
    [self setInterface];
    // Do any additional setup after loading the view.
}

- (void) setData {
    self.upLoadModel = [[UpLoadModel alloc] init];
    self.upLoadModel.tags = @[@"设计资料", @"原创作品", @"设计教程", @"设计前观点"];
    self.upLoadModel.categorys = @[@"平面设计", @"网页设计", @"UI", @"插画/手绘", @"虚拟与设计", @"影视", @"摄影", @"其他"];
    
    self.upLoadModel.isFold = YES;
    
    self.upLoadView = [[UpLoadView alloc] init];
    [self.view addSubview: self.upLoadView];
    [self.upLoadView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.view);
    }];
    self.upLoadView.tagTableView.delegate = self;
    self.upLoadView.tagTableView.dataSource = self;
}

- (void) setInterface {
    self.navigationController.navigationBar.translucent = NO;

}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.upLoadModel.isFold == YES) {
        return 1;
    }
    return self.upLoadModel.tags.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier: @"tagTableViewCellID" forIndexPath: indexPath];
    cell.textLabel.text = self.upLoadModel.tags[indexPath.row];
    cell.textLabel.font = [UIFont systemFontOfSize: 15];
    if (indexPath.row == 0) {
        UIButton* button = [UIButton buttonWithType: UIButtonTypeCustom];
        button.frame = CGRectMake(0, 0, 20, 20);
        if (self.upLoadModel.isFold == YES) {
            UIImage* image = [UIImage systemImageNamed:@"chevron.forward.circle.fill"];
            [button setImage: image forState: UIControlStateNormal];
        } else {
            UIImage* image = [UIImage systemImageNamed: @"chevron.up.circle.fill"];
            button.imageView.image = image;
            [button setImage: image forState: UIControlStateNormal];
        }
        [button addTarget: self action: @selector(pressFold) forControlEvents: UIControlEventTouchUpInside];
        cell.accessoryView = button;
        
    } else {
        cell.accessoryView = nil;
    }
    return cell;
}
    
- (void) pressFold {
    self.upLoadModel.isFold = !self.upLoadModel.isFold;
    [self.upLoadView.tagTableView reloadData];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 15;
}
    
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 20;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath: indexPath animated: YES]; 
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
