
//
//  HWScrollView.m
//  HWScrollViewDemo
//
//  Created by HenryCheng on 16/1/22.
//  Copyright © 2016年 www.igancao.com. All rights reserved.
//

#import "HWScrollView.h"
#import "UIImageView+YYWebImage.h"

@interface HWPageControl : UIPageControl
/**
 *  当前选中的pageControl
 */
@property (strong, nonatomic) UIImage *activeImage;
/**
 *  没有选中的pageControl
 */
@property (strong, nonatomic) UIImage *inactiveImage;

@end

@interface HWScrollView ()<UIScrollViewDelegate>

@property (strong, nonatomic) UIScrollView *scrollView;
@property (strong, nonatomic) UIImageView *leftImageView;
@property (strong, nonatomic) UIImageView *centerImageView;
@property (strong, nonatomic) UIImageView *rightImageView;
@property (assign, nonatomic) NSUInteger leftImageIndex;
@property (assign, nonatomic) NSUInteger centerImageIndex;
@property (assign, nonatomic) NSUInteger rightImageIndex;

@property (strong, nonatomic) UIImage *placeHolderImage;
@property (strong, nonatomic) NSArray *imageURLArray;

@property (assign, nonatomic) NSTimer *timer;
@property (strong, nonatomic) HWPageControl *pageControl;
@property (assign, nonatomic) BOOL isTimeUp;

@end

@implementation HWScrollView

- (instancetype)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        
        _scrollTime = 3.0;
        _isAllowAutoScroll = YES;
            
        _scrollView = [[UIScrollView alloc]initWithFrame:self.bounds];
        _scrollView.backgroundColor = [UIColor whiteColor];
        _scrollView.bounces = NO;
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.pagingEnabled = YES;
        _scrollView.contentOffset = CGPointMake(CGRectGetWidth(_scrollView.frame), 0);
        _scrollView.contentSize = CGSizeMake(CGRectGetWidth(_scrollView.frame) * 3, CGRectGetHeight(_scrollView.frame));
        _scrollView.delegate = self;
        _scrollView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);

//        左
        _leftImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, CGRectGetWidth(_scrollView.frame), CGRectGetHeight(_scrollView.frame))];
        [_scrollView addSubview:_leftImageView];
//        中
        _centerImageView = [[UIImageView alloc]initWithFrame:CGRectMake(CGRectGetWidth(_scrollView.frame), 0, CGRectGetWidth(_scrollView.frame), CGRectGetHeight(_scrollView.frame))];
        _centerImageView.userInteractionEnabled = YES;
        [_centerImageView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapImageView)]];
        [_scrollView addSubview:_centerImageView];
//        右
        _rightImageView = [[UIImageView alloc]initWithFrame:CGRectMake(CGRectGetWidth(_scrollView.frame) * 2, 0, CGRectGetWidth(_scrollView.frame), CGRectGetHeight(_scrollView.frame))];
        [_scrollView addSubview:_rightImageView];
        
        [self addSubview:_scrollView];
        
    }
    return self;
}

- (void)willMoveToSuperview:(UIView *)newSuperview {
    if (!newSuperview) {
        [self.timer invalidate];
        self.timer = nil;
    } else {
        [self starTimer];
    }
}

- (void)setIsAllowAutoScroll:(BOOL)isAllowAutoScroll {
    _isAllowAutoScroll = isAllowAutoScroll;
    if (!isAllowAutoScroll || _imageURLArray.count < 2) {
        [_timer invalidate];
        _timer = nil;
    }
}

- (void)starTimer {
    if (_isAllowAutoScroll && _imageURLArray.count > 1) {
        _timer = [NSTimer scheduledTimerWithTimeInterval:_scrollTime target:self selector:@selector(moveImage) userInfo:nil repeats:YES];
        _isTimeUp = NO;
    }
}

#pragma mark --- Auto Scroll Banner Image
- (void)moveImage {
    [_scrollView setContentOffset:CGPointMake(CGRectGetWidth(_scrollView.frame) * 2, 0) animated:YES];
    _isTimeUp = YES;
    [NSTimer scheduledTimerWithTimeInterval:0.4f target:self selector:@selector(scrollViewDidEndDecelerating:) userInfo:nil repeats:NO];
}

