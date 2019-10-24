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

@property (nonatomic,assign) BOOL bStopAnimation;
@end

@implementation BulletManager

#pragma mark - 添加数据 start 移除数据stop

- (instancetype)init {
    self = [super init];
    if (self) {
        self.bStopAnimation = YES;
    }
    return self;
}

- (void)stop {
    if (self.bStopAnimation) {
        return;
    }
    self.bStopAnimation = YES;
    [self.bulletViews enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        BulletView *view = obj;
        [view stopAniamtion];
        view = nil;
    }];
    [self.bulletViews removeAllObjects];
}

- (void)start {
    
    if (!self.bStopAnimation) {
        return;
    }
    self.bStopAnimation = NO;
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
    
    if (self.bStopAnimation) {
        return;
    }
    BulletView *view = [[BulletView alloc] initWithComment:comment];
    view.trajectory = trajectory;
    [self.bulletViews addObject:view];
    
    //实现block方法
    //出现警告的原因是我们在block里面调用变量的时候对其进行了修改
    __weak typeof(view) weakView = view;
    __weak typeof(self) weakself = self;
    view.moveStatusBlock = ^(MoveStatus status){
        
        if (self.bStopAnimation) {
            return;
        }
        
        switch (status) {
            case Start: {
                //弹幕开始进入屏幕，将View加入弹幕管理的变量中去bulletViews
                [weakself.bulletViews addObject:weakView];
                break;
            }
            case Enter: {
                //弹幕完全进入屏幕，判断是否还有其他内容，如果有，则在该弹幕轨迹中创建一个弹幕
                NSString *comment = [weakself nextComment];
                if (comment) {
                    [weakself createBulletView:comment trajectory:trajectory];
                }
                break;
            }
            case End: {
                //弹幕完全飞出屏幕后，从bulletViews中删除，释放资源
                if ([weakself.bulletViews containsObject:weakView]) {
                    //删除之前要先停止动画
                    [weakView stopAniamtion];
                    [weakself.bulletViews removeObject:weakView];
                }
                
                //接下来要实现循环的功能
                if (weakself.bulletViews.count == 0) {
                    //说明屏幕上已经没有弹幕了，开始循环滚动
                    self.bStopAnimation = YES;
                    [weakself start];
                }
                break;
            }
            default:
                break;
        }
        
//        //移出屏幕后销毁弹幕，并释放资源
//        [weakView stopAniamtion];
//        [weakself.bulletViews removeObject:weakView];
    };
    
    //下面需要将view传到viewController上面，所以需要有一个回调，
    if (self.generateViewBlock) {
        self.generateViewBlock(view);
    }
}

//从数据源中取下一条弹幕
- (NSString *)nextComment {
    if (self.bulletComments.count == 0) {
        return nil;
    }
    NSString *comment = [self.bulletComments firstObject];
    if (comment) {
        [self.bulletComments removeObjectAtIndex:0];
        /*这样写有问题，会把所有的字符串是comment的都删除掉
        [self.bulletComments removeObject:comment];
         */
    }
    return comment;
}

#pragma mark - 懒加载数组
- (NSMutableArray *)dataSource {
    if (_dataSource == nil) {
        _dataSource = [NSMutableArray arrayWithArray:@[@"弹幕1～～～～～～～",
                                                       @"这是弹幕2~~~~~~~~~~",
                                                       @"我是弹幕3~~~~~~~~~~~~",
                                                       @"今天天气是真的》〉》〉》〉》〉》",
                                                       @"白毛浮绿水，红掌拨清波",
                                                       @"你是我的眼，带我领略四季的变化",
                                                       @"轰轰烈烈把握青春年华",
                                                       @"1111111111111111111111111111111"]];
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
