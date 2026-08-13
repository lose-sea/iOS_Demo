//
//  MyWCDB.mm
//  WCDB 练习
//
//  Created by lose_sea on 2026/8/8.
//

#import "MyWCDB+WCTTableCoding.h"
#import "MyWCDB.h"

@implementation MyWCDB

WCDB_IMPLEMENTATION(MyWCDB)
WCDB_SYNTHESIZE(text)
WCDB_SYNTHESIZE(array)
WCDB_SYNTHESIZE(myId)


//// 自定义列名
//WCDB_SYNTHESIZE_COLUMN(<#property5#>, "<#column name#>")   // Custom column name

// 主键, 每次插入新纪录是自动加一
WCDB_PRIMARY_AUTO_INCREMENT(myId)

// 数据库索引
// 为指定创建索引, 用于加速查询速度
//WCDB_INDEX(<#_index_subfix#>, <#property#>)


- (instancetype) init {
    self = [super init];
    if (self) {
        self.text = @"";
        self.array = @[];
    }
    return self; 
}

@end
