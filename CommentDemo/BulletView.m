//
//  BulletView.m
//  CommentDemo
//
//  Created by 许明洋 on 2019/9/17.
//  Copyright © 2019 许明洋. All rights reserved.
//

#import "BulletView.h"

//padding就是间距
#define Padding 10

@interface BulletView()

//定义一个label，用来显示弹幕
@property (nonatomic,strong) UILabel *lbComment;

@end

@implementation BulletView

//初始化弹幕的方法(认为弹幕为一个字符串)
- (instancetype)initWithComment:(NSString *)comment {
    if (self = [super init]) {
        self.backgroundColor = [UIColor redColor];
        
        //计算弹幕的实际宽度
        NSDictionary *attr = @{NSFontAttributeName:[UIFont systemFontOfSize:18]};
        CGFloat width = [comment sizeWithAttributes:attr].width;
        
        self.bounds = CGRectMake(0, 0, width + 2 * Padding, 30);
        //给弹幕label赋值
        self.lbComment.text = comment;
        self.lbComment.frame = CGRectMake(Padding, 0, width, 30);
    }
    return self;
}

- (UILabel *)lbComment {
    if (_lbComment == nil) {
        _lbComment = [[UILabel alloc] init];
        _lbComment.font = [UIFont systemFontOfSize:18];
        _lbComment.textColor = [UIColor whiteColor];
        _lbComment.textAlignment = NSTextAlignmentCenter;
        [self addSubview:_lbComment];
    }
    return _lbComment;
}

//开始动画
- (void)startAnimation {
    
    //根据弹幕长度执行动画效果
    //根据 v=s/t,时间相同的情况下，速度就越快
    
    //计算屏幕的宽度
    CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
    CGFloat duration = 4.0f;
    //计算总的宽度（弹幕所在的UIView的宽度加上屏幕的宽度）
    CGFloat wholeWidth = screenWidth + CGRectGetWidth(self.bounds);
    
    //需要在下面的frame里面改变frame的x的坐标
    __block CGRect frame = self.frame;
    //UIViewAnimationOptionCurveLinear:表示动画的过程是均匀变化的，没有加速度
    [UIView animateWithDuration:duration delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
        frame.origin.x -= wholeWidth;
        self.frame =frame;
    } completion:^(BOOL finished) {
        //移动完成之后，需要将其从屏幕上移掉
        [self removeFromSuperview];
        
        //在这里做一个回调，就是获得当前弹幕的状态
        if (self.moveStatusBlock) {
            self.moveStatusBlock();
        }
    }];
}

//结束动画
- (void)stopAniamtion {
    
    //UIView上的动画说到底其实说到底也是layer上的动画
    [self.layer removeAllAnimations];
    [self removeFromSuperview];
}

@end
