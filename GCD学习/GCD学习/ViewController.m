//
//  ViewController.m
//  GCD学习
//
//  Created by lose_sea on 2026/9/3.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    
    //        // 创建一个串行队列
    //        dispatch_queue_t serialQueue = dispatch_queue_create("com.study.serial", DISPATCH_QUEUE_SERIAL);
    //        NSLog(@"开始派发任务");
    //        dispatch_async(serialQueue, ^{
    //            for (NSInteger i = 0; i < 5; i++) {
    //                NSLog(@"任务A - %ld", (long)i);
    //            }
    //        });
    //
    //        dispatch_async(serialQueue, ^{
    //            for (int i = 0; i < 5; i++) {
    //                NSLog(@"任务B - %ld", (long)i);
    //            }
    //        });
    //
    //        NSLog(@"任务派发完毕");
    //        sleep(2);
    
    
    
    //            // 创建一个并行队列
    //            dispatch_queue_t concurrentQueue = dispatch_queue_create("com.study.concurrent", DISPATCH_QUEUE_CONCURRENT);
    //            NSLog(@"开始派发任务");
    //            dispatch_async(concurrentQueue, ^{
    //                for (int i = 0; i < 5; i++) {
    //                    NSLog(@"任务C - %d", i);
    //                }
    //            });
    //
    //            dispatch_async(concurrentQueue, ^{
    //                for (NSInteger i = 0; i < 5; i++) {
    //                    NSLog(@"任务D - %ld", (long)i);
    //                }
    //            });
    //
    //        // 等待所有任务真正完成
    //        sleep(3);
    //        NSLog(@"任务派发完成");
    
    //    dispatch_async(dispatch_get_global_queue(0, 0), ^{
    //        [self loadBigImage];
    //    });
    //
    //    printf("hello world");
    
    //    dispatch_queue_t queue = dispatch_queue_create("com.demo.serial", DISPATCH_QUEUE_SERIAL);
    //    dispatch_async(queue, ^{
    //        NSLog(@"任务 A");
    //    });
    //    dispatch_async(queue, ^{
    //        NSLog(@"任务 B");
    //    });
    //    dispatch_async(queue, ^{
    //        NSLog(@"任务 C");
    //    });
    
    
    //    dispatch_queue_t queue = dispatch_queue_create("com.demo.current", DISPATCH_QUEUE_CONCURRENT);
    //    dispatch_async(queue, ^{
    //        sleep(2);
    //        NSLog(@"任务 A");
    //    });
    //    dispatch_async(queue, ^{
    //        NSLog(@"任务 B");
    //    });
    //    dispatch_async(queue, ^{
    //        NSLog(@"任务 C");
    //    });
    
    
    
    
    //    dispatch_async(queue, ^{
    //        NSLog(@"task");
    //    });
    
    //    dispatch_queue_t queue = dispatch_queue_create("com.demo.current", DISPATCH_QUEUE_CONCURRENT);
    //    NSLog(@"1");
    //    dispatch_async(queue, ^{
    //        NSLog(@"2");
    //    });
    //    NSLog(@"3");
    //
    //    dispatch_queue_t queue = dispatch_queue_create("com.demo.current", DISPATCH_QUEUE_CONCURRENT);
    //
    //    NSLog(@"1");
    //
    //    dispatch_sync(queue, ^{
    //        NSLog(@"2");
    //    });
    //
    //    NSLog(@"3");
    
    
    //    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    
    //    dispatch_queue_t queue = dispatch_queue_create("com.demo.downLoad", DISPATCH_QUEUE_SERIAL);
    
    
    
    //    dispatch_queue_attr_t attr = dispatch_queue_attr_make_with_qos_class(DISPATCH_QUEUE_SERIAL, QOS_CLASS_USER_INITIATED, 0);
    //    dispatch_queue_t queue = dispatch_queue_create("download", attr);
    
    
    //    for (int i = 0; i < 4; i++) {
    //        [self test];
    //        NSLog(@"执行完成");
    //    }
    
    //    NSLog(@"start");
    //
    //    dispatch_after(
    //       dispatch_time(DISPATCH_TIME_NOW, 2 * NSEC_PER_SEC),
    //       dispatch_get_main_queue(), ^{
    //           NSLog(@"2秒后");
    //       }
    //    );
        
//    dispatch_queue_t queue =  dispatch_queue_create("concurrent_queue", DISPATCH_QUEUE_CONCURRENT);
//    dispatch_group_t group = dispatch_group_create();
//    dispatch_group_enter(group);
//    dispatch_async(queue, ^{
//        NSLog(@"A完成");
//        
//        dispatch_group_leave(group);
//        
//    });
//    
//    dispatch_group_enter(group);
//    dispatch_async(queue, ^{
//        NSLog(@"B完成");
//        dispatch_group_leave(group);
//    });
//    
//    dispatch_group_enter(group);
//    dispatch_async(queue, ^{
//        NSLog(@"C完成");
//        dispatch_group_leave(group);
//
//    });
//    
//    dispatch_group_notify(group, dispatch_get_main_queue(), ^{
//        NSLog(@"A, B, C 全部完成");
//    });
    
    
//    dispatch_queue_t queue = dispatch_queue_create("com.demo.database", DISPATCH_QUEUE_CONCURRENT);
//    dispatch_async(queue, ^{
//        NSLog(@"read A");
//    });
//    
//    dispatch_async(queue, ^{
//        NSLog(@"read B");
//    });
//    
//    
//    dispatch_barrier_async(queue, ^{
//        NSLog(@"写入");
//    });
//    
//    dispatch_async(queue, ^{
//        NSLog(@"read C");
//    });
//    
//    dispatch_async(queue, ^{
//        NSLog(@"read D");
//    });
    
    dispatch_queue_attr_t attr = dispatch_queue_attr_make_with_qos_class(DISPATCH_QUEUE_SERIAL, QOS_CLASS_USER_INITIATED, 0);
    
    dispatch_queue_t queue = dispatch_queue_create("concurrent_queue", attr);
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(3);
    
    for (int i = 0; i < 100; i++) {
        dispatch_async(queue, ^{

            dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
            NSLog(@"task %d start", i);
            
            NSLog(@"task %d end", i);
            
            dispatch_semaphore_signal(semaphore);

        });
    }
    
}




- (void) test {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSLog(@"只执行一次");
    });
}


- (void) loadBigImage {
    NSLog(@"加载图片 ...");
    sleep(3);
    NSLog(@"加载成功");
}











@end
