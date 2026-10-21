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
    
    
    
//        dispatch_queue_attr_t attr = dispatch_queue_attr_make_with_qos_class(DISPATCH_QUEUE_SERIAL, QOS_CLASS_USER_INITIATED, 0);
//        dispatch_queue_t queue = dispatch_queue_create("download", attr);
    
    
    // dispatch_once
//        for (int i = 0; i < 4; i++) {
//            [self test];
//            NSLog(@"执行完成");
//        }
//    

    
    
    
//     // dispatch_after
    
    
//        dispatch_after(
//           dispatch_time(DISPATCH_TIME_NOW, 2 * NSEC_PER_SEC),
//           dispatch_get_main_queue(), ^{
//               NSLog(@"2秒后");
//           }
//        );
        
    
    
    
    // dispatch_group
    
    
//    dispatch_queue_t queue =  dispatch_queue_create("concurrent_queue", DISPATCH_QUEUE_CONCURRENT);
//    dispatch_group_t group = dispatch_group_create();
//    dispatch_group_enter(group);
//    dispatch_async(queue, ^{
//        for (int i = 0; i < 10; i++) {
//            NSLog(@"A - %d", i);
//        }
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
    
//    dispatch_group_notify(group, dispatch_get_main_queue(), ^{
//        NSLog(@"A, B, C 全部完成");
//    });
    
    
    
    
    
    
    
    
    
    
//    // dispatch_barrier
//    
//    
//    dispatch_queue_t queue = dispatch_queue_create("com.demo.database", DISPATCH_QUEUE_CONCURRENT);
//    dispatch_async(queue, ^{
//        NSLog(@"read A");
//    });
//    
//    dispatch_async(queue, ^{
//        NSLog(@"read B");
//        for (int i = 0; i < 5; i++) {
//            NSLog(@"read B - %d", i);
//        }
//    });
//    
////    
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

    
    
    

    // dispatch_semaphore
    
    
    dispatch_queue_attr_t attr = dispatch_queue_attr_make_with_qos_class(DISPATCH_QUEUE_CONCURRENT, QOS_CLASS_DEFAULT, 0);
    
    dispatch_queue_t queue = dispatch_queue_create("concurrent_queue", attr);
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(3);
    
    for (int i = 0; i < 100; i++) {
        dispatch_async(queue, ^{

            dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
            if (i == 50) {
                for (int j = 0; j < 5; j++) {
                    NSLog(@"task %d - %d", i, j);
                }
            }
            NSLog(@"task %d start", i);
            
            NSLog(@"task %d end", i);
            
            dispatch_semaphore_signal(semaphore);

        });
    }
    
    
//    NSLog(@"调用前：%@", [NSThread currentThread]);
//
//    [NSThread detachNewThreadSelector:@selector(syncMain)
//                               toTarget:self
//                             withObject:nil];
//
//    NSLog(@"调用后：%@", [NSThread currentThread]);
    
//    [self barrier];
    
//    [self after];
    
//    [self apply];
    
    
//    for (int i = 0; i < 6; i++) {
//        [self once];
//        NSLog(@"hello xinyan");
//    }
    
//    [self groupNotify];
    
//    [self groupWait];
}

/**
 * 队列组 dispatch_group_wait
 */
- (void)groupWait {
    NSLog(@"currentThread---%@",[NSThread currentThread]);  // 打印当前线程
    NSLog(@"group---begin");
    
    dispatch_group_t group =  dispatch_group_create();
    
    dispatch_group_async(group, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        // 追加任务 1
        [NSThread sleepForTimeInterval:2];              // 模拟耗时操作
        NSLog(@"1---%@",[NSThread currentThread]);      // 打印当前线程
    });
    
    dispatch_group_async(group, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        // 追加任务 2
        [NSThread sleepForTimeInterval:2];              // 模拟耗时操作
        NSLog(@"2---%@",[NSThread currentThread]);      // 打印当前线程
    });
    
    // 等待上面的任务全部完成后，会往下继续执行（会阻塞当前线程）
    dispatch_group_wait(group, DISPATCH_TIME_FOREVER); // DISPATCH_TIME_FOREVER 无限期等待,直到group中任务执行完成
    
    NSLog(@"group---end");
    
}



/**
 * 队列组 dispatch_group_notify
 */
