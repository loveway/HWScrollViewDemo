//
//  ViewController.m
//  HWScrollViewDemo
//
//  Created by HenryCheng on 16/1/22.
//  Copyright © 2016年 www.igancao.com. All rights reserved.
//

#import "ViewController.h"
#import "HWScrollView.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSArray *imageArray = @[
                            @"https://d13yacurqjgara.cloudfront.net/users/26059/screenshots/2047158/beerhenge.jpg",
                            @"https://d13yacurqjgara.cloudfront.net/users/26059/screenshots/2016158/avalanche.jpg",
                            @"https://d13yacurqjgara.cloudfront.net/users/26059/screenshots/1839353/pilsner.jpg",
                            @"https://d13yacurqjgara.cloudfront.net/users/26059/screenshots/1833469/porter.jpg",
                            ];
    
    HWScrollView *scrollV = [HWScrollView scrollViewWithFrame:CGRectMake(0, 64, CGRectGetWidth(self.view.frame), 120)  imageURLArray:imageArray placeHolderImage:@"pictureHolder" pageControlShowStyle:PageControlShowStyleCenter];
    self.automaticallyAdjustsScrollViewInsets = NO;

    scrollV.callBackBlock = ^(NSInteger index, NSString *imageURL) {
        NSLog(@"点击了第 %ld 张",index);
    };
    [self.view addSubview:scrollV];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
