//
//  RefreshControlHeader.m
//  ZLRefreshControl_Example
//
//  Created by lylaut on 2021/9/29.
//  Copyright © 2021 richiezhl. All rights reserved.
//

#import "RefreshControlHeader.h"

@interface RefreshControlHeader ()

@property (nonatomic, weak) UILabel *stateLabel;
@property (nonatomic, weak) UIImageView *arrowView;
@property (nonatomic, weak) UIActivityIndicatorView *loadingView;

@end

@implementation RefreshControlHeader

+ (instancetype)headerWithRefreshingTarget:(id)target refreshingAction:(SEL)action {
    RefreshControlHeader *header = [RefreshControlHeader new];
    [header addRefreshTarget:target action:action];
    return header;
}

- (instancetype)init {
    if (self = [super init]) {
        self.layoutHeight = 80;
        
        UIImageView *arrowView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"arrow"]];
        [self addSubview:arrowView];
        _arrowView = arrowView;
        
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
        _arrowView.tintColor = label.textColor;
        [self addSubview:label];
        _stateLabel = label;
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    CGRect arrowViewFrame = self.arrowView.frame;
    arrowViewFrame.origin.y = (self.bounds.size.height - arrowViewFrame.size.height) * 0.5;
    
    CGRect loadingViewFrame = self.loadingView.frame;
    loadingViewFrame.origin.y = (self.bounds.size.height - loadingViewFrame.size.height) * 0.5;
    
    CGRect stateLabelFrame = self.stateLabel.frame;
    stateLabelFrame.size = [self.stateLabel sizeThatFits:CGSizeMake(1000, 20)];
    stateLabelFrame.origin.y = (self.bounds.size.height - stateLabelFrame.size.height) * 0.5;
    
    CGFloat margin = 15;
    CGFloat leftW = MAX(arrowViewFrame.size.width, loadingViewFrame.size.width);
    CGFloat totalW = leftW + margin + stateLabelFrame.size.width;
    CGFloat X = (self.bounds.size.width - totalW) * 0.5;
    
    arrowViewFrame.origin.x = X;
    loadingViewFrame.origin.x = X;
    stateLabelFrame.origin.x = X + leftW + margin;
    
    self.arrowView.frame = arrowViewFrame;
    self.loadingView.frame = loadingViewFrame;
    self.stateLabel.frame = stateLabelFrame;
}

- (void)stateChanged:(ZLRefreshControlState)state {
    switch (state) {
        case ZLRefreshControlStateRefreshing:
            self.stateLabel.text = @"正在刷新中...";
            self.loadingView.hidden = NO; // 防止refreshing -> idle的动画完毕动作没有被执行
            [self.loadingView startAnimating];
            self.arrowView.hidden = YES;
            break;
            
        case ZLRefreshControlStateWillRefreshing:{
            self.stateLabel.text = @"松开立即刷新";
            [UIView animateWithDuration:0.2 animations:^{
                self.arrowView.transform = CGAffineTransformMakeRotation(0.000001 - M_PI);
            }];
        }break;
            
        default:
            [self.loadingView stopAnimating];
            self.stateLabel.text = @"下拉可以刷新";
            [self setNeedsLayout];
            self.arrowView.hidden = NO;
            self.arrowView.transform = CGAffineTransformIdentity;
            break;
    }
}

- (void)pullProgressChanged:(float)pullProgress {
//    NSLog(@"下拉进度:%.2f%%", pullProgress * 100);
}

@end
