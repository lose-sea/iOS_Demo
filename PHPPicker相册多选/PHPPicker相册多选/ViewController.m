//
//  ViewController.m
//  UIImagePickController
//
//  Created by lose_sea on 2026/8/6.
//

#import "ViewController.h"
#import <Masonry/Masonry.h>
#import <PhotosUI/PhotosUI.h>
#import <MobileCoreServices/MobileCoreServices.h>
@interface ViewController () <PHPickerViewControllerDelegate>
@property (nonatomic, strong) UIImageView* imageView;
@property (nonatomic, strong) NSMutableArray* images;
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
    [button addTarget: self action: @selector(selectMultipleImages) forControlEvents: UIControlEventTouchUpInside];
    
    // 显示在 ImageView 上
    UIImageView* imageView = [[UIImageView alloc] init];
    [self.view addSubview: imageView];
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(self.view);
        make.width.height.mas_equalTo(200);
    }];
    imageView.backgroundColor = [UIColor systemCyanColor];
    self.imageView = imageView;
    
    
    self.images = [[NSMutableArray alloc] init];
}


- (void)selectMultipleImages {
//    // 创建配置
//    PHPickerConfiguration *configuration = [[PHPickerConfiguration alloc] init];
//    
//    // 设置选择类型：图片
//    configuration.filter = [PHPickerFilter imagesFilter];
//    
//    // 设置最大选择数量（0 表示无限制）
//    configuration.selectionLimit = 10;
//    
//    // 是否允许选择 Live Photos
//    configuration.preferredAssetRepresentationMode = PHPickerConfigurationAssetRepresentationModeCurrent;
//    
//    // 创建选择器
//    PHPickerViewController *picker = [[PHPickerViewController alloc] initWithConfiguration:configuration];
//    picker.delegate = self;
//    [self presentViewController:picker animated:YES completion:nil];
    
    
    // 创建配置
    PHPickerConfiguration* config = [[PHPickerConfiguration alloc] init];
    // 设置筛选类型: 图片
    config.filter = [PHPickerFilter imagesFilter];
        // 设置最大选择数量 (0 表示不限制)
    config.selectionLimit = 3;
        // 创建并展示选择器
    PHPickerViewController* picker = [[PHPickerViewController alloc] initWithConfiguration: config];
    picker.delegate = self;
    [self presentViewController:picker animated:YES completion:nil];
}



- (void)picker:(PHPickerViewController *)picker didFinishPicking:(NSArray<PHPickerResult *> *)results {
    [picker dismissViewControllerAnimated:YES completion:nil];
    
    if (results.count == 0) {
        NSLog(@"cancel"); 
        return;
    }
    
    // 处理选中的图片
    for (PHPickerResult *result in results) {
        // 获取 UIImage
        if ([result.itemProvider canLoadObjectOfClass:[UIImage class]]) {
            [result.itemProvider loadObjectOfClass:[UIImage class]
                                 completionHandler:^(__kindof id<NSItemProviderReading>  _Nullable object,
                                                     NSError * _Nullable error) {
                if (error) {
                    NSLog(@"加载图片失败: %@", error);
                    return;
                }
                
                UIImage *image = (UIImage *)object;
                [self.images addObject: image];
                // 在主线程更新 UI
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self displayImage];
                });
            }];
        }
        
    }
}




- (void)displayImage {
    // 显示图片
    self.imageView.contentMode = UIViewContentModeScaleAspectFit;
    for (NSInteger i = 0; i < self.images.count; i++) {
        UIImageView* imageView = [[UIImageView alloc] initWithImage: [self.images objectAtIndex: i]];
        [self.view addSubview: imageView];
        [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo(self.view).offset(200 * i + 199);
                make.left.mas_equalTo(self.view).offset(200);
                make.width.height.mas_equalTo(100);
        }];
    }
}


@end
