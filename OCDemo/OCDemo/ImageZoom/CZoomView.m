//
//  CZoomView.m
//  OCDemo
//
//  Created by Ant on 2019/4/24.
//  Copyright © 2019 SomeBoy. All rights reserved.
//

#import "CZoomView.h"
#import <AVKit/AVKit.h>

@interface CZoomView () <UIScrollViewDelegate>

@property (nonatomic, strong) UIScrollView *scrollView;

@property (nonatomic, strong) UIImageView *zoomView;

@property (nonatomic, assign) CGPoint largePoint; //发达手势的位置

@property (nonatomic, assign) UIEdgeInsets insets;

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
    CGRect restRect =  AVMakeRectWithAspectRatioInsideRect(aImage.size, self.bounds);//居中显示的frame
    _zoomView = [[UIImageView alloc] initWithImage:aImage];
    _zoomView.frame = (CGRect){0,0,restRect.size};
    _scrollView.contentSize = aImage.size;
    [_scrollView addSubview:_zoomView];
    _scrollView.zoomScale = 1;
    _scrollView.minimumZoomScale = 1;
    _scrollView.maximumZoomScale = 2;
    [_scrollView setBounces:NO];
    _insets = UIEdgeInsetsMake(restRect.origin.y, restRect.origin.x, restRect.origin.y, restRect.origin.x);
    _scrollView.contentInset = _insets;
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
    
}
//完成缩放的时候调用
- (void)scrollViewDidZoom:(UIScrollView *)scrollView {
    
    CGFloat sale = 2 - scrollView.zoomScale;
    UIEdgeInsets nInsets =  UIEdgeInsetsMake(_insets.top * sale, _insets.left * sale, _insets.bottom * sale, _insets.right * sale);
    scrollView.contentInset = nInsets;
    
}
- (void)scrollViewDidEndZooming:(UIScrollView *)scrollView withView:(UIView *)view atScale:(CGFloat)scale {
    if (scale < 1.3) {
        _scrollView.contentInset = _insets;
        [scrollView setZoomScale:1 animated:YES];
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
