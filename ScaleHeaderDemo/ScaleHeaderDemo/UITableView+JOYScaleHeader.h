//
//  UITableView+JOYScaleHeader.h
//  ScaleHeaderDemo
//
//  Created by Ssuperjoy on 2017/9/6.
//  Copyright © 2017年 Ssuperjoy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITableView (JOYScaleHeader)

- (void)joy_setupScaleHeaderWithHeight:(CGFloat)headerHeight;

- (void)joy_setScaleHeaderImage:(UIImage *)image;

- (void)joy_setScaleHeaderCoverView:(UIView *)headerCoverView;

- (void)joy_setHeaderMaxScaleHeight:(CGFloat)maxHeight;

@end
