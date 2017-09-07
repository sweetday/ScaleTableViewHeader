# ScaleTableViewHeader
使用tableView分类实现的下拉放大效果，使用时只要添加两个文件即可（UITableView+JOYScaleHeader.h和.m）

对下拉放大控件进行初始化：
```
- (void)joy_setupScaleHeaderWithHeight:(CGFloat)headerHeight;
```
设置下拉放大控件的图片：
```
- (void)joy_setScaleHeaderImage:(UIImage *)image;  
```
实现以上两个方法就可以实现下拉放大的效果

# Screenshots
<img src="https://github.com/sweetday/ScaleTableViewHeader/blob/master/Screenshots/normal.PNG" width="25%" height="25%" />      <img src="https://github.com/sweetday/ScaleTableViewHeader/blob/master/Screenshots/scale.PNG" width="25%" height="25%" />
