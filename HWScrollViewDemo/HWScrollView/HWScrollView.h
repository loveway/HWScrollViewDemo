//
//  HWScrollView.h
//  HWScrollViewDemo
//
//  Created by HenryCheng on 16/1/22.
//  Copyright © 2016年 www.igancao.com. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, PageControlShowStyle) {
    
    PageControlShowStyleNone        = 0,
    PageControlShowStyleBottomLeft  = 1 << 0,
    PageControlShowStyleCenter      = 1 << 1,
    PageControlShowStyleBottomRight = 1 << 2,
    PageControlShowStyleTopLeft     = 1 << 3,
    PageControlShowStyleTopRight    = 1 << 4
    
};

typedef void(^tapCallBackBlock)(NSInteger index, NSString *imageURL);

@interface HWScrollView : UIView
/**
 *  自动滑动的时间间隔
 */
@property (assign, nonatomic) NSTimeInterval scrollTime;
/**
 *  是否允许自动滑动
 */
@property (assign, nonatomic) BOOL isAllowAutoScroll;
/**
 *  PageControl的位置
 */
@property (assign, nonatomic) PageControlShowStyle pageControlShowStyle;
/**
 *  点击后的回调
 */
@property (copy, nonatomic) tapCallBackBlock callBackBlock;
/**
 *  创建一个新的HWScrollView
 *
 *  @param frame                frame
 *  @param imageURLArray        要展示的图片链接的数组
 *  @param placeHolder          未加载完成时的替代图片
 *  @param pageControlShowStyle PageControl的显示位置
 *
 *  @return HWScrollView
 */
+ (instancetype)scrollViewWithFrame:(CGRect)frame imageURLArray:(NSArray *)imageURLArray placeHolderImage:(NSString *)placeHolder pageControlShowStyle:(PageControlShowStyle)pageControlShowStyle;

@end
