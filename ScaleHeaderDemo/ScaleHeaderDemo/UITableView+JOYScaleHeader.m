//
//  UITableView+JOYScaleHeader.m
//  ScaleHeaderDemo
//
//  Created by Ssuperjoy on 2017/9/6.
//  Copyright © 2017年 Ssuperjoy. All rights reserved.
//

#import "UITableView+JOYScaleHeader.h"
#import <objc/runtime.h>

static void * ScaleTableViewHeaderContext = &ScaleTableViewHeaderContext;

@interface JOYScaleTableHeaderView : UIView

@property (nonatomic, strong) UIImageView *headerImageView;

@property (nonatomic, strong) UIView *headerCoverView;

@property (nonatomic, assign) CGFloat headerHeight;

@property (nonatomic, assign) CGFloat maxScaleHeight;

@property (nonatomic, assign) CGFloat originInsetTop;

@property (nonatomic, assign) BOOL firstLayoutFinish;

@end

@implementation JOYScaleTableHeaderView

- (void)willMoveToSuperview:(UIView *)newSuperview
{
    if (self.superview && newSuperview == nil) {
        if ([self.superview respondsToSelector:@selector(contentOffset)]) {
            [self.superview removeObserver:self forKeyPath:NSStringFromSelector(@selector(contentOffset)) context:ScaleTableViewHeaderContext];
        }
    } else if (newSuperview) {
        if ([newSuperview respondsToSelector:@selector(contentOffset)]) {
            [newSuperview addObserver:self forKeyPath:NSStringFromSelector(@selector(contentOffset)) options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:ScaleTableViewHeaderContext];
        }
    }
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    self.frame = CGRectMake(0, 0, self.superview.bounds.size.width, self.headerHeight);
    
    if ([self.superview respondsToSelector:@selector(contentOffset)] && !self.firstLayoutFinish) {
        self.firstLayoutFinish = YES;
        UIScrollView *scrollView = (UIScrollView *)self.superview;
        if (@available(iOS 11.0, *)) {
            self.originInsetTop = scrollView.adjustedContentInset.top;
        } else {
            self.originInsetTop = scrollView.contentInset.top;
        }
        
        self.headerImageView.frame = self.bounds;
        self.headerCoverView.frame = self.bounds;
    }
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context
{
    if (context == ScaleTableViewHeaderContext) {
        UIScrollView *scrollView = (UIScrollView *)object;
        if ([keyPath isEqualToString:NSStringFromSelector(@selector(contentOffset))]) {
            
            if (scrollView.contentOffset.y <= -self.originInsetTop) { // 下拉放大
                CGRect originFrame = self.headerImageView.frame;
                originFrame.origin.y = self.originInsetTop + scrollView.contentOffset.y;
                originFrame.size.height = self.headerHeight-self.originInsetTop - scrollView.contentOffset.y;
                originFrame.size.width = self.bounds.size.width;
                self.headerImageView.frame = originFrame;
                if (self.headerCoverView) {
                    self.headerCoverView.frame = self.headerImageView.frame;
                }
                [self.headerImageView layoutIfNeeded];
            }
            if (scrollView.contentOffset.y <= -self.originInsetTop-(self.maxScaleHeight?:MAXFLOAT)) { // 最大下拉距离
                CGPoint newOffset = [change[NSKeyValueChangeNewKey] CGPointValue];
                CGPoint oldOffset = [change[NSKeyValueChangeOldKey] CGPointValue];
                if (newOffset.y == oldOffset.y) {
                    return;
                }
                CGPoint offset = scrollView.contentOffset;
                offset.y = -self.originInsetTop-self.maxScaleHeight;
                scrollView.contentOffset = offset;
            }
        }
    }
}

@end


@interface UITableView (JOYScaleHeaderInner)

@property (nonatomic, weak) JOYScaleTableHeaderView *joy_scaleTableHeaderView;

@end

@implementation UITableView (JOYScaleHeaderInner)

- (JOYScaleTableHeaderView *)joy_scaleTableHeaderView
{
    return objc_getAssociatedObject(self, _cmd);
}

- (void)setJoy_scaleTableHeaderView:(JOYScaleTableHeaderView *)joy_scaleTableHeaderView
{
    objc_setAssociatedObject(self, @selector(joy_scaleTableHeaderView), joy_scaleTableHeaderView, OBJC_ASSOCIATION_ASSIGN);
}

@end


@implementation UITableView (JOYScaleHeader)

- (void)joy_setupScaleHeaderWithHeight:(CGFloat)headerHeight
{
    JOYScaleTableHeaderView *scaleTableHeaderView = [[JOYScaleTableHeaderView alloc] init];
    scaleTableHeaderView.backgroundColor = [UIColor clearColor];
    scaleTableHeaderView.frame = CGRectMake(0, 0, self.bounds.size.width, headerHeight);
    self.tableHeaderView = scaleTableHeaderView;
    self.joy_scaleTableHeaderView = scaleTableHeaderView;
    
    UIImageView *scaleHeaderImgView = [[UIImageView alloc] init];
    scaleHeaderImgView.frame = CGRectMake(0, 0, self.bounds.size.width, headerHeight);
    scaleHeaderImgView.clipsToBounds = YES;
    scaleHeaderImgView.contentMode = UIViewContentModeScaleAspectFill;
    scaleHeaderImgView.userInteractionEnabled = YES;
    [scaleTableHeaderView addSubview:scaleHeaderImgView];
    
    scaleTableHeaderView.headerHeight = headerHeight;
    scaleTableHeaderView.headerImageView = scaleHeaderImgView;
}

- (void)joy_setScaleHeaderImage:(UIImage *)image
{
    self.joy_scaleTableHeaderView.headerImageView.image = image;
}

- (void)joy_setScaleHeaderCoverView:(UIView *)headerCoverView
{
    if (self.joy_scaleTableHeaderView && headerCoverView) {
        headerCoverView.frame = self.joy_scaleTableHeaderView.headerImageView.frame;
        [self.joy_scaleTableHeaderView addSubview:headerCoverView];
        self.joy_scaleTableHeaderView.headerCoverView = headerCoverView;
    }
}

- (void)joy_setHeaderMaxScaleHeight:(CGFloat)maxHeight
{
    self.joy_scaleTableHeaderView.maxScaleHeight = maxHeight;
}

@end
