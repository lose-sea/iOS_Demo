//
//  Signin.m
//  Share
//
//  Created by lose_sea on 2026/5/13.
//

#import "Signin.h"

@interface Signin ()
@property (nonatomic, strong) NSTimer* timer;

@property (nonatomic, strong) UIImageView* startView;
@end

@implementation Signin

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor systemCyanColor];
    // Do any additional setup after loading the view.    self.view.backgroundColor = [UIColor systemCyanColor];
    // Do any additional setup after loading the view.
//    [self setInterface];
//    [self setTimer];
    
}

//- (void) setInterface {
//    UIImage* image = [UIImage imageNamed: @"1.jpg"];
//    self.startView = [[UIImageView alloc] initWithImage: image];
//    [self.view addSubview: self.startView];
//    [self.startView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.edges.mas_equalTo(self.view);
//    }];
//}
//
//- (void) setTimer {
//    self.timer = [NSTimer scheduledTimerWithTimeInterval: 1 target: self selector: @selector(hideStartView) userInfo: nil repeats: NO];
//}
//- (void) hideStartView {
//    self.startView.hidden = YES;
//}
- (void) setInterface {
    
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
