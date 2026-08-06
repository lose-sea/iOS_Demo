//
//  ViewPresenter.h
//  MVC
//
//  Created by lose_sea on 2026/8/4.
//

#import <Foundation/Foundation.h>
#import "ViewModel.h"
#import "ViewPresenter.h"
#import "View.h"
NS_ASSUME_NONNULL_BEGIN



@interface ViewPresenter : NSObject

// 持有 View 的协议指针
@property (nonatomic, weak) id<ViewProtocol> view;

//初始化方法, 将 view 注入进来
- (instancetype) initWithView: (id<ViewProtocol>) view;


// 对外暴露的业务能力: 获取更新数据
- (void) loadData;
- (void) refreshData; 


@end

NS_ASSUME_NONNULL_END
