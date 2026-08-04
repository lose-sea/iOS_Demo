//
//  ViewPresenter.m
//  MVC
//
//  Created by lose_sea on 2026/8/4.
//

#import "ViewPresenter.h"


@implementation ViewPresenter



- (instancetype) initWithView:(id<ViewProtocol>)view {
    self = [super init];
    if (self) {
        self.view = view;
        self.model = [[ViewModel alloc] init];
    }
    return self;
}

// 模拟数据
- (void) loadData {
    // 模拟这里从网络或数据库获取数据
    // 这里简单设置一个初始数据
    self.model.text = @"hello from Internet";
    
    if ([self.view respondsToSelector:@selector(displayText:)]) {
        [self.view displayText:self.model.text];
    }
}


// 模拟更新数据
- (void) updateDataWithNewText:(NSString *)newText {
    self.model.text = [NSString stringWithFormat: @"Updated: %@", newText];
    
    // 通知 View 更新数据
    if ([self.view respondsToSelector: @selector(displayText:)]) {
        [self.view displayText: self.model.text];
    }
}




@end
