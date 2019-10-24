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
#define PhotoHeight 30

@interface BulletView()

//定义一个label，用来显示弹幕
@property (nonatomic,strong) UILabel *lbComment;

//定义一个UIImageView,用来显示弹幕的头像
@property (nonatomic,strong) UIImageView *photoIgv;
@end

@implementation BulletView

//初始化弹幕的方法(认为弹幕为一个字符串)
- (instancetype)initWithComment:(NSString *)comment {
    if (self = [super init]) {
        self.backgroundColor = [UIColor redColor];
        //设置整个弹幕也为圆弧形，高度是30，半径为15
        self.layer.cornerRadius = 15;
        //计算弹幕的实际宽度
        NSDictionary *attr = @{NSFontAttributeName:[UIFont systemFontOfSize:18]};
        CGFloat width = [comment sizeWithAttributes:attr].width;
        
        self.bounds = CGRectMake(0, 0, width + 2 * Padding + PhotoHeight, 30);
        //给弹幕label赋值
        self.lbComment.text = comment;
        self.lbComment.frame = CGRectMake(Padding + PhotoHeight, 0, width, 30);
        
        self.photoIgv.frame = CGRectMake(-Padding, -Padding, PhotoHeight + Padding, PhotoHeight + Padding);
        //设置圆形
        self.photoIgv.layer.cornerRadius = (PhotoHeight + Padding) / 2;
        self.photoIgv.layer.borderColor = [UIColor redColor].CGColor;
        //宽度
        self.photoIgv.layer.borderWidth = 1;
        self.photoIgv.image = [UIImage imageNamed:@"5.jpg"];
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

- (UIImageView *)photoIgv {
    if (_photoIgv == nil) {
        _photoIgv = [[UIImageView alloc] init];
        _photoIgv.clipsToBounds = YES;
        _photoIgv.contentMode = UIViewContentModeScaleAspectFill;
        [self addSubview:_photoIgv];
    }
    return _photoIgv;
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
    
    /*弹幕开始*/
    if (self.moveStatusBlock) {
        self.moveStatusBlock(Start);
    }
    
    /*弹幕完全进入屏幕*/
    //根据t = s/v
    CGFloat speed = wholeWidth / duration;
    CGFloat enterDuration = CGRectGetWidth(self.bounds) / speed;
    
    [self performSelector:@selector(enterScreen) withObject:nil afterDelay:enterDuration];
    /*
     后面会添加一个暂停功能，而暂停的时候dispatch不会暂停，所以我们需要换个延时执行的方法
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(enterDuration * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if (self.moveStatusBlock) {
            self.moveStatusBlock(Enter);
        }
    });
    */
    
    //需要在下面的frame里面改变frame的x的坐标
    __block CGRect frame = self.frame;
    //UIViewAnimationOptionCurveLinear:表示动画的过程是均匀变化的，没有加速度
    [UIView animateWithDuration:duration delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
        frame.origin.x -= wholeWidth;
        self.frame =frame;
    } completion:^(BOOL finished) {
        //移动完成之后，需要将其从屏幕上移掉
        [self removeFromSuperview];
        
        //在这里做一个回调，就是获得当前弹幕的状态(弹幕状态结束的时候调用)
        if (self.moveStatusBlock) {
            self.moveStatusBlock(End);
        }
    }];
}

//完全进入屏幕时的执行方法
- (void)enterScreen {
    if (self.moveStatusBlock) {
        self.moveStatusBlock(Enter);
    }
}

//结束动画
- (void)stopAniamtion {
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
    //UIView上的动画说到底其实说到底也是layer上的动画
    [self.layer removeAllAnimations];
    [self removeFromSuperview];
}

@end
