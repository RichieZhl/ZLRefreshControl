//
//  RefreshControlFooter.m
//  ZLRefreshControl_Example
//
//  Created by lylaut on 2021/9/29.
//  Copyright © 2021 richiezhl. All rights reserved.
//

#import "RefreshControlFooter.h"

@interface RefreshControlFooter ()

@property (weak, nonatomic) UIActivityIndicatorView *loadingView;
@property (nonatomic, weak) UILabel *stateLabel;

@end

@implementation RefreshControlFooter

+ (instancetype)headerWithRefreshingTarget:(id)target refreshingAction:(SEL)action {
    RefreshControlFooter *header = [RefreshControlFooter new];
    [header addRefreshTarget:target action:action];
    return header;
}

- (instancetype)init {
    if (self = [super init]) {
        self.layoutHeight = 30;
        
        UIActivityIndicatorView *loadingView = nil;
        if (@available(iOS 13.0, *)) {
            loadingView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleMedium];
        } else {
            loadingView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        };
        loadingView.hidesWhenStopped = YES;
        [self addSubview:loadingView];
        _loadingView = loadingView;
        
        UILabel *label = [[UILabel alloc] init];
        label.font = [UIFont systemFontOfSize:14];
        label.textColor = [UIColor colorWithRed:0.4 green:0.4 blue:0.4 alpha:1];
        [self addSubview:label];
        _stateLabel = label;
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    CGRect loadingViewFrame = self.loadingView.frame;
    loadingViewFrame.origin.y = (self.bounds.size.height - loadingViewFrame.size.height) * 0.5;
    
    CGRect stateLabelFrame = self.stateLabel.frame;
    stateLabelFrame.size = [self.stateLabel sizeThatFits:CGSizeMake(1000, 20)];
    stateLabelFrame.origin.y = (self.bounds.size.height - stateLabelFrame.size.height) * 0.5;
    
    CGFloat margin = 15;
    CGFloat leftW = self.state == ZLRefreshControlStateNoMoreData ? 0 : loadingViewFrame.size.width;
    CGFloat totalW = leftW + margin + stateLabelFrame.size.width;
    CGFloat X = (self.bounds.size.width - totalW) * 0.5;
    
    loadingViewFrame.origin.x = X;
    stateLabelFrame.origin.x = X + leftW + margin;
    
    self.loadingView.frame = loadingViewFrame;
    self.stateLabel.frame = stateLabelFrame;
}

- (void)stateChanged:(ZLRefreshControlState)state {
    switch (state) {
        case ZLRefreshControlStateRefreshing:
            self.stateLabel.text = @"正在加载更多...";
            [self setNeedsLayout];
            self.loadingView.hidden = NO;
            [self.loadingView startAnimating];
            break;
            
        case ZLRefreshControlStateNoMoreData:
            self.stateLabel.text = @"没有更多数据了";
            [self setNeedsLayout];
            self.loadingView.hidden = YES;
            [self.loadingView stopAnimating];
            break;
            
        default:
            self.stateLabel.text = @"上拉可以加载更多";
            [self setNeedsLayout];
            self.loadingView.hidden = YES;
            [self.loadingView stopAnimating];
            break;
    }
}

- (void)pullProgressChanged:(float)pullProgress {
//    NSLog(@"上拉进度:%.2f%%", pullProgress * 100);
}

@end
