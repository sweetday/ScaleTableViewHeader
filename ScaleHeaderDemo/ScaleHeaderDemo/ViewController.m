//
//  ViewController.m
//  ScaleHeaderDemo
//
//  Created by Ssuperjoy on 2017/9/6.
//  Copyright © 2017年 Ssuperjoy. All rights reserved.
//

#import "ViewController.h"
#import "UITableView+JOYScaleHeader.h"
#import "TestCoverView.h"
#import "SDWebImageManager.h"

static NSString * const ImgUrl = @"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1504729989612&di=570a6f79b3c88b21c7d2a06702bc5d68&imgtype=0&src=http%3A%2F%2Fup.qqya.com%2Fallimg%2F2017-p10%2F17-103120_4835.jpg";

@interface ViewController ()

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.tableView joy_setupScaleHeaderWithHeight:200];
    
    // 通过网络下载图片
    __weak typeof(self) weakSelf = self;
    [[SDWebImageManager sharedManager] downloadImageWithURL:[NSURL URLWithString:ImgUrl] options:SDWebImageRetryFailed progress:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        if (!error && image) {
            [strongSelf.tableView joy_setScaleHeaderImage:image];
        }
    }];
    // 本地图片
//    [self.tableView joy_setScaleHeaderImage:[UIImage imageNamed:@"katong"]];
    
    [self.tableView joy_setHeaderMaxScaleHeight:200];
    
    TestCoverView *testCoverView = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass(TestCoverView.class) owner:nil options:nil].lastObject;
    [self.tableView joy_setScaleHeaderCoverView:testCoverView];
}


@end
