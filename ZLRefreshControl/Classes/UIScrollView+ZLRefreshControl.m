//
//  UIScrollView+ZLRefreshControl.m
//  ZLRefreshControl_Example
//
//  Created by lylaut on 2021/9/28.
//  Copyright © 2021 richiezhl. All rights reserved.
//

#import "UIScrollView+ZLRefreshControl.h"
#import <objc/runtime.h>

@interface ZLRefreshControlBaseComponent ()

@property (nonatomic, assign, readwrite) ZLRefreshControlState state;

@property (nonatomic, assign, readwrite) float pullProgress;

@property (nonatomic, weak) id refreshTarget;

@property (nonatomic, assign) SEL refreshAction;

- (void)scrollViewDidChanged;

@end

@implementation ZLRefreshControlBaseComponent

- (instancetype)init {
    if (self = [super init]) {
        _state = ZLRefreshControlStateIdle;
        _pullProgress = 0;
    }
    return self;
}

- (void)setScrollView:(UIScrollView *)scrollView {
    _scrollView = scrollView;
    
    [_scrollView addObserver:self
                  forKeyPath:@"contentOffset"
                     options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld
                     context:nil];
}

- (void)setState:(ZLRefreshControlState)state {
    _state = state;
    
    [self stateChanged:_state];
    
    if (_state == ZLRefreshControlStateRefreshing) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
        [self.refreshTarget performSelector:self.refreshAction];
#pragma clang diagnostic pop
    }
}

- (void)setPullProgress:(float)pullProgress {
    _pullProgress = pullProgress;
    
    [self pullProgressChanged:_pullProgress];
}

- (void)scrollViewDidChanged {
    
}

- (void)stateChanged:(ZLRefreshControlState)state {
    
}