#pragma mark --- UIScrollView Delegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    if (_scrollView.contentOffset.x == 0) {
        _centerImageIndex = _centerImageIndex - 1;
        _leftImageIndex = _leftImageIndex - 1;
        _rightImageIndex = _rightImageIndex - 1;
        
        if (_leftImageIndex == -1) _leftImageIndex = _imageURLArray.count - 1;
        if (_centerImageIndex == -1) _centerImageIndex = _imageURLArray.count - 1;
        if (_rightImageIndex == -1) _rightImageIndex = _imageURLArray.count - 1;
        
    } else if(_scrollView.contentOffset.x == CGRectGetWidth(_scrollView.frame) * 2) {
        _centerImageIndex = _centerImageIndex + 1;
        _leftImageIndex = _leftImageIndex + 1;
        _rightImageIndex = _rightImageIndex + 1;
        
        if (_leftImageIndex == _imageURLArray.count) _leftImageIndex = 0;
        if (_centerImageIndex == _imageURLArray.count) _centerImageIndex = 0;
        if (_rightImageIndex == _imageURLArray.count) _rightImageIndex = 0;
        
    } else {
        return;
    }
    
    [_leftImageView yy_setImageWithURL:[NSURL URLWithString:_imageURLArray[_leftImageIndex]] placeholder:_placeHolderImage];
    [_centerImageView yy_setImageWithURL:[NSURL URLWithString:_imageURLArray[_centerImageIndex]] placeholder:_placeHolderImage];
    [_rightImageView yy_setImageWithURL:[NSURL URLWithString:_imageURLArray[_rightImageIndex]] placeholder:_placeHolderImage];

    _pageControl.currentPage = _centerImageIndex;
    
    _scrollView.contentOffset = CGPointMake(CGRectGetWidth(_scrollView.frame), 0);
    
    //手动控制图片滚动应该取消那个三秒的计时器
    if (!_isTimeUp) {
        [_timer setFireDate:[NSDate dateWithTimeIntervalSinceNow:_scrollTime]];
    }
    _isTimeUp = NO;
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [_timer invalidate];
    _timer = nil;
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    [self starTimer];
}

- (void)tapImageView {
    if (_callBackBlock) {
        _callBackBlock(_centerImageIndex, _imageURLArray[_centerImageIndex]);
    }
}

+ (instancetype)scrollViewWithFrame:(CGRect)frame imageURLArray:(NSArray *)imageURLArray placeHolderImage:(NSString *)placeHolder pageControlShowStyle:(PageControlShowStyle)pageControlShowStyle {
    
    HWScrollView *scrollView = [[HWScrollView alloc]initWithFrame:frame];
    scrollView.placeHolderImage = [UIImage imageNamed:placeHolder];
    [scrollView addImageWithArray:imageURLArray];
    [scrollView addPageControlWithStyle:pageControlShowStyle];
    return scrollView;
}

- (void)addImageWithArray:(NSArray *)array {
    _imageURLArray = array;
    if (_imageURLArray.count == 0) return;
    
    _leftImageIndex = array.count - 1;
    _centerImageIndex = 0;
    _rightImageIndex = 1;
    [_leftImageView yy_setImageWithURL:[NSURL URLWithString:array[_leftImageIndex]] placeholder:_placeHolderImage];
    [_centerImageView yy_setImageWithURL:[NSURL URLWithString:array[_centerImageIndex]] placeholder:_placeHolderImage];
    if (array.count < 2) {
        _scrollView.scrollEnabled = NO;
        return;
    }
    [_rightImageView yy_setImageWithURL:[NSURL URLWithString:array[_rightImageIndex]] placeholder:_placeHolderImage];
}

- (void)addPageControlWithStyle:(PageControlShowStyle)pageControlStyle {
    
    if (pageControlStyle == PageControlShowStyleNone || _imageURLArray.count < 2) return;
    _pageControl = [[HWPageControl alloc]init];
    _pageControl.numberOfPages = _imageURLArray.count;
    
    switch (pageControlStyle) {
        case PageControlShowStyleBottomLeft:
            _pageControl.frame = CGRectMake(0, CGRectGetHeight(_scrollView.frame) - 20, 20 * _pageControl.numberOfPages, 20);
            break;
            case PageControlShowStyleCenter:
            _pageControl.frame = CGRectMake(CGRectGetWidth(_scrollView.frame) / 2, CGRectGetHeight(_scrollView.frame) - 20, 20 * _pageControl.numberOfPages, 20);
            break;
            case PageControlShowStyleBottomRight:
            _pageControl.frame = CGRectMake(CGRectGetWidth(_scrollView.frame) - 20 * _pageControl.numberOfPages, CGRectGetHeight(_scrollView.frame) - 40, 20 * _pageControl.numberOfPages, 20);
            break;
            case PageControlShowStyleTopLeft:
            _pageControl.frame = CGRectMake(0, 0, 20 * _pageControl.numberOfPages, 20);
            break;
            case PageControlShowStyleTopRight:
            _pageControl.frame = CGRectMake(CGRectGetWidth(_scrollView.frame) - 20 * _pageControl.numberOfPages, 0, 20 * _pageControl.numberOfPages, 20);
            break;
            
        default:
            break;
    }
    _pageControl.currentPage = 0;
    _pageControl.enabled = NO;
    [self addSubview:_pageControl];
}

@end

@implementation HWPageControl

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.activeImage = [UIImage imageNamed:@"all_yellow_circle"];
        self.inactiveImage = [UIImage imageNamed:@"border_yellow_circle"];
    }
    return self;
}
- (void)updateDots {
    for (int i = 0; i < [self.subviews count]; i++) {
        UIImageView *imageV = [[UIImageView alloc]initWithFrame:self.subviews[i].bounds];
        [self.subviews[i] addSubview:imageV];
    }
    for (int i = 0; i < [self.subviews count]; i++) {
        UIImageView *imagev = (UIImageView *)self.subviews[i].subviews[0];
        if ([imagev isKindOfClass:[UIImageView class]]) {
            if (i == self.currentPage) {
                imagev.image = _activeImage;
            } else {
                imagev.image = _inactiveImage;
            }
        }
    }
}
- (void)setCurrentPage:(NSInteger)page {
    [super setCurrentPage:page];
    [self updateDots];
}

@end
