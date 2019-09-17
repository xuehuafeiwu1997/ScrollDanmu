//
//  BulletManager.m
//  CommentDemo
//
//  Created by 许明洋 on 2019/9/17.
//  Copyright © 2019 许明洋. All rights reserved.
//

#import "BulletManager.h"
#import "BulletView.h"
@interface BulletManager()

//弹幕来源
@property (nonatomic,strong) NSMutableArray *dataSource;
//弹幕使用中的数组变量
@property (nonatomic,strong) NSMutableArray *bulletComments;
//存储弹幕view的数组变量
@property (nonatomic,strong) NSMutableArray *bulletViews;
@end

@implementation BulletManager

#pragma mark - 添加数据 start 移除数据stop

- (void)stop {
    
}

- (void)start {
    //将临时存储的移除
    [self.bulletComments removeAllObjects];
    //从弹幕来源中取出数据
    [self.bulletComments addObjectsFromArray:self.dataSource];
    [self initBulletComment];
}

//初始化方法 初始化弹幕，随机分配弹幕轨迹
- (void)initBulletComment {
    
    NSMutableArray *trajectorys = [NSMutableArray arrayWithArray:@[@(0),@(1),@(2)]];
    for (int i =0; i < 3; i++) {
        
        if (self.bulletComments.count > 0) {
            //通过随机数来获取弹幕的轨迹
            NSInteger index = arc4random()%trajectorys.count;
            int trajectory = [[trajectorys objectAtIndex:index]intValue];
            //将取出过的删除掉
            [trajectorys removeObjectAtIndex:index];
            
            //从弹幕数组中逐一取出弹幕数据
            NSString *comment = [self.bulletComments firstObject];
            [self.bulletComments removeObjectAtIndex:0];
            
            //拿到弹幕数据之后要开始创建弹幕
            [self createBulletView:comment trajectory:trajectory];
        }
        
    }
}

- (void)createBulletView:(NSString *)comment trajectory:(int)trajectory {
    BulletView *view = [[BulletView alloc] initWithComment:comment];
    view.trajectory = trajectory;
    [self.bulletViews addObject:view];
    
    //实现block方法
    //出现警告的原因是我们在block里面调用变量的时候对其进行了修改
    __weak typeof(view) weakView = view;
    __weak typeof(self) weakself = self;
    view.moveStatusBlock = ^{
        //移出屏幕后销毁弹幕，并释放资源
        [weakView stopAniamtion];
        [weakself.bulletViews removeObject:weakView];
    };
    
    //下面需要将view传到viewController上面，所以需要有一个回调，
    if (self.generateViewBlock) {
        self.generateViewBlock(view);
    }
}

#pragma mark - 懒加载数组
- (NSMutableArray *)dataSource {
    if (_dataSource == nil) {
        _dataSource = [NSMutableArray arrayWithArray:@[@"弹幕1～～～～～～～",
                                                       @"这是弹幕2~~~~~~~~~~",
                                                       @"我是弹幕3~~~~~~~~~~~~"]];
    }
    return _dataSource;
}

- (NSMutableArray *)bulletComments {
    if (_bulletComments == nil) {
        _bulletComments = [NSMutableArray array];
    }
    return _bulletComments;
}

- (NSMutableArray *)bulletViews {
    if (_bulletViews == nil) {
        _bulletViews = [NSMutableArray array];
    }
    return _bulletViews;
}


@end
