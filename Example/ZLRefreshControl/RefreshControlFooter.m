//
//  RefreshControlFooter.m
//  ZLRefreshControl_Example
//
//  Created by lylaut on 2021/9/29.
//  Copyright © 2021 richiezhl. All rights reserved.
//

#import "RefreshControlFooter.h"

@interface RefreshControlFooter ()

@property (nonatomic, weak) UILabel *label;

@end

@implementation RefreshControlFooter

- (instancetype)init {
    if (self = [super init]) {
        self.layoutHeight = 40;
        
        UILabel *label = [[UILabel alloc] init];
        label.text = @"";
        [self addSubview:label];
        self.label = label;
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.label.frame = self.bounds;
}

- (void)stateChanged:(ZLRefreshControlState)state {
//    NSLog(@"state => %ld", (long)state);
    switch (state) {
        case ZLRefreshControlStateRefreshing:
            self.label.text = @"刷新中...";
            break;
            
        case ZLRefreshControlStateWillRefreshing:
            self.label.text = @"松手刷新";
            break;
            
        default:
            self.label.text = @"上拉刷新";
            break;
    }
}

- (void)pullProgressChanged:(float)pullProgress {
//    NSLog(@"%.2f", pullProgress);
    self.label.text = [NSString stringWithFormat:@"拉进度:%.2f%%", pullProgress * 100];
}

@end
