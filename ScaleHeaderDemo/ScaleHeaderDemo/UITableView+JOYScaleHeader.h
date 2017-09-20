//
//  UITableView+JOYScaleHeader.h
//  ScaleHeaderDemo
//
//  Created by Ssuperjoy on 2017/9/6.
//  Copyright © 2017年 Ssuperjoy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITableView (JOYScaleHeader)


/**
 初始化下拉放大控件

 @param headerHeight 下拉放大控件高度
 */
- (void)joy_setupScaleHeaderWithHeight:(CGFloat)headerHeight;


/**
 设置下拉放大控件的图片

 @param image 图片
 */
- (void)joy_setScaleHeaderImage:(UIImage *)image;


/**
 设置覆盖在下拉放大控件上的视图

 @param headerCoverView 覆盖的视图
 */
- (void)joy_setScaleHeaderCoverView:(UIView *)headerCoverView;


/**
 设置最大下拉距离

 @param maxHeight 最大下拉距离
 */
- (void)joy_setHeaderMaxScaleHeight:(CGFloat)maxHeight;

@end
