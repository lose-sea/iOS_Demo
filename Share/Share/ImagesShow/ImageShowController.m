//
//  ImageShowController.m
//  Share
//
//  Created by lose_sea on 2026/5/26.
//

#import "ImageShowController.h"

@interface ImageShowController ()

@end

@implementation ImageShowController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"选择图片";
    [self setData];
    [self setCollectionView];
    [self setNavigation];
    // Do any additional setup after loading the view.
}

- (void) setNavigation {
    UIBarButtonItem* upload = [[UIBarButtonItem alloc] initWithTitle: @"上传" style: UIBarButtonItemStylePlain target: self action: @selector(pressUpload)];
    self.navigationItem.rightBarButtonItem = upload;
}

- (void) pressUpload {
    self.alertController = [UIAlertController alertControllerWithTitle: nil message: @"确定上传所选内容" preferredStyle: UIAlertControllerStyleAlert];

    UIAlertAction* cacelAction = [UIAlertAction actionWithTitle: @"取消" style: UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        NSLog(@"取消");
    }];
    [self.alertController addAction: cacelAction];
    UIAlertAction* okAction = [UIAlertAction actionWithTitle: @"确定" style: UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        NSLog(@"确定");
        if ([self.delegate respondsToSelector: @selector(configConverImage:)]) {
            [self.delegate configConverImage: self.selectImages];
            [self.navigationController popViewControllerAnimated: YES]; 
        }
        
    }];
    [self.alertController addAction: okAction];
    
    [self presentViewController: self.alertController animated: YES completion: nil];
}


- (void) setCollectionView {
    [self.view addSubview: self.imageShowView];
    [self.imageShowView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(self.view);
    }];
    self.imageShowView.collectionView.delegate = self;
    self.imageShowView.collectionView.dataSource = self; 
}

- (void) setData {
    self.imageShowModel = [[ImageShowModel alloc] init];
    self.imageShowView = [[ImageShowView alloc] init];
    self.selectImages = [[NSMutableArray alloc] init];
    
    for (int i = 1; i < 40; i++) {
        NSString* imageName = [NSString stringWithFormat: @"%d.jpg", i + 1];
        UIImage* image = [UIImage imageNamed: imageName];
        [self.imageShowModel.images addObject: image];
    }
}

- (NSInteger) collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.imageShowModel.images.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    ImageShowCell* cell = [collectionView dequeueReusableCellWithReuseIdentifier: @"collectionViewCellID" forIndexPath: indexPath];
    cell.iView.image = self.imageShowModel.images[indexPath.item];
    cell.iView.contentMode = UIViewContentModeScaleAspectFill;
    cell.iView.clipsToBounds = YES;
    cell.selectedLabel.hidden = NO;
    UIImage* image = cell.iView.image;
    if ([self.selectImages containsObject: image]) {
        cell.selectedLabel.text = [NSString stringWithFormat: @"%lu", (unsigned long)[self.selectImages indexOfObject: cell.iView.image] + 1];
    } else {
        cell.selectedLabel.hidden = YES;
    }
    
    return cell;
}

- (void) collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    ImageShowCell* cell = [collectionView cellForItemAtIndexPath: indexPath];
    cell.isSelected = !cell.isSelected;
    if ([self.selectImages containsObject: cell.iView.image]) {
        [self.selectImages removeObject: cell.iView.image];
    } else {
        [self.selectImages addObject: cell.iView.image];
    }
    [self.imageShowView.collectionView reloadData];
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
