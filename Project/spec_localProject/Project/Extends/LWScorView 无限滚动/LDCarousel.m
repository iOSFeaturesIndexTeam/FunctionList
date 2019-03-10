//
//  LDCarousel.m
//  spec_localProject
//
//  Created by Little.Daddly on 2019/2/05.
//  Copyright © 2018年 Little.Daddly. All rights reserved.
//


#import "LDCarousel.h"
#import <SDWebImage/UIImageView+WebCache.h>
//#import "UIView+custom.h"
//#import "UIImageView+network.h"


#pragma mark - 轮播使用的collectionViewCell

/**
 加载远程图、本地图
 */
@interface ZCLLoopViewCell : UICollectionViewCell

/**本地图片名称*/
@property (nonatomic, copy) NSString *imgName;
/**网络图片路径*/
@property (nonatomic, copy) NSString *imgUrl;
/**展位图*/
@property (nonatomic, strong) UIImage *placeholderImage;
/**cell里的imageView*/
@property (nonatomic, weak) UIImageView *imgView;
@end

@implementation ZCLLoopViewCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupImageViews];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.imgView.frame = self.bounds;
}

- (void)setupImageViews {
    UIImageView *imageView = [[UIImageView alloc] init];
    //设置默认的图片展示方式
    imageView.contentMode = UIViewContentModeScaleToFill;
    self.imgView = imageView;
    self.backgroundColor = [UIColor whiteColor];
    [self.contentView addSubview:self.imgView];
}

- (void)setImgName:(NSString *)imgName {
    _imgName = imgName;
    self.imgView.image = [UIImage imageNamed:imgName]?:self.placeholderImage;
}

- (void)setImgUrl:(NSString *)imgUrl {
    _imgUrl = imgUrl;
    [self.imgView sd_setImageWithURL:[NSURL URLWithString:imgUrl] placeholderImage:self.placeholderImage options:SDWebImageProgressiveDownload];
}

@end


#pragma mark - 轮播工具类

static NSString * const ZCLLoopViewCellId = @"_LDloopViewCellId";

@interface LDCarousel()<UICollectionViewDelegate,UICollectionViewDataSource>

/**轮播所用的collectionView*/
@property (nonatomic, strong) UICollectionView *collectionView;
/**轮播collectionView所用的layout*/
@property (nonatomic, strong) UICollectionViewFlowLayout *collectionViewLayout;
/**轮播所用的图片数组*/
@property (nonatomic, strong) NSMutableArray *loopImageList;
/**自动轮播定时器*/
@property (nonatomic, strong) NSTimer *loopTimer;
/**当前滚动的位置*/
@property (nonatomic, assign) NSInteger currentIndex;

/**底部黑条*/
@property (nonatomic, strong) UIView *bottomView;
/**标题*/
@property (nonatomic, strong) UILabel *titleLabel;
/**分页控制*/
@property (nonatomic, strong) UIPageControl *pageControl;

@end

@implementation LDCarousel

#pragma mark --------------------init--------------------

+ (instancetype)initCarouselWithFrame:(CGRect)frame {
    return [[self alloc] initWithFrame:frame];
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        [self addSubview:self.collectionView];
        self.loop = NO;
        self.autoScrollTimeInterval = 0;
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    //默认滚动到要显示的第一张图片
    if (self.collectionView.contentOffset.x == 0) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:1 inSection:0];
        [self scrollToIndexPath:indexPath animated:NO];
        [self startTimer];
        self.currentIndex = 1;
    }
    
    //添加底部的标题和pageControl
    [self addSubview:self.bottomView];
}

#pragma mark --------------------public methods--------------------

//关闭轮播计时器
- (void)stopTimer {
    [self.loopTimer invalidate];
    self.loopTimer = nil;
}

#pragma mark --------------------private methods--------------------
- (void)resumeTimer{
    [self startTimer];
}
//开启轮播计时器
- (void)startTimer {
    if (self.isLoop && self.autoScrollTimeInterval > 0) {
        [self.loopTimer invalidate];
        self.loopTimer = nil;
        NSTimer *timer = [NSTimer timerWithTimeInterval:self.autoScrollTimeInterval target:self selector:@selector(startAutoScroll) userInfo:nil repeats:YES];
        [[NSRunLoop currentRunLoop] addTimer:timer forMode:NSDefaultRunLoopMode];
        self.loopTimer = timer;
    }
    else {
        [self stopTimer];
    }
}

//collectionView滚动到指定位置
- (void)scrollToIndexPath:(NSIndexPath *)indexPath animated:(BOOL)animated {
    if (self.loopImageList.count > indexPath.row) {
        [self.collectionView scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionNone animated:animated];
    }
}

#pragma mark --------------------target actions--------------------

//开始自动轮播
- (void)startAutoScroll {
    NSInteger nextIndex = self.currentIndex + 1;
    //若一轮循环完了，则将index置为1重新开始
    nextIndex = (nextIndex == self.loopImageList.count) ? 1 : nextIndex;
    NSIndexPath *indexPath = [NSIndexPath indexPathForItem:nextIndex inSection:0];
    BOOL isNeedAnim = self.autoScrollTimeInterval <= 0.5 ? NO : YES;
    [self scrollToIndexPath:indexPath animated:isNeedAnim];
}

