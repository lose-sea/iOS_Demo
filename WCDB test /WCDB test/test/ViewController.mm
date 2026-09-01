//
//  ViewController.m
//  WCDB test
//
//  Created by lose_sea on 2026/8/8.
//

#import "ViewController.h"

@interface ViewController () 

@property (nonatomic, strong) WCTDatabase* dataBase;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    // 初始化数据库
    [self setUpDataBase];
    [self createTable];
    
    [self setUpData];
//    [self updateData];
    [self queryData];
    
}


- (void) setUpDataBase {
    NSString* docPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
    
    
    NSString* dbPath = [docPath stringByAppendingPathComponent: @"test.db"];
    
    self.dataBase = [[WCTDatabase alloc] initWithPath: dbPath];
    NSLog(@"数据库路径: %@", dbPath);
}

- (void) createTable {

    BOOL result = [self.dataBase createTable:@"myTable" withClass:[MyWCDB class]];
    
    if (result) {
        NSLog(@"创建表成功");
    } else {
        NSLog(@"创建表失败");
    }
}


- (void) setUpData {
    self.myWCDB = [[MyWCDB alloc] init];
    self.testview = [[View alloc] init];
    
    NSLog(@"初始化数据 - text: '%@', array: %@", self.myWCDB.text, self.myWCDB.array);
}



// 更新数据并保存
- (void) updateData {
    // 修改数据
    self.myWCDB.text = @"xinyan";
    self.myWCDB.array = @[@"xinyan", @"hello"];
    
    // 保存到数据库
    BOOL success = [self.dataBase insertObject: self.myWCDB intoTable: @"myTable"];
        
    if (success) {
        NSLog(@"插入数据成功, text: %@, array: %@", self.myWCDB.text, self.myWCDB.array);
        
    } else {
        NSLog(@"插入数据失败");
    }
}

- (void) queryData {
    NSArray<MyWCDB *> *results = [self.dataBase getObjectsOfClass: [MyWCDB class] fromTable: @"myTable"];
    
    NSLog(@"查询到 %lu 条数据", results.count);
    for (MyWCDB* item in results) {
        NSLog(@" -- myId: %ld, text: %@, array: %@", item.myId, item.text, item.array);
    }
          
}








@end
