//
//  RefreshControlFooter.h
//  ZLRefreshControl_Example
//
//  Created by lylaut on 2021/9/29.
//  Copyright © 2021 richiezhl. All rights reserved.
//

#import <ZLRefreshControl/UIScrollView+ZLRefreshControl.h>

NS_ASSUME_NONNULL_BEGIN

@interface RefreshControlFooter : ZLRefreshControlBaseFooter

+ (instancetype)footerWithRefreshingTarget:(id)target refreshingAction:(SEL)action;

@end

NS_ASSUME_NONNULL_END
