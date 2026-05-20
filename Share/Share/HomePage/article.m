//
//  article.m
//  Share
//
//  Created by lose_sea on 2026/5/19.
//

#import "article.h"

@implementation article

- (instancetype) initWitImage: (UIImage*) image Name: (NSString*) name autoor: (NSString*) author massage: (NSString*) massage {
    self = [super init];
    if (self) {
        self.image = image; 
        self.name = name;
        self.author = author;
        self.massage = massage;
        self.isLike = NO;
        self.likeCount = 66;
        self.viewCount = 70;
        self.saveCount = 400;
    }
    return self;
}


@end
