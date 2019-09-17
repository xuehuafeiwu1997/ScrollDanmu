//
//  BulletManager.h
//  CommentDemo
//
//  Created by 许明洋 on 2019/9/17.
//  Copyright © 2019 许明洋. All rights reserved.
//

#import <Foundation/Foundation.h>
@class BulletView;
NS_ASSUME_NONNULL_BEGIN

@interface BulletManager : NSObject

@property (nonatomic,copy) void(^generateViewBlock)(BulletView *view);

//弹幕开始执行
- (void)start;

//弹幕停止执行
- (void)stop;

@end

NS_ASSUME_NONNULL_END
