//
//  ViewPresenter.m
//  MVC
//
//  Created by lose_sea on 2026/8/4.
//

#import "ViewPresenter.h"

@interface ViewPresenter ()
@property (nonatomic, strong) ViewModel* model; 
@end


@implementation ViewPresenter

- (instancetype) initWithView:(id <ViewProtocol>)view {
    self = [super init];
    if (self) {
        self.view = view;
        self.model = [[ViewModel alloc] init];
    }
    return self;
}


- (void) loadData {
    [self.view showLoading];
    
    self.model.text = @"开始加载数据";
    
    [self.view displayText: self.model.text];
    [self.view hideLoading];
}


- (void) refreshData {
    [self.view showLoading];
    
    self.model.text = @"更新的数据";
    [self.view displayText: self.model.text];
//    [self.view hideLoading];
}

@end
