//
//  ViewController.m
//  WCDB_test
//
//  Created by lose_sea on 2026/8/31.
//

#import "ViewController.h"
#import "MyWCDB.h"
#import "MyWCDB+WCTTableCoding.h"
#import <WCDB/WCDB.h>
@interface ViewController ()
@property (nonatomic, strong) WCTDatabase *database;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    printf("hello");
    
 // 初始化数据库
    [self setUpDatabase];
}

- (void)setUpDatabase {
    // 获取 Documents 目录路径
    NSString *docPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
    NSString *dbPath = [docPath stringByAppendingPathComponent:@"myDatabase.db"];
    
    NSLog(@"数据库路径: %@", dbPath);
    
    // 创建数据库实例
    self.database = [[WCTDatabase alloc] initWithPath:dbPath];
    
    // 打开数据库（如果打开失败会抛出异常）
    // WCDB 会第一次执行增删改查时自动打开数据库，不需要手动调用open。
//    可以用 canOpen 检测数据库文件是否可以正常初始化；isOpened 判断是否已经打开。
    if (![self.database canOpen]) {
        NSLog(@"数据库打开失败");
        return;
    }
    
    NSLog(@"数据库打开成功");
}

@end
