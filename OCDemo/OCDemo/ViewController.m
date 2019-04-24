//
//  ViewController.m
//  OCDemo
//
//  Created by Ant on 2019/4/24.
//  Copyright © 2019 SomeBoy. All rights reserved.
//

#import "ViewController.h"
#import "CZoomView.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self testZoomView];
}
- (void)testZoomView {
 
    CGRect rect = [UIScreen mainScreen].bounds;
    CZoomView *zoomView = [[CZoomView alloc] initWithFrame:rect];
    [zoomView setImageName:@"meinv2"];
    [self.view addSubview:zoomView];
    self.automaticallyAdjustsScrollViewInsets = NO;
 }

@end
