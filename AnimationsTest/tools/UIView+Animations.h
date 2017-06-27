//
//  UIView+Animations.h
//  AnimationsTest
//
//  Created by JianF.Sun on 17/6/26.
//  Copyright © 2017年 sjf. All rights reserved.
//
/*
 
 */
#import <UIKit/UIKit.h>


typedef void(^CompletionBlock)(void);

extern BOOL isIn;
extern BOOL isAnimating;

@interface UIView (Animations)<CAAnimationDelegate>

@property(nonatomic,assign) CGFloat animationTime;

@property(nonatomic,strong) CompletionBlock finishedIn;
@property(nonatomic,strong) CompletionBlock finishedOut;



/*
 *
 *move
 *
 */
-(void)showInView_Moved:(UIView*)contentView startCenter:(CGPoint) startCenter endCenter:(CGPoint) endCenter;
-(void)removeFromSuperView_MovedWithEndCenter:(CGPoint)endCenter;



/*
 *
 *scale
 *
 */
-(void)showInView_Scale:(UIView*)contentView;
-(void)removeFromSuperView_Scale;


/*
 *
 *curve 通过更改startcenter 和endcenter 可以进行贝赛尔曲线动画。当两者的y或者x相同时也可以实现直线滑入
 *
 */

-(void)showInView_curve:(UIView*)contentView startCenter:(CGPoint) startCenter endCenter:(CGPoint) endCenter;

-(void)removeFromSuperView_curveWithStartCenter:(CGPoint) startCenter endCenter:(CGPoint) endCenter;



/*
 type的值	解读	对应常量
 fade 	淡入淡出 	kCATransitionFade
 push 	推挤 	kCATransitionPush
 reveal 	揭开 	kCATransitionReveal
 moveIn 	覆盖 	kCATransitionMoveIn
 cube 	立方体 	私有API
 suckEffect 	吮吸 	私有API
 oglFlip 	翻转 	私有API
 rippleEffect 	波纹 	私有API
 pageCurl 	反翻页 	私有API
 cameraIrisHollowOpen 	开镜头 	私有API
 cameraIrisHollowClose 	关镜头 	私有API

 animation.subtype = kCATransitionFromLeft;
 animation.subtype = kCATransitionFromBottom;
 animation.subtype = kCATransitionFromRight;
 animation.subtype = kCATransitionFromTop;

 */

/*
 *适用于转场（亲测不好用，有点突兀）
 *这个动画进入时加在self 的superview上的
 *
 */
-(void)showInview_Animation:(UIView*)contentView type:(NSString*)type subType:(NSString*)subType;
-(void)removeFromSuperView_AnimationWithType:(NSString*)type subType:(NSString*)subType;


/*
 *
 *抖动
 *
 */

-(void)shake;



@end
