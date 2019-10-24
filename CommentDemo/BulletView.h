//
//  BulletView.h
//  CommentDemo
//
//  Created by 许明洋 on 2019/9/17.
//  Copyright © 2019 许明洋. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger,MoveStatus) {
    Start,//创建弹幕view开始的时间
    Enter,//弹幕view完全进入屏幕
    End//弹幕view完全飞出屏幕
};

NS_ASSUME_NONNULL_BEGIN

@interface BulletView : UIView

//弹道
@property (nonatomic,assign) int trajectory;

//弹幕状态回调
@property (nonatomic,copy) void(^moveStatusBlock)(MoveStatus status);

//初始化弹幕的方法(认为弹幕为一个字符串)
- (instancetype)initWithComment:(NSString *)comment;

//开始动画
- (void)startAnimation;

//结束动画
- (void)stopAniamtion;
@end

NS_ASSUME_NONNULL_END
