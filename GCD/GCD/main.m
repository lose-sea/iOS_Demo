//
//  main.m
//  GCD
//
//  Created by lose_sea on 2026/9/2.
//

#import <Foundation/Foundation.h>

int main(int argc, const char * argv[]) {
    @autoreleasepool {
        
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
        
        
        
        // 创建一个并行队列
        dispatch_queue_t concurrentQueue = dispatch_queue_create("com.study.concurrent", DISPATCH_QUEUE_CONCURRENT);
        NSLog(@"开始派发任务");
        dispatch_async(concurrentQueue, ^{
            for (int i = 0; i < 5; i++) {
                NSLog(@"任务C - %d", i);
            }
        });
        
        dispatch_async(concurrentQueue, ^{
            for (NSInteger i = 0; i < 5; i++) {
                NSLog(@"任务D - %ld", (long)i);
            }
        });
    }
    

    
    // 等待所有任务真正完成
    sleep(3);
    NSLog(@"任务派发完成");
    return EXIT_SUCCESS;
}
