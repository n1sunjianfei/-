//
//  ViewController.m
//  AnimationsTest
//
//  Created by JianF.Sun on 17/6/26.
//  Copyright © 2017年 sjf. All rights reserved.
//

#import "ViewController.h"
#import "UIView+Animations.h"
@interface ViewController ()

@property (nonatomic,strong) UIView *testView;

@property(nonatomic,assign) BOOL isShow;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _isShow = NO;
    UIView *testView = [[UIView alloc]init];
    testView.frame = CGRectMake(0, 0, 280, 180);
    testView.backgroundColor = [UIColor grayColor];
    testView.layer.masksToBounds = YES;
    testView.layer.cornerRadius = 5;
    testView.animationTime = 0.5;
    
    
    __weak typeof(self) weakself=self;
    
    testView.finishedIn = ^(void){
        NSLog(@"移入");
        weakself.isShow = YES;
    };
    testView.finishedOut = ^(void){
        NSLog(@"移除");
        weakself.isShow = NO;
    };
    self.testView = testView;
}
- (IBAction)ScaleIn:(UIButton *)sender {
    
    CGFloat width = CGRectGetWidth(self.view.frame);
    CGFloat height = CGRectGetHeight(self.view.frame);
    self.testView.center = CGPointMake(width/2, height/2);
    
    if (!_isShow) {
        [self.testView showInView_Scale:self.view];
        
    }else{
        
        [self.testView removeFromSuperView_Scale];
    }
}
- (IBAction)animationTest:(UIButton *)sender {
    
    CGFloat width = CGRectGetWidth(self.view.frame);
    CGFloat height = CGRectGetHeight(self.view.frame);
    
    if (!_isShow) {
        //贝赛尔曲线滑入
//        [self.testView showInView_curve:self.view startCenter:CGPointMake(0, 0) endCenter:CGPointMake(width/2, height/2)];
        
        //直线滑入
        [self.testView showInView_curve:self.view startCenter:CGPointMake(width/2, 0) endCenter:CGPointMake(width/2, height/2)];
        
    }else{
        
//       [self.testView removeFromSuperView_curveWithStartCenter:self.testView.center endCenter:CGPointMake(width, height)];
        [self.testView removeFromSuperView_curveWithStartCenter:self.testView.center endCenter:CGPointMake(width/2, height)];
    }
}

- (IBAction)Clickin:(UIButton *)sender {
   
    CGFloat width = CGRectGetWidth(self.view.frame);
    CGFloat height = CGRectGetHeight(self.view.frame);
    
    if (!_isShow) {
        [self.testView showInView_Moved:self.view startCenter:CGPointMake(0,0) endCenter:CGPointMake(width/2, height/2)];
        
    }else{
        
        [self.testView removeFromSuperView_MovedWithEndCenter:CGPointMake(width, height)];
    }
    
}
- (IBAction)CATransitionTest:(UIButton *)sender {
    
    CGFloat width = CGRectGetWidth(self.view.frame);
    CGFloat height = CGRectGetHeight(self.view.frame);
    self.testView.center = CGPointMake(width/2, height/2);

    if (!_isShow) {
        [self.testView showInview_Animation:self.view type:kCATransitionMoveIn subType:nil];
        
    }else{
        
        [self.testView removeFromSuperView_AnimationWithType:@"rippleEffect" subType:nil];
        
    }
}
- (IBAction)shake:(UIButton *)sender {
    
    CGFloat width = CGRectGetWidth(self.view.frame);
    CGFloat height = CGRectGetHeight(self.view.frame);
    self.testView.center = CGPointMake(width/2, height/2);

    [self.view addSubview:self.testView];
    [self.testView shake];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
