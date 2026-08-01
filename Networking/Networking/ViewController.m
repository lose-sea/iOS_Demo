#import "ViewController.h"
// 导入 AFNetworking 的头文件
#import <AFNetworking/AFNetworking.h>
// 导入扩展头文件
#import "UIKit+AFNetworking.h"
#import <Masonry/Masonry.h>
#import <LookinServer/LookinServer.h>

@interface ViewController ()
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor systemRedColor];
    // 你可以在这里调用不同的示例方法进行测试
    [self sendGETRequest];
//     [self sendPOSTRequest];
//     [self uploadImage];
//     [self loadImageWithAFNetworking];
}

#pragma mark - 1. 发送 GET 请求
- (void)sendGETRequest {
    // 1. 创建会话管理器[reference:6]
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    // 2. 设置请求参数 (可选)[reference:7]
    NSDictionary *params = @{
        @"key": @"3557d02150d248e6b0735224252907",
        @"q": @"西安",
        @"days": @"1"
    };
    
    // 3. 发起 GET 请求[reference:8][reference:9]
    [manager GET:@"https://api.weatherapi.com/v1/forecast.json"
      parameters:params
        progress:nil
         success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        // 请求成功
        NSLog(@"GET 请求成功！响应数据: %@", responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        // 请求失败
        NSLog(@"GET 请求失败: %@", error);
    }];
}

#pragma mark - 2. 发送 POST 请求
- (void)sendPOSTRequest {
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    // POST 请求的参数
    NSDictionary *params = @{
        @"username": @"testuser",
        @"password": @"123456"
    };
    
    // 发起 POST 请求[reference:10]
    [manager POST:@"https://your-api.com/login"
      parameters:params
        progress:nil
         success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"POST 请求成功: %@", responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"POST 请求失败: %@", error);
    }];
}

#pragma mark - 3. 文件上传 (例如上传图片)
//- (void)uploadImage {
//    // 假设从相册或 Bundle 中获取了一张图片
//    UIImage *image = [UIImage imageNamed:@"example_image"];
//    NSData *imageData = UIImageJPEGRepresentation(image, 0.8);
//    
//    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
//    // 设置响应类型为 JSON
//    manager.responseSerializer = [AFJSONResponseSerializer serializer];
//    
//    [manager POST:@"https://your-api.com/upload"
//      parameters:@{@"userId": @"12345"} // 其他参数
//constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
//        // 将图片数据附加到请求体中[reference:11]
//        [formData appendPartWithFileData:imageData
//                                    name:@"file"
//                                fileName:@"photo.jpg"
//                                mimeType:@"image/jpeg"];
//    } progress:^(NSProgress * _Nonnull uploadProgress) {
//        // 上传进度
//        NSLog(@"上传进度: %.2f%%", uploadProgress.fractionCompleted * 100);
//    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//        NSLog(@"上传成功: %@", responseObject);
//    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//        NSLog(@"上传失败: %@", error);
//    }];
//}

- (void)uploadImage {
    // 1. 安全加载图片
    UIImage *image = [UIImage imageNamed:@"example_image"];
    if (!image) {
        NSLog(@"错误：图片 'example_image' 未找到，请确保已添加到项目中");
        return;
    }

    NSData *imageData = UIImageJPEGRepresentation(image, 0.8);
    if (!imageData) {
        NSLog(@"错误：图片数据转换失败，请检查图片格式");
        return;
    }

    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];

    // 2. 建议将 URL 替换为真实地址（测试可用 http://httpbin.org/post）
    NSString *urlString = @"https://your-api.com/upload";

    [manager POST:urlString
      parameters:@{@"userId": @"12345"}
constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        // 现在 imageData 一定非空
        [formData appendPartWithFileData:imageData
                                    name:@"file"
                                fileName:@"photo.jpg"
                                mimeType:@"image/jpeg"];
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        dispatch_async(dispatch_get_main_queue(), ^{
            NSLog(@"上传进度: %.2f%%", uploadProgress.fractionCompleted * 100);
        });
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"上传成功: %@", responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"上传失败: %@", error.localizedDescription);
    }];
}



#pragma mark - 4. 加载网络图片 (使用 UIImageView 扩展)
- (void)loadImageWithAFNetworking {

    
    UIImageView *myImageView = [[UIImageView alloc] initWithFrame:CGRectMake(100, 200, 200, 200)];
    myImageView.backgroundColor = [UIColor systemBlueColor];
    [self.view addSubview:myImageView];

    
    NSURL *imageUrl = [NSURL URLWithString: @"https://i.imgur.com/tGbaZCY.jpg"]; //
    // 直接通过 URL 加载图片
    [myImageView setImageWithURL:imageUrl];

    
    // 更高级的用法：带占位图和渐入动画
    // NSURLRequest *request = [NSURLRequest requestWithURL:imageUrl];
    // [myImageView setImageWithURLRequest:request
    //                    placeholderImage:[UIImage imageNamed:@"placeholder"]
    //                             success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
    //                                 myImageView.image = image;
    //                                 // 添加渐入动画
    //                                 myImageView.alpha = 0.0;
    //                                 [UIView animateWithDuration:0.3 animations:^{
    //                                     myImageView.alpha = 1.0;
    //                                 }];
    //                             } failure:nil];
}
@end
