//
//  CXSTabBar.m
//  CXSMusicPlayer
//
//  Created by 陈新爽 on 2022/3/15.
//

#import "CXSTabBar.h"

@interface CXSTabBar ()

@end

@implementation CXSTabBar

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor whiteColor];
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];

    CGFloat width =self.frame.size.width;
    CGFloat height = 49;
    
    CGFloat buttonY = 0;
    //-1是因为有一个_UIBarBackground
    CGFloat buttonW = width / (self.subviews.count-1);
    CGFloat buttonH = height;
    NSInteger index = 0;
    for (UIControl *button in self.subviews) {
        // 计算按钮的x值
        if (![button isKindOfClass:[UIControl class]]) continue;
        CGFloat buttonX = buttonW * index;
        button.frame = CGRectMake(buttonX, buttonY, buttonW, buttonH);
        
        // 增加索引
        index++;

    }
}



@end
