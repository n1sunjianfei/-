//
//  UIView+Animations.m
//  AnimationsTest
//
//  Created by JianF.Sun on 17/6/26.
//  Copyright © 2017年 sjf. All rights reserved.
//

#import "UIView+Animations.h"
#import <objc/runtime.h>

BOOL isIn = NO;
BOOL isAnimating = NO;

@implementation UIView (Animations)

#pragma mark - 添加animationTime，两个block属性

-(void)setAnimationTime:(CGFloat)animationTime{
    return objc_setAssociatedObject(self, @selector(animationTime),[NSNumber numberWithFloat:animationTime], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    
}

-(CGFloat)animationTime{
    
    NSNumber *timeValue = objc_getAssociatedObject(self, _cmd);
    return timeValue.floatValue==0?0.3:timeValue.floatValue;
}

-(void)setFinishedIn:(CompletionBlock)finishedIn{
    return objc_setAssociatedObject(self, @selector(finishedIn), finishedIn, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
-(CompletionBlock)finishedIn{
    return objc_getAssociatedObject(self, _cmd);
}

-(void)setFinishedOut:(CompletionBlock)finishedOut{
    return objc_setAssociatedObject(self, @selector(finishedOut), finishedOut, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
-(CompletionBlock)finishedOut{
    return objc_getAssociatedObject(self, _cmd);
}

#pragma mark - move 移入移除

-(void)showInView_Moved:(UIView*)contentView startCenter:(CGPoint) startCenter endCenter:(CGPoint) endCenter{
    if (!isAnimating) {
        isAnimating = YES;
        [self moveWithContentView:contentView startCenter:startCenter endCenter:endCenter type:1];
    }
    
}
-(void)removeFromSuperView_MovedWithEndCenter:(CGPoint)endCenter{
    CGPoint tmp;
    if (!isAnimating) {

        isAnimating = YES;
        [self moveWithContentView:nil startCenter:tmp endCenter:endCenter type:0];
    }
    
}

//1 进 0 出
-(void)moveWithContentView:(UIView*)contentView startCenter:(CGPoint) startCenter endCenter:(CGPoint)endCenter type:(int) type {

    //进
    if (type==1) {
        [contentView addSubview:self];
        self.center = startCenter;
    }
    [UIView animateWithDuration:self.animationTime animations:^{
        self.center = endCenter;
    } completion:^(BOOL finished) {
        
        //进
        if (type==1) {
            
            isAnimating = NO;
            [self shake];
            
            if (self.finishedIn) {
                self.finishedIn();
            }
        }
        
        //出
        if (type==0) {
            if (self.finishedOut) {
                [self removeFromSuperview];
                self.frame = self.bounds;
                self.finishedOut();
            }
        }

        isAnimating = NO;
    }];
}

#pragma mark - shake 抖动

-(void)shake{
    if (!isAnimating) {
        
        isAnimating = YES;
        
        [UIView animateWithDuration:0.1 animations:^{
            
            self.transform = CGAffineTransformMakeRotation(0.1);
            
           // self.transform = CGAffineTransformIdentity;
            
        } completion:^(BOOL finished) {
            
            
            [UIView animateWithDuration:0.1 animations:^{
                 self.transform = CGAffineTransformMakeRotation(-0.1);
                
            } completion:^(BOOL finished) {
                self.transform = CGAffineTransformIdentity;
                isAnimating = NO;

            }];
        }];
    }
}

#pragma mark - Scale 缩放

-(void)showInView_Scale:(UIView*)contentView{
    if (!isAnimating) {

        isAnimating = YES;
        self.transform = CGAffineTransformScale(self.transform, 0.1, 0.1);
        [contentView addSubview:self];
        
        [UIView animateWithDuration:self.animationTime animations:^{
            self.transform = CGAffineTransformIdentity;
        } completion:^(BOOL finished) {
            if (self.finishedIn) {
                self.finishedIn();
            }

            isAnimating = NO;
            [self shake];
        }];
    }
    
    
}

-(void)removeFromSuperView_Scale{
    
    if (!isAnimating) {
        
        isAnimating = YES;
        [UIView animateWithDuration:self.animationTime animations:^{
            self.transform = CGAffineTransformScale(self.transform, 0.1, 0.1);
        } completion:^(BOOL finished) {
            if (self.finishedOut) {
                [self removeFromSuperview];
                self.transform = CGAffineTransformIdentity;
                self.finishedOut();
            }

            isAnimating = NO;
            [self shake];
        }];
    }
    
}

#pragma mark - curve 贝塞尔曲线（起始点宽度或者高度一样时可以直线滑入）

-(void)showInView_curve:(UIView *)contentView startCenter:(CGPoint) startCenter endCenter:(CGPoint) endCenter{
    if (isAnimating) {
        return;
    }

    isAnimating = YES;
    [contentView addSubview:self];
    
    isIn = YES;
    [self animation_CurveWithStartCenter:startCenter endCenter:endCenter];
    
}
-(void)removeFromSuperView_curveWithStartCenter:(CGPoint) startCenter endCenter:(CGPoint) endCenter{
    if (isAnimating) {
        return;
    }

    isAnimating = YES;
    
    isIn = NO;
    [self animation_CurveWithStartCenter:startCenter endCenter:endCenter];
}
-(void)animation_CurveWithStartCenter:(CGPoint)startCenter endCenter:(CGPoint) endCenter{
    self.center = endCenter;
    // Drawing code
    // 初始化UIBezierPath
    UIBezierPath *path = [UIBezierPath bezierPath];
    
    // 首先设置一个中间二分点
    
    CGPoint centerpoint = CGPointMake((startCenter.x+endCenter.x)/2, (startCenter.y+endCenter.y)/2);
    // 以起始点为路径的起点
    [path moveToPoint:startCenter];
//    NSLog(@"%f %f ",startCenter.x,startCenter.y);
//    NSLog(@"%f %f ",centerpoint.x,centerpoint.y);
//    NSLog(@"%f %f ",endCenter.x,endCenter.y);
    // 设置抖动的点
    CGPoint shakepoint1 = CGPointMake(endCenter.x, endCenter.y-10);
    CGPoint shakepoint2 = CGPointMake(endCenter.x, endCenter.y+10);
    
    // 添加贝塞尔曲线
    
    [path addQuadCurveToPoint:centerpoint controlPoint:CGPointMake(startCenter.x, centerpoint.y)];
    
    if (isIn) {
        [path addQuadCurveToPoint:shakepoint1 controlPoint:CGPointMake(endCenter.x, centerpoint.y)];
        
        // 抖一抖
        [path addLineToPoint:shakepoint2];
        [path addLineToPoint:shakepoint1];
        [path addLineToPoint:endCenter];
    }else{
        [path addQuadCurveToPoint:endCenter controlPoint:CGPointMake(endCenter.x, centerpoint.y)];
    
    }
    
    // 设置线宽
    //    path.lineWidth = 3;
    // 设置线断面类型
    path.lineCapStyle = kCGLineCapRound;
    // 设置连接类型
    path.lineJoinStyle = kCGLineJoinRound;
    // 设置画笔颜色
    //    [[UIColor redColor] set];
    //    [path stroke];
    
    
    CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    // 设置动画的路径为心形路径
    animation.path = path.CGPath;
    // 动画时间间隔
    animation.delegate = self;
    animation.duration = self.animationTime;
    // 重复次数为最大值
    animation.repeatCount = 0;
    animation.removedOnCompletion = NO;
    animation.fillMode = kCAFillModeForwards;
    // 将动画添加到动画视图上
    [self.layer addAnimation:animation forKey:nil];
    
}
#pragma mark - CATransition（不好用呢）

-(void)showInview_Animation:(UIView*)contentView type:(NSString*)type subType:(NSString*)subType{
    
    if (!isAnimating) {

        isAnimating = YES;
        isIn = YES;
        [contentView addSubview:self];

        [self animationWithType:type subType:subType];

    }
}
-(void)removeFromSuperView_AnimationWithType:(NSString *)type subType:(NSString *)subType{
    if (!isAnimating) {

        isAnimating = YES;
        isIn = NO;
       [self animationWithType:type subType:subType];
    }
}
- (void)animationWithType:(NSString*)type subType:(NSString*)subtype{
    
    CATransition *animation = [CATransition animation];
    animation.delegate = self;
    animation.duration = self.animationTime;
    animation.timingFunction = UIViewAnimationCurveEaseInOut;
    animation.type = type;
    animation.subtype = subtype;
    
    [[self.superview layer] addAnimation:animation forKey:nil];
}

#pragma mark - animation delegate

-(void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag{
   
   
    [self.layer removeAllAnimations];
    
    
    
    if (isIn) {
        
        if (self.finishedIn) {
            self.finishedIn();
        }
        
    }else{
        if (self.finishedOut) {
            [self removeFromSuperview];
            self.finishedOut();
        }
    }

    isAnimating = NO;

   
}

@end
