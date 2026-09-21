//
//  HomeViewController.m
//  Spotify
//
//  Created by lose_sea on 2026/9/2.
//

#import "HomeViewController.h"
#import "HomeView.h"
#import "HomeModel.h"
#import "PlayerViewController.h"
#import "DrawerViewController.h"
#import <Masonry/Masonry.h>
#import "Singer.h"



@interface HomeViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) HomeView *homeView;
@property (nonatomic, strong) NSArray<NSDictionary *> *playlistCards;
@property (nonatomic, strong) NSArray<Song *> *songs;

@end

@implementation HomeViewController

#pragma mark - 生命周期

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor systemBackgroundColor];

    // 加载数据
    [self loadData];
    [self setUpNavigation];

    
    [self setUpPlayerViewController];
    
//    [self setUpInterface];
    

    // 黑夜模式
//    self.view.window.overrideUserInterfaceStyle = UIUserInterfaceStyleDark;
}






#pragma mark - 数据准备

- (void)loadData {
    self.playlistCards = [HomeModel samplePlaylistCards];
    self.songs = [HomeModel sampleSongs];
}


#pragma mark - Navigation


- (void)setUpNavigation {
    // 1. 准备图片（建议先裁成正方形并缩放到合适尺寸）
    UIImage *original = [UIImage imageNamed:@"51.jpg"];
    UIImage *avatar = [self croppedToSquare:original size:CGSizeMake(36, 36)]; // 推荐 32~40
    
    // 关键原图颜色，防止被系统 tint 成单色
    avatar = [avatar imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    // 2. 创建按钮
    UIButton *imageButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [imageButton setImage:avatar forState:UIControlStateNormal];
        
    // 必须设置 frame（CustomView 依赖这个）
    imageButton.frame = CGRectMake(0, 0, 36, 36);
    
    // 圆形头像
    imageButton.clipsToBounds = YES;
    imageButton.layer.cornerRadius = 18;   // 半径 = 宽高的一半
    
    [imageButton addTarget:self
                    action:@selector(pressMenuButton)
          forControlEvents:UIControlEventTouchUpInside];
    
    // 3. 包装成 BarButtonItem
    UIBarButtonItem *avatarBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:imageButton];
    
//    UIBarButtonItem* avatarBarButtonItem = [[UIBarButtonItem alloc] initWithImage: avatar style: UIBarButtonItemStylePlain target: self action: @selector(pressMenuButton)];
//
    // 4. 使用 leadingItemGroups（iOS 16+ 推荐写法）
    UIBarButtonItemGroup *menuGroup = [[UIBarButtonItemGroup alloc]
        initWithBarButtonItems:@[avatarBarButtonItem]
            representativeItem:nil];
    
    // All / Music / Podcast
    UIBarButtonItem *allItem = [[UIBarButtonItem alloc] initWithTitle:@"All"
                                                                style:UIBarButtonItemStylePlain
                                                               target:self
                                                               action:@selector(pressAllPage)];
    
    UIBarButtonItem *musicItem = [[UIBarButtonItem alloc] initWithTitle:@"Music"
                                                                  style:UIBarButtonItemStylePlain
                                                                 target:self
                                                                 action:@selector(pressMusicPage)];
    
    UIBarButtonItem *blogItem = [[UIBarButtonItem alloc] initWithTitle:@"Podcast"
                                                                 style:UIBarButtonItemStylePlain
                                                                target:self
                                                                action:@selector(pressBlogPage)];
    
    UIBarButtonItemGroup *itemsGroup = [[UIBarButtonItemGroup alloc]
        initWithBarButtonItems:@[allItem, musicItem, blogItem]
            representativeItem:nil];
    
    self.navigationItem.leadingItemGroups = @[menuGroup, itemsGroup];
}


- (void) setUpPlayerViewController {
    PlayerViewController* player = [[PlayerViewController alloc] init];
    
    [self addChildViewController: player];
    [self.view addSubview: player.view];
    [player didMoveToParentViewController: self];
    [player.view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.view).offset(10);
        make.right.mas_equalTo(self.view).offset(-10);
        make.height.mas_equalTo(60);
        make.bottom.mas_equalTo(self.view.mas_bottom).offset(-80);
    }];
    player.view.clipsToBounds = YES;
    player.view.layer.cornerRadius = 30; 
}



- (void)pressAllPage {
    NSLog(@"点击全部");
}
- (void)pressMusicPage {
    NSLog(@"点击音乐");
}
- (void)pressBlogPage {
    NSLog(@"点击播客");
}

- (void)pressMenuButton {
    NSLog(@"点击了菜单按钮");
    UIViewController *root = self.view.window.rootViewController;
    if ([root isKindOfClass:[DrawerViewController class]]) {
        [(DrawerViewController *)root openMenu];
    }
}




#pragma mark -public Method

// 缩小图片
- (UIImage *)croppedToSquare:(UIImage *)image size:(CGSize)size {
    CGSize imgSize = image.size;
    CGFloat side = MIN(imgSize.width, imgSize.height);
    CGRect cropRect = CGRectMake((imgSize.width - side) / 2,
                                 (imgSize.height - side) / 2,
                                 side, side);

    CGImageRef cgImage = CGImageCreateWithImageInRect(image.CGImage, cropRect);
    UIImage *cropped = [UIImage imageWithCGImage:cgImage
                                           scale:image.scale
                                     orientation:image.imageOrientation];
    CGImageRelease(cgImage);

    // 缩放到目标尺寸
    UIGraphicsBeginImageContextWithOptions(size, NO, 0);
    [cropped drawInRect:CGRectMake(0, 0, size.width, size.height)];
    UIImage *result = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return result;
}

@end
