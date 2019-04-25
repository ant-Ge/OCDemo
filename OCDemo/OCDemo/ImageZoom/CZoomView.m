//
//  CZoomView.m
//  OCDemo
//
//  Created by Ant on 2019/4/24.
//  Copyright © 2019 SomeBoy. All rights reserved.
//

#import "CZoomView.h"

@interface CZoomView () <UIScrollViewDelegate>

@property (nonatomic, strong) UIScrollView *scrollView;

@property (nonatomic, strong) UIImageView *zoomView;

@property (nonatomic, assign) CGPoint largePoint; //发达手势的位置

@end

@implementation CZoomView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self addSubview:self.scrollView];
        [self addGesture];
        _scrollView.frame = frame;
    }
    return self;
}

- (void)setImageName:(NSString *)imageName {
    UIImage *aImage = [UIImage imageNamed:imageName];
    NSAssert(!CGSizeEqualToSize(CGSizeZero, aImage.size), @"image name not found is nil");
    
    if (_zoomView) {
        [_zoomView removeFromSuperview];
    }
    _zoomView = [[UIImageView alloc] initWithImage:aImage];
    _zoomView.frame = CGRectMake(0, 0, aImage.size.width, aImage.size.height);
    _scrollView.contentSize = aImage.size;
    [_scrollView addSubview:_zoomView];
    CGFloat maxSale = [self getMaxSale];
    CGFloat minSale = [self getMinSale];
    _scrollView.maximumZoomScale = maxSale;
    _scrollView.minimumZoomScale = minSale;
    _scrollView.zoomScale = minSale;
    _zoomView.center = _scrollView.center;
}
- (CGFloat)getMaxSale {
    
    CGSize imageSize = self.zoomView.image.size;
    CGSize viewSize = self.frame.size;
    CGFloat widthSale = viewSize.width / imageSize.width;
    CGFloat heigthSale = viewSize.height / imageSize.height;
    return fmax(widthSale, heigthSale);
}
- (CGFloat)getMinSale {
    
    CGSize imageSize = self.zoomView.image.size;
    CGSize viewSize = self.frame.size;
    CGFloat widthSale = viewSize.width / imageSize.width;
    CGFloat heigthSale = viewSize.height / imageSize.height;
    return fmin(widthSale, heigthSale);
}
- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    return _zoomView;
}
//缩放手势触发的时候才会调用
- (void)scrollViewWillBeginZooming:(UIScrollView *)scrollView withView:(UIView *)view {
    
    UIView *subView = [scrollView.subviews objectAtIndex:0];
    CGFloat offsetX = MAX((scrollView.bounds.size.width - scrollView.contentSize.width) * 0.5, 0.0);
    CGFloat offsetY = MAX((scrollView.bounds.size.height - scrollView.contentSize.height) * 0.5, 0.0);
    subView.center = CGPointMake(scrollView.contentSize.width * 0.5 + offsetX,scrollView.contentSize.height * 0.5 + offsetY);
}
//完成缩放的时候调用
- (void)scrollViewDidZoom:(UIScrollView *)scrollView {
    
    //location zoomView in center
    CGPoint offset = scrollView.contentOffset;
    UIView *subView = [scrollView.subviews objectAtIndex:0];
    CGFloat offsetX = MAX((scrollView.bounds.size.width - scrollView.contentSize.width) * 0.5, 0.0);
    CGFloat offsetY = MAX((scrollView.bounds.size.height - scrollView.contentSize.height) * 0.5, 0.0);
    
    if (CGPointEqualToPoint(_largePoint, CGPointZero)) {
        subView.center = CGPointMake(scrollView.contentSize.width * 0.5 + offsetX,scrollView.contentSize.height * 0.5 + offsetY);
    } else {
        CGSize size = subView.frame.size;
        if (_largePoint.x < CGRectGetMidX(self.bounds) && _largePoint.y < CGRectGetMaxY(self.bounds)) {
            subView.frame = (CGRect){0,0,size};
        } else if (_largePoint.x < CGRectGetMidX(self.bounds) && _largePoint.y > CGRectGetMaxY(self.bounds)) {
            subView.frame = (CGRect){0,scrollView.bounds.size.height - scrollView.contentSize.height, size};
        }
        _largePoint = CGPointZero;
    }
}
#pragma mark - property
- (UIScrollView *)scrollView {
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] initWithFrame:CGRectZero];
        _scrollView.delegate = self;
        //当缩放超出最大或最小限制时，滚动视图是否为内容缩放设置动画。
        _scrollView.bouncesZoom = YES;
        _scrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }
    return _scrollView;
}


@end


@implementation CZoomView (Gesture)

- (void)addGesture {
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onTapGesture:)];
    tapGesture.numberOfTapsRequired = 2;
    [self addGestureRecognizer:tapGesture];
    
    UITapGestureRecognizer *resetZoomScale = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onResetTapGesture:)];
    resetZoomScale.numberOfTapsRequired = 1;
    [resetZoomScale requireGestureRecognizerToFail:tapGesture];
    [self addGestureRecognizer:resetZoomScale];
}
- (void)onTapGesture:(UITapGestureRecognizer *)tapGes {
    
    _largePoint = [tapGes locationInView:self];
    self.scrollView.zoomScale = [self getMaxSale];
}
- (void)onResetTapGesture:(UITapGestureRecognizer *)tapGes {
    self.scrollView.zoomScale = [self getMinSale];
}
@end
