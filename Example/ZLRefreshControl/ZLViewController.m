//
//  ZLViewController.m
//  ZLRefreshControl
//
//  Created by richiezhl on 09/28/2021.
//  Copyright (c) 2021 richiezhl. All rights reserved.
//

#import "ZLViewController.h"
#import "RefreshControlHeader.h"
#import "RefreshControlFooter.h"

@interface ZLViewController ()

@property (nonatomic, weak) UIScrollView *scrollView;

@end

@implementation ZLViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 200, 1600)];
    view.backgroundColor = [UIColor greenColor];
    
    UIButton *label = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 100, 60)];
    [label setTitle:@"只只只只只" forState:UIControlStateNormal];
    [label setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [label addTarget:self action:@selector(tapLabel) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:label];
    
    UILabel *label1 = [[UILabel alloc] initWithFrame:CGRectMake(0, 1570, 100, 30)];
    label1.text = @"底部";
    [view addSubview:label1];
    
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(60, 60, 200, 300)];
    scrollView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    scrollView.backgroundColor = [UIColor grayColor];
    [self.view addSubview:scrollView];
    self.scrollView = scrollView;
    
    scrollView.contentInset = UIEdgeInsetsMake(-10, 0, -10, 0);
    scrollView.scrollIndicatorInsets = scrollView.contentInset;
    
    [scrollView addSubview:view];
    scrollView.contentSize = view.frame.size;
    
    RefreshControlHeader *header = [RefreshControlHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadData)];
    scrollView.rcHeader = header;
    
    scrollView.rcFooter = [RefreshControlFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMore)];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [header beginRefreshing];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(10 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [header endRefreshing];
        });
    });
}

- (void)tapLabel {
    NSLog(@"%s", __FUNCTION__);
}

- (void)loadData {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.scrollView.rcHeader endRefreshing];
    });
}

- (void)loadMore {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.scrollView.rcFooter endRefreshing];
    });
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
