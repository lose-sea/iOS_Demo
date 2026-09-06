//
//  ViewController.m
//  RunLoop
//
//  Created by lose_sea on 2026/9/3.
//

#import "ViewController.h"

@interface ViewController ()

@property (nonatomic, assign) NSInteger timeCount;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
//    NSRunLoop* runLoop = [NSRunLoop mainRunLoop]; 
    
//    NSTimer* timer = [NSTimer scheduledTimerWithTimeInterval: 1 target: self selector: @selector(sayHello) userInfo: nil repeats: YES];
    
//    NSTimer* timer = [NSTimer scheduledTimerWithTimeInterval: 1
//                                                      target: self
//                                                    selector: @selector(sayHello)
//                                                    userInfo: nil
//                                                     repeats: YES];
    
//    for (NSInteger i = 0; i < 4; i++) {
//        NSLog(@"xinyan");
//        sleep(2);
//    }
//    NSInteger num = 0;
//    scanf("%ld", &num);
//    printf("num = %ld", num);
    
    NSLog(@"viewDidLoad 开始执行");
    
    self.timeCount = 0;
    NSTimer* timer = [NSTimer scheduledTimerWithTimeInterval: 1
                                                      target: self
                                                    selector: @selector(sayHello)
                                                    userInfo: nil
                                                     repeats: YES];
    
//    NSRunLoop* runLoop = [NSRunLoop currentRunLoop];
//    NSLog(@"%@", runLoop);
    
    
    
}

- (void) sayHello {
    printf("hello world");
}


@end