#pragma mark --------------------collectionView datasource--------------------

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.loopImageList.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    ZCLLoopViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:ZCLLoopViewCellId forIndexPath:indexPath];
    if (!cell) {
        cell = [[ZCLLoopViewCell alloc] init];
        cell.imgView.contentMode = self.imageContentMode;
    }
    NSString *imageName = self.loopImageList[indexPath.row];
    if ([imageName hasPrefix:@"http://"] || [imageName hasPrefix:@"https://"]) {
        cell.imgUrl = imageName;
    }else {
        cell.imgName = imageName;
    }
    
    return cell;
}

#pragma mark --------------------collectionView delegate--------------------

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (self.delegate && [self.delegate respondsToSelector:@selector(carousel:didSelectItemAtIndex:)]) {
        [self.delegate carousel:self didSelectItemAtIndex:indexPath.item - 1];
    }
}

#pragma mark --------------------scrollView delegate--------------------

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [self stopTimer];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    [self startTimer];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat width = self.bounds.size.width;
    //在loopImageList中，有n+2个对象，因此index取offset.x/width后的整数
    NSInteger index = scrollView.contentOffset.x/width;
    //这个比值很重要
    CGFloat ratio = scrollView.contentOffset.x/width;
    
    //从显示的最后一张往后滚，自动跳转到显示的第一张
    if (index == self.loopImageList.count-1) {
        self.currentIndex = 1;
        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:self.currentIndex inSection:0];
        [self scrollToIndexPath:indexPath animated:NO];
        return;
    }
    
    //从显示的第一张往前滚，自动跳转到显示的最后一张
    //这里判断条件为contentOffset.x和宽的比值，在往前滚快要结束的时候，能达到无缝切换到显示的最后一张的效果
    if (ratio <= 0.01) {
        self.currentIndex = self.imageList.count;
        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:self.currentIndex inSection:0];
        [self scrollToIndexPath:indexPath animated:NO];
        return;
    }
    
    if (self.currentIndex != index) {
        self.currentIndex = index;
    }
    
    NSLog(@"currentIndex = %ld",self.currentIndex);
}

#pragma mark --------------------setter & getter--------------------

- (void)setImageList:(NSMutableArray *)imageList {
    _imageList = imageList;
    self.loopImageList = [NSMutableArray arrayWithArray:imageList];
    if (imageList.count>0) {
        [self.loopImageList insertObject:[imageList lastObject] atIndex:0];
        [self.loopImageList addObject:[imageList objectAtIndex:0]];
    }
}

- (void)setCurrentIndex:(NSInteger)currentIndex {
    _currentIndex = currentIndex;
    NSInteger index = 0;
    if (currentIndex > 0) {
        index = currentIndex-1;
    }
    self.titleLabel.text = self.titleList[index];
    self.pageControl.currentPage = index;
}

- (UICollectionView *)collectionView {
    if (!_collectionView) {
        _collectionView = [[UICollectionView alloc] initWithFrame:self.bounds collectionViewLayout:self.collectionViewLayout];
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.pagingEnabled = YES;
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        [_collectionView registerClass:[ZCLLoopViewCell class] forCellWithReuseIdentifier:ZCLLoopViewCellId];
    }
    return _collectionView;
}

- (UICollectionViewFlowLayout *)collectionViewLayout {
    if (!_collectionViewLayout) {
        _collectionViewLayout = [[UICollectionViewFlowLayout alloc] init];
        _collectionViewLayout.itemSize = self.bounds.size;
        _collectionViewLayout.minimumLineSpacing = 0;
        _collectionViewLayout.minimumInteritemSpacing = 0;
        _collectionViewLayout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
        _collectionViewLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    }
    return _collectionViewLayout;
}

- (UIView *)bottomView {
    if (!_bottomView) {
        _bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, self.bounds.size.height-28, UNION_SCREEN_WIDTH, 28)];
        _bottomView.backgroundColor = self.titleList.count>0 ? [UIColor colorWithRed:0/255 green:0/255 blue:0/255 alpha:0.5] : [UIColor clearColor];
        [_bottomView addSubview:self.pageControl];
        if (self.titleList.count > 0) {
            [_bottomView addSubview:self.titleLabel];
            [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(_bottomView).offset(10);
                make.centerY.equalTo(_bottomView);
            }];
            [self.pageControl mas_makeConstraints:^(MASConstraintMaker *make) {
                make.right.equalTo(_bottomView).offset(-10);
                make.centerY.equalTo(_bottomView);
            }];
        }else {
            [self.pageControl mas_makeConstraints:^(MASConstraintMaker *make) {
                make.center.equalTo(_bottomView);
            }];
        }
        
    }
    return _bottomView;
}
- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.text = self.titleList[0];
        _titleLabel.textColor = [UIColor whiteColor];
        _titleLabel.font = [UIFont systemFontOfSize:15.0f];
    }
    return _titleLabel;
}
- (UIPageControl *)pageControl {
    if (!_pageControl) {
        _pageControl = [[UIPageControl alloc] init];
        _pageControl.hidesForSinglePage = YES;
        _pageControl.userInteractionEnabled = NO;
        _pageControl.numberOfPages = self.imageList.count;
        _pageControl.currentPage = 0;
        //设置非选中页的圆点颜色
        _pageControl.pageIndicatorTintColor = [UIColor union_colorWithHex:0x999999];
        //设置选中页的圆点颜色
        _pageControl.currentPageIndicatorTintColor = [UIColor whiteColor];
    }
    return _pageControl;
}

#pragma mark --------------------other--------------------

- (void)dealloc {
    NSLog(@"loopScrollView dealloc");
}

@end