- (void)groupNotify {
    NSLog(@"currentThread---%@",[NSThread currentThread]);  // 打印当前线程
    NSLog(@"group---begin");
    
    dispatch_group_t group =  dispatch_group_create();
    
    dispatch_group_async(group, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        // 追加任务 1
        [NSThread sleepForTimeInterval:2];              // 模拟耗时操作
        NSLog(@"1---%@",[NSThread currentThread]);      // 打印当前线程
    });
    
    dispatch_group_async(group, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        // 追加任务 2
        [NSThread sleepForTimeInterval:2];              // 模拟耗时操作
        NSLog(@"2---%@",[NSThread currentThread]);      // 打印当前线程
    });
    
    dispatch_group_notify(group, dispatch_get_main_queue(), ^{
        // 等前面的异步任务 1、任务 2 都执行完毕后，回到主线程执行下边任务
        [NSThread sleepForTimeInterval:2];              // 模拟耗时操作
        NSLog(@"3---%@",[NSThread currentThread]);      // 打印当前线程

        NSLog(@"group---end");
    });
    
    
}



/**
 * 一次性代码（只执行一次）dispatch_once
 */
- (void)once {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        // 只执行 1 次的代码（这里面默认是线程安全的）
        NSLog(@"hello world");
    });
}




/**
 * 快速迭代方法 dispatch_apply
 */
- (void)apply {
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    
    NSLog(@"apply---begin");
    dispatch_apply(6, queue, ^(size_t index) {
        NSLog(@"%zd---%@",index, [NSThread currentThread]);
    });
    NSLog(@"apply---end");
}


/**
 * 延时执行方法 dispatch_after
 */
- (void)after {
    NSLog(@"currentThread---%@",[NSThread currentThread]);  // 打印当前线程
    NSLog(@"asyncMain---begin");
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        // 2.0 秒后异步追加任务代码到主队列，并开始执行
        NSLog(@"after---%@",[NSThread currentThread]);  // 打印当前线程
    });
}



/**
 * 栅栏方法 dispatch_barrier_async
 */
- (void)barrier {
    dispatch_queue_t queue = dispatch_queue_create("net.bujige.testQueue", DISPATCH_QUEUE_CONCURRENT);
    
    dispatch_async(queue, ^{
        // 追加任务 1
        [NSThread sleepForTimeInterval:2];              // 模拟耗时操作
        NSLog(@"1---%@",[NSThread currentThread]);      // 打印当前线程
    });
    dispatch_async(queue, ^{
        // 追加任务 2
        [NSThread sleepForTimeInterval:2];              // 模拟耗时操作
        NSLog(@"2---%@",[NSThread currentThread]);      // 打印当前线程
    });
    
    dispatch_barrier_async(queue, ^{
        // 追加任务 barrier
        [NSThread sleepForTimeInterval:2];              // 模拟耗时操作
        NSLog(@"barrier---%@",[NSThread currentThread]);// 打印当前线程
    });
    
    dispatch_async(queue, ^{
        // 追加任务 3
        [NSThread sleepForTimeInterval:2];              // 模拟耗时操作
        NSLog(@"3---%@",[NSThread currentThread]);      // 打印当前线程
    });
    dispatch_async(queue, ^{
        // 追加任务 4
        [NSThread sleepForTimeInterval:2];              // 模拟耗时操作
        NSLog(@"4---%@",[NSThread currentThread]);      // 打印当前线程
    });
}




/**
 * 同步执行 + 主队列
 * 特点(主线程调用)：互等卡主不执行。
 * 特点(其他线程调用)：不会开启新线程，执行完一个任务，再执行下一个任务。
 */
- (void)syncMain {
    
    NSLog(@"currentThread---%@",[NSThread currentThread]);  // 打印当前线程
    NSLog(@"syncMain---begin");
    
    dispatch_queue_t queue = dispatch_get_main_queue();
    
    dispatch_sync(queue, ^{
        // 追加任务 1
        [NSThread sleepForTimeInterval:2];              // 模拟耗时操作
        NSLog(@"1---%@",[NSThread currentThread]);      // 打印当前线程
    });
    
    dispatch_sync(queue, ^{
        // 追加任务 2
        [NSThread sleepForTimeInterval:2];              // 模拟耗时操作
        NSLog(@"2---%@",[NSThread currentThread]);      // 打印当前线程
    });
    
    dispatch_sync(queue, ^{
        // 追加任务 3
        [NSThread sleepForTimeInterval:2];              // 模拟耗时操作
        NSLog(@"3---%@",[NSThread currentThread]);      // 打印当前线程
    });
    
    NSLog(@"syncMain---end");
    NSLog(@"end-Thread: %@", [NSThread currentThread]);
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