- (void)pullProgressChanged:(float)pullProgress {
    
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    if (object == self.scrollView) {
        if ([keyPath isEqualToString:@"contentOffset"]) {
            if (!self.scrollView.scrollEnabled) {
                return;
            }
            [self scrollViewDidChanged];
        }
    } else {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}

- (void)dealloc {
    [_scrollView removeObserver:self forKeyPath:@"contentOffset"];
}

#pragma mark - public methods
- (void)addRefreshTarget:(id)target action:(SEL)action {
    self.refreshTarget = target;
    self.refreshAction = action;
}

- (void)beginRefreshing {
    
}

- (void)endRefreshing {
    
}

@end


@implementation ZLRefreshControlBaseHeader

- (void)beginRefreshing {
    CGFloat offsetY = self.layoutHeight - self.scrollView.contentInset.top;
    
    [self.scrollView setContentOffset:CGPointMake(self.scrollView.contentOffset.x, -offsetY) animated:YES];
    
    self.pullProgress = 1;
    self.state = ZLRefreshControlStateRefreshing;
}


- (void)endRefreshing {
    [self.scrollView setContentOffset:CGPointMake(0, -self.scrollView.contentInset.top) animated:YES];
}

- (void)scrollViewDidChanged {
    CGFloat contentOffsetY = self.scrollView.contentOffset.y + self.scrollView.contentInset.top;
    if (contentOffsetY < 0) {
        [self.scrollView sendSubviewToBack:self];
        self.hidden = NO;
        
        CGFloat offsetY = self.layoutHeight + contentOffsetY - self.scrollView.contentInset.top;
        if (offsetY > 0) {
            offsetY = 0;
        }
        self.frame = CGRectMake(0, offsetY - self.layoutHeight, self.scrollView.frame.size.width, self.layoutHeight);
        
        if (-contentOffsetY > self.layoutHeight) {
            if (self.state == ZLRefreshControlStateRefreshing) {
                return;
            }
            if (self.scrollView.isDragging) {
                if (self.state == ZLRefreshControlStateWillRefreshing) {
                    return;
                }
                self.state = ZLRefreshControlStateWillRefreshing;
                return;
            }
            
            [self beginRefreshing];
        } else if (self.state == ZLRefreshControlStateIdle ||
                   self.state == ZLRefreshControlStateWillRefreshing) {
            self.state = ZLRefreshControlStatePulling;
        } else if (self.state == ZLRefreshControlStatePulling) {
            self.pullProgress = -contentOffsetY / self.layoutHeight;
        }
    } else if (contentOffsetY >= 0) {
        self.hidden = YES;
        self.state = ZLRefreshControlStateIdle;
        self.pullProgress = 0;
    }
}

@end

@implementation ZLRefreshControlBaseFooter

- (void)beginRefreshing {
    
}

- (void)endRefreshing {
    CGFloat offsetHeight = self.scrollView.contentSize.height - self.scrollView.frame.size.height + self.scrollView.contentInset.bottom;
    [self.scrollView setContentOffset:CGPointMake(self.scrollView.contentOffset.x, offsetHeight) animated:YES];
}

- (void)scrollViewDidChanged {
    CGFloat offsetHeight = self.scrollView.contentSize.height - self.scrollView.frame.size.height + self.scrollView.contentInset.bottom;
    if (offsetHeight <= 0) {
        return;
    }
    CGFloat contentOffsetY = self.scrollView.contentOffset.y;
    if (contentOffsetY > offsetHeight) {
        [self.scrollView sendSubviewToBack:self];
        self.hidden = NO;
        
        CGFloat offsetY = contentOffsetY - (offsetHeight + self.layoutHeight);
        if (offsetY < 0) {
            offsetY = 0;
        }
        self.frame = CGRectMake(0, offsetY + self.scrollView.contentInset.bottom + self.scrollView.contentSize.height, self.scrollView.frame.size.width, self.layoutHeight);
        
        if (offsetY > 0) {
            if (self.state == ZLRefreshControlStateRefreshing) {
                return;
            }
            if (self.scrollView.isDragging) {
                if (self.state == ZLRefreshControlStateWillRefreshing) {
                    return;
                }
                self.state = ZLRefreshControlStateWillRefreshing;
                return;
            }
            
            [self.scrollView setContentOffset:CGPointMake(self.scrollView.contentOffset.x, offsetHeight + self.layoutHeight - self.scrollView.contentInset.bottom) animated:YES];
            
            self.pullProgress = 1;
            self.state = ZLRefreshControlStateRefreshing;
        } else if (self.state == ZLRefreshControlStateIdle ||
                   self.state == ZLRefreshControlStateWillRefreshing) {
            self.state = ZLRefreshControlStatePulling;
        } else if (self.state == ZLRefreshControlStatePulling) {
            self.pullProgress = (contentOffsetY - offsetHeight) / self.layoutHeight;
        }
    } else {
        self.hidden = YES;
        self.state = ZLRefreshControlStateIdle;
        self.pullProgress = 0;
    }
}

@end


static void *ZLRefreshControlBaseHeaderKey = &ZLRefreshControlBaseHeaderKey;
static void *ZLRefreshControlBaseFooterKey = &ZLRefreshControlBaseFooterKey;

@implementation UIScrollView (ZLRefreshControl)

- (void)setRcHeader:(ZLRefreshControlBaseHeader *)rcHeader {
    rcHeader.scrollView = self;
    [self addSubview:rcHeader];
    
    objc_setAssociatedObject(self, ZLRefreshControlBaseHeaderKey, rcHeader, OBJC_ASSOCIATION_ASSIGN);
}

- (ZLRefreshControlBaseHeader *)rcHeader {
    return objc_getAssociatedObject(self, ZLRefreshControlBaseHeaderKey);
}

- (void)setRcFooter:(ZLRefreshControlBaseFooter *)rcFooter {
    rcFooter.scrollView = self;
    [self addSubview:rcFooter];
    
    objc_setAssociatedObject(self, ZLRefreshControlBaseFooterKey, rcFooter, OBJC_ASSOCIATION_ASSIGN);
}

- (ZLRefreshControlBaseFooter *)rcFooter {
    return objc_getAssociatedObject(self, ZLRefreshControlBaseFooterKey);
}

@end
