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
    [self setData];
    [self setCollectionView];
    
    // Do any additional setup after loading the view.
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
    self.imageShowModel = [ImageShowModel alloc];
    self.imageShowView = [[ImageShowView alloc] init];
    for (int i = 10; i <= 30; i++) {
        NSString* imageName = [NSString stringWithFormat: @"%d.jpg", i];
        UIImage* image = [UIImage imageNamed: imageName];
        [self.imageShowModel.images addObject: image];
    }
}

- (NSInteger) collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.imageShowModel.images.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell* cell = [collectionView dequeueReusableCellWithReuseIdentifier: @"collectionViewCellID" forIndexPath: indexPath];
    UIImageView* iView = [[UIImageView alloc] initWithImage: self.imageShowModel.images[indexPath.item]];
    cell.backgroundView = iView;
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
