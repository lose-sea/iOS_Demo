//
//  ViewController.m
//  WCDB_test
//
//  Created by lose_sea on 2026/9/1.
//

#import "ViewController.h"
#import "MyWCDB+WCTTableCoding.h" // 导入 Category 才能让 WCDB 识别 MyWCDB

@interface ViewController ()
// 声明数据库
@property (nonatomic, strong) WCTDatabase* database;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setUpDatabase];
    
    [self.database dropTable:@"MyWCDB"];
    [self createTable];
//    [self createTable];
    
    [self insertData];
//    [self queryData];
//    [self deleteData];
//    [self updateData];
}


- (void) setUpDatabase {
    // 获取数据库文件路径
    NSString* docPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,  NSUserDomainMask,  YES) firstObject];
    NSString* dbPath = [docPath stringByAppendingPathComponent: @"myTest.db"];
    NSLog(@"数据库路径: %@", dbPath);
    
    // 创建数据库实例
    self.database = [[WCTDatabase alloc] initWithPath: dbPath];
    // 打开数据库（如果打开失败会抛出异常）
    // WCDB 会第一次执行增删改查时自动打开数据库，不需要手动调用open。
//    可以用 canOpen 检测数据库文件是否可以正常初始化；isOpened 判断是否已经打开。
    if (![self.database canOpen]) {
        NSLog(@"数据库打开失败");
        return;
    }
    
    NSLog(@"数据库打开成功");
}


- (void)createTable {
    // 创建表，表名使用类名 "MyWCDB"
    BOOL result = [self.database createTable:@"MyWCDB" withClass:MyWCDB.class];
    if (result) {
        NSLog(@"表创建成功");
    } else {
        NSLog(@"表创建失败");
    }
}


// insert Data
- (void) insertData {
    
//    [self deleteData];
//    [self queryData];
    
    NSLog(@"插入数据");
    // 创建一个用户
    MyWCDB* user1 = [[MyWCDB alloc] init];
    
    // 设置主键自增
//    user1.isAutoIncrement = YES;          // 必须设置
    
    user1.name = @"张三";
    user1.array = @[@"iOS", @"Python"];
    
    BOOL success1 = [self.database insertObject: user1 intoTable: @"MyWCDB"];
    if (success1) {
        NSLog(@"数据插入成功, user1: %lu, %@, %@", user1.userID, user1.name, user1.array);
    }
    
    MyWCDB* user2 = [[MyWCDB alloc] init];
//    user2.isAutoIncrement = YES;           // 必须设置

//    user2.userID = 1;
    user2.name = @"张三";
    user2.array = @[@"iOS", @"Python"];
    
    BOOL success2 = [self.database insertObject: user2 intoTable: @"MyWCDB"];
    if (success2) {
        NSLog(@"数据插入成功, user2: %lu, %@, %@", user2.userID, user2.name, user2.array);
    }
    
    
//    MyWCDB* user2 = [[MyWCDB alloc] init];
////    user2.userID = 2;
//    user2.name = @"李四";
//    user2.array = @[@"hello", @"xinyan"];
//    
//    BOOL success2 = [self.database insertOrReplaceObject: user2 intoTable: @"MyWCDB"];
//    if (success2) {
//        NSLog(@"数据插入成功, user2: %lu, %@, %@", user2.userID, user2.name, user2.array);
//    }

    
    
    [self queryData];
}




// search Data
- (void) queryData {
    // 查询所有数据
    NSArray<MyWCDB*>* results = [self.database getObjectsOfClass: MyWCDB.class fromTable: @"MyWCDB"];
    
    NSLog(@"查询到%ld条数据", results.count);
    for (MyWCDB* item in results) {
        NSLog(@"userID: %lu, name: %@, array: %@", item.userID, item.name, item.array);
    }
}



- (void) deleteData {
    // 删除所有的数据
    BOOL success = [self.database deleteFromTable: @"MyWCDB"];
    if (success) {
        NSLog(@"delete success");
    } else {
        NSLog(@"delete failure");
    }
    
    [self queryData];
}


// 更新数据
- (void) updateData {
    // 将 userID 为 1 的用户改为 "王五"
    BOOL success = [self.database updateTable: @"MyWCDB" setProperty: MyWCDB.name toValue:  @"王五"];
    if (success) {
        printf("success");
    } else {
        NSLog(@"fail");
    }
    
    [self queryData];
}
@end
