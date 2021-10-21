//
//  UIScrollView+ZLRefreshControl.h
//  ZLRefreshControl_Example
//
//  Created by lylaut on 2021/9/28.
//  Copyright © 2021 richiezhl. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, ZLRefreshControlState) {
    ZLRefreshControlStateIdle = 0,
    ZLRefreshControlStatePulling,
    ZLRefreshControlStateWillRefreshing,
    ZLRefreshControlStateRefreshing,
    ZLRefreshControlStateNoMoreData
};

@interface ZLRefreshControlBaseComponent : UIView

@property (nonatomic, assign, readonly) ZLRefreshControlState state;

@property (nonatomic, assign, readonly) float pullProgress;

@property (nonatomic, assign) CGFloat layoutHeight;

@property (nonatomic, weak) UIScrollView *scrollView;

- (void)stateChanged:(ZLRefreshControlState)state;

- (void)pullProgressChanged:(float)pullProgress;

- (void)addRefreshTarget:(id)target action:(SEL)action;

- (void)beginRefreshing;

- (void)endRefreshing;

@end


@interface ZLRefreshControlBaseHeader : ZLRefreshControlBaseComponent

@end


@interface ZLRefreshControlBaseFooter : ZLRefreshControlBaseComponent

- (void)resetNoMoreData;

- (void)endRefreshingWithNoMoreData;

@end


@interface UIScrollView (ZLRefreshControl)

@property (nonatomic, weak) ZLRefreshControlBaseHeader *rcHeader;

@property (nonatomic, weak) ZLRefreshControlBaseFooter *rcFooter;

@end

NS_ASSUME_NONNULL_END
