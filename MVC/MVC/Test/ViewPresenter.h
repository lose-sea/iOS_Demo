//
//  ViewPresenter.h
//  MVC
//
//  Created by lose_sea on 2026/8/4.
//

#import <Foundation/Foundation.h>
#import "ViewModel.h"
NS_ASSUME_NONNULL_BEGIN


@protocol ViewProtocol <NSObject>
- (void) displayText: (NSString*) text;
@end



@interface ViewPresenter : NSObject

// 持有 View 的协议指针
@property (nonatomic, weak) id<ViewProtocol> view;

@property (nonatomic, strong) ViewModel* model;

//初始化方法, 将 view 注入进来
- (instancetype) initWithView: (id<ViewProtocol>) view;

// 对外暴露的业务能力: 获取更新数据
- (void) loadData;
- (void) updateDataWithNewText: (NSString*) newText; 


@end

NS_ASSUME_NONNULL_END
