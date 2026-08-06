//
//  ViewController.m
//  UIImagePickController
//
//  Created by lose_sea on 2026/8/6.
//

#import "ViewController.h"
#import <Masonry/Masonry.h>
@interface ViewController () <UINavigationControllerDelegate, UIImagePickerControllerDelegate>

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    UIButton* button = [UIButton buttonWithType: UIButtonTypeSystem];
    [self.view addSubview: button];
    [button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.view).offset(50);
        make.left.mas_equalTo(self.view).offset(50);
        make.width.height.mas_equalTo(100);
    }];
    button.backgroundColor = [UIColor systemRedColor];
    [button setTitle: @"选择图片" forState: UIControlStateNormal];
    [button addTarget: self action: @selector(pressButton) forControlEvents: UIControlEventTouchUpInside];
}

- (void) pressButton {
    UIImagePickerController* imagePicerkController = [[UIImagePickerController alloc] init];
    imagePicerkController.delegate = self;
    
    //  选择图片来源: 相册
    imagePicerkController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    
    // 展示UIiamgePickerController
    [self presentViewController: imagePicerkController animated: YES completion: nil];
}


- (void) imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<UIImagePickerControllerInfoKey,id> *)info {
    
    UIImage* image = info[UIImagePickerControllerOriginalImage];
    
    // 显示在 ImageView 上
    UIImageView* imageView = [[UIImageView alloc] initWithImage: image];
    [self.view addSubview: imageView];
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(self.view);
        make.width.height.mas_equalTo(200);
    }];
    imageView.backgroundColor = [UIColor systemCyanColor];
    
    [picker dismissViewControllerAnimated: YES completion: nil];
}


@end
