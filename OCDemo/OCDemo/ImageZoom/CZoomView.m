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

@end

@implementation CZoomView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self addSubview:self.scrollView];
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
    CGFloat maxSale = fmax(1.0, [self getMaxSale]);
    CGFloat minSale = fmin([self getMinSale], 1.0);
    _scrollView.maximumZoomScale = maxSale;
    _scrollView.minimumZoomScale = minSale;
    _scrollView.zoomScale = minSale;
    _zoomView.center = _scrollView.center;
}
- (CGFloat)getMaxSale {
    CGSize sizeA = self.zoomView.image.size;
    CGSize sizeB = self.frame.size;
    CGFloat bigWidth = fmax(sizeA.width, sizeB.width);
    CGFloat minWidth = fmin(sizeA.width, sizeB.width);
    CGFloat bigHeight = fmax(sizeA.height, sizeB.height);
    CGFloat minHeight = fmin(sizeA.height, sizeB.height);
    
    CGFloat widthSale = bigWidth / minWidth;
    CGFloat heightSale = bigHeight / minHeight;
    return fmax(widthSale, heightSale);
}
- (CGFloat)getMinSale {
    CGSize sizeA = self.zoomView.image.size;
    CGSize sizeB = self.frame.size;
    CGFloat bigWidth = fmax(sizeA.width, sizeB.width);
    CGFloat minWidth = fmin(sizeA.width, sizeB.width);
    CGFloat bigHeight = fmax(sizeA.height, sizeB.height);
    CGFloat minHeight = fmin(sizeA.height, sizeB.height);
    
    CGFloat widthSale = bigWidth / minWidth;
    CGFloat heightSale = bigHeight / minHeight;
    return fmin(widthSale, heightSale);
}
- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    return _zoomView;
}
- (void)scrollViewWillBeginZooming:(UIScrollView *)scrollView withView:(UIView *)view {
    NSLog(@"%@", NSStringFromCGRect(view.frame));
    UIView *subView = [scrollView.subviews objectAtIndex:0];
    CGFloat offsetX = MAX((scrollView.bounds.size.width - scrollView.contentSize.width) * 0.5, 0.0);
    CGFloat offsetY = MAX((scrollView.bounds.size.height - scrollView.contentSize.height) * 0.5, 0.0);
    
    subView.center = CGPointMake(scrollView.contentSize.width * 0.5 + offsetX,
                                 scrollView.contentSize.height * 0.5 + offsetY);
}
//
//正在缩放的时候调用
- (void)scrollViewDidZoom:(UIScrollView *)scrollView {
    
    UIView *subView = [scrollView.subviews objectAtIndex:0];
    CGFloat offsetX = MAX((scrollView.bounds.size.width - scrollView.contentSize.width) * 0.5, 0.0);
    CGFloat offsetY = MAX((scrollView.bounds.size.height - scrollView.contentSize.height) * 0.5, 0.0);
    
    subView.center = CGPointMake(scrollView.contentSize.width * 0.5 + offsetX,
                                 scrollView.contentSize.height * 0.5 + offsetY);
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
