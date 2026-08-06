//
//  ViewController.m
//  UIImagePickController
//
//  Created by lose_sea on 2026/8/6.
//

#import "ViewController.h"
#import <Masonry/Masonry.h>
@interface ViewController () <UINavigationControllerDelegate, UIImagePickerControllerDelegate>
@property (nonatomic, strong) UIImageView* imageView;
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
    
    // 显示在 ImageView 上
    UIImageView* imageView = [[UIImageView alloc] init];
    [self.view addSubview: imageView];
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(self.view);
        make.width.height.mas_equalTo(200);
    }];
    imageView.backgroundColor = [UIColor systemCyanColor];
    self.imageView = imageView;
}

- (void) pressButton {
    UIImagePickerController* imagePickerController = [[UIImagePickerController alloc] init];
    imagePickerController.delegate = self;
//    imagePickerController.allowsEditing = YES;
    //  选择图片来源: 相册
    imagePickerController.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
    
    // 展示UIiamgePickerController
    [self presentViewController: imagePickerController animated: YES completion: nil];
}


- (void) imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<UIImagePickerControllerInfoKey,id> *)info {
    
//    UIImage* image = info[UIImagePickerControllerOriginalImage];
    
    // 获取编辑后的图片（如果 allowsEditing = YES）
    UIImage *editedImage = info[UIImagePickerControllerOriginalImage];
    
    self.imageView.image = editedImage;
    
    [picker dismissViewControllerAnimated: YES completion: nil];
    
    // 获取图片的原始元数据
    NSDictionary *metadata = info[UIImagePickerControllerMediaMetadata];
    NSLog(@"%@", metadata);
    
    // 获取图片URL（如果是视频）
    NSURL *mediaURL = info[UIImagePickerControllerMediaURL];
    NSLog(@"%@", mediaURL);
    
    // 获取媒体类型
    NSString *mediaType = info[UIImagePickerControllerMediaType];
    NSLog(@"%@", mediaType); 
    
    NSLog(@"choose");
}

- (void) imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    NSLog(@"cancel");
    [picker dismissViewControllerAnimated: YES completion: nil];
}


@end
