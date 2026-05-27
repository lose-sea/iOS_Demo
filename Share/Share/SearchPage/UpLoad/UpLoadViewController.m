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
    self.title = @"文章上传"; 
    [self setData];
    [self setnavigation];
    // Do any additional setup after loading the view.
}


- (void) setData {
    self.upLoadModel = [[UpLoadModel alloc] init];
    [self.upLoadModel.tags addObjectsFromArray: @[@"设计资料", @"原创作品", @"设计教程", @"设计前观点"]];
    [self.upLoadModel.categorys addObjectsFromArray: @[@"平面设计", @"网页设计", @"UI", @"插画/手绘", @"虚拟与设计", @"影视", @"摄影", @"其他"]];
    
    self.upLoadModel.isFold = YES;
    self.upLoadModel.agreeDownLoad = YES; 
    
    
    self.upLoadView = [[UpLoadView alloc] init];
    [self.view addSubview: self.upLoadView];
    [self.upLoadView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.view);
    }];
    self.upLoadView.tagTableView.delegate = self;
    self.upLoadView.tagTableView.dataSource = self;
    
    self.upLoadView.collectionView.delegate = self;
    self.upLoadView.collectionView.dataSource = self;
    
    self.upLoadView.textView.delegate = self;
    
    [self.upLoadView.agreeDownLoadButton addTarget: self action: @selector(pressForbiddenLoadDown) forControlEvents: UIControlEventTouchUpInside];
    
    [self.upLoadView.coverViewButton addTarget: self action: @selector(pressCoverButton) forControlEvents: UIControlEventTouchUpInside];
}
- (void) pressCoverButton {
    [self.upLoadView endEditing: YES];
    ImageShowController* vc = [[ImageShowController alloc] init];
    [self.navigationController pushViewController: vc animated: YES];
}

- (void) pressForbiddenLoadDown {
    [self.upLoadView endEditing: YES];
    self.upLoadModel.agreeDownLoad = !self.upLoadModel.agreeDownLoad;
    if (self.upLoadModel.agreeDownLoad == NO) {
        [self.upLoadView.agreeDownLoadButton setImage: [UIImage systemImageNamed: @"checkmark.rectangle"] forState: UIControlStateNormal];
    } else {
        [self.upLoadView.agreeDownLoadButton setImage: [UIImage systemImageNamed: @"square"] forState: UIControlStateNormal];
    }
}
- (void) setnavigation {
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
    [self.upLoadView endEditing: YES];
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
    [self.upLoadView endEditing: YES];
    [tableView deselectRowAtIndexPath: indexPath animated: YES];
    NSString* tag = self.upLoadModel.tags[indexPath.row];
    [self.upLoadModel.tags removeObjectAtIndex: indexPath.row];
    [self.upLoadModel.tags insertObject: tag atIndex: 0];
    self.upLoadModel.isFold = !self.upLoadModel.isFold;
    [self.upLoadView.tagTableView reloadData];
}

- (NSInteger) collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 8;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    tagCollectionVIewCell* cell = [collectionView dequeueReusableCellWithReuseIdentifier: @"collectionViewCellID" forIndexPath: indexPath];
    cell.label.text = self.upLoadModel.categorys[indexPath.item];
    cell.label.textAlignment = NSTextAlignmentCenter;
    cell.backgroundColor = [UIColor whiteColor];
    return cell;
}

- (void) collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [self.upLoadView endEditing: YES];
    tagCollectionVIewCell* cell = [collectionView cellForItemAtIndexPath: indexPath];
    if (cell.backgroundColor == [UIColor whiteColor]) {
        cell.backgroundColor = [UIColor blueColor];
        cell.label.textColor = [UIColor whiteColor];
    } else {
        cell.backgroundColor = [UIColor whiteColor];
        cell.label.textColor = [UIColor blackColor];
    }
}

- (void) textViewDidChange:(UITextView *)textView {
    self.upLoadView.label.hidden = YES;
}

- (void) touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.upLoadView endEditing: YES];
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
