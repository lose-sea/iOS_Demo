//
//  ArticlePageController.m
//  Share
//
//  Created by lose_sea on 2026/6/8.
//

#import "ArticlePageController.h"

@interface ArticlePageController ()

@end

@implementation ArticlePageController

- (instancetype) init {
    self = [super init];
    if (self) {
        self.articlePageModel = [[ArticlePageModel alloc] init];
        self.articlePageView = [[ArticlePageView alloc] init];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Do any additional setup after loading the view.
    [self setUpData];
    [self setUpNavigation];
}


- (void) setUpNavigation {
//    self.navigationController.navigationBar.translucent =  NO; 
    UIBarButtonItem* back = [[UIBarButtonItem alloc] initWithTitle: @"back" style: UIBarButtonItemStylePlain target: self  action: @selector(pressBack)];
    self.navigationItem.leftBarButtonItem = back;
}

- (void)pressBack {
    if ([self.delegate respondsToSelector:@selector(refreshArticle:)]) {
        [self.delegate refreshArticle: self.article];
    }
    [self.navigationController popViewControllerAnimated: YES];
}



- (void)setUpData {
    self.articlePageModel = [[ArticlePageModel alloc] init];
    self.articlePageView = [[ArticlePageView alloc] init];
    
    [self.view addSubview: self.articlePageView];
    [self.articlePageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.view);
    }];
    
    
    self.articlePageView.tableView.delegate = self;
    self.articlePageView.tableView.dataSource = self;
    
    for (int i = 0; i < 3; i++) {
        NSString* imageName = [NSString stringWithFormat: @"%d.jpg", i + 25];
        UIImage* image = [UIImage imageNamed: imageName];
        [self.articlePageModel.images addObject: image];
    }
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    return 150;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CustomCell* cell = [tableView dequeueReusableCellWithIdentifier: @"ArticleCellID" forIndexPath: indexPath];
    cell.article = self.article;
    cell.backgroundColor = [UIColor systemBrownColor];
    [cell configureWithArticle: self.article];
    
    return cell;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath: indexPath animated: YES]; 
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
