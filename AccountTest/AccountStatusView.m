//
//  AccountStatusView.m
//  AccountTest
//
//  Created by MornChan on 16/7/19.
//  Copyright © 2016年 MornChan. All rights reserved.
//

#import "AccountStatusView.h"
#define MCLineWidth 2
#define padding 50
#define layerViewWH 10
#define bezierCenter layerViewWH * 0.25
#define circleRadius 6
#define animationDuration 2.0f


@class AccountStatusView;
@interface AccountStatusView ()<CAAnimationDelegate>

@property(strong,nonatomic) CAShapeLayer * commonLayer;
@property(strong,nonatomic) CAShapeLayer * errorLayer;
@property(strong,nonatomic) CAShapeLayer * loadingLayer;

@end

@implementation AccountStatusView


- (CAShapeLayer *)commonLayer
{
    if (_commonLayer == nil) {
        _commonLayer = [CAShapeLayer layer];
        _commonLayer.lineWidth = MCLineWidth;
        _commonLayer.strokeColor = [UIColor blueColor].CGColor;
        _commonLayer.fillColor = [UIColor clearColor].CGColor;
        _commonLayer.lineCap = kCALineCapRound;
        _commonLayer.lineJoin = kCALineJoinRound;
        [self.layer addSublayer:_commonLayer];
    }
    return _commonLayer;
}

- (CAShapeLayer *)errorLayer
{
    if (_errorLayer == nil) {
        _errorLayer = [CAShapeLayer layer];
        _errorLayer.lineWidth = MCLineWidth;
        _errorLayer.strokeColor = [UIColor blueColor].CGColor;
        _errorLayer.fillColor = [UIColor clearColor].CGColor;
        _errorLayer.lineCap = kCALineCapRound;
        _errorLayer.lineJoin = kCALineJoinRound;
        [self.layer addSublayer:_errorLayer];
    }
    return _errorLayer;
}

- (CAShapeLayer *)loadingLayer
{
    if (_loadingLayer == nil) {
        _loadingLayer = [CAShapeLayer layer];
        _loadingLayer.lineWidth = MCLineWidth;
        _loadingLayer.lineCap = kCALineCapRound;
        _loadingLayer.strokeColor = [UIColor blueColor].CGColor;
        _loadingLayer.strokeColor = [UIColor colorWithRed:87/255.0f green:192/255.0f blue:255/255.0f alpha:1].CGColor;
        _loadingLayer.fillColor = [UIColor clearColor].CGColor;
        [self.layer addSublayer:_loadingLayer];
        
    }
    return _loadingLayer;
}


- (void)showLoading
{
    [self setLayerNill];
    [self showLoadingFirst];
}

- (void)showSuccess
{
    [self setLayerNill];
    [self showLoading];
    [self showSuccessFirst];
}

- (void)showError
{
    [self setLayerNill];
    [self showLoading];
    [self showErrorFirst];
}

- (void)setLayerNill
{
    if (self.loadingLayer) {
        [self.loadingLayer removeFromSuperlayer];
        self.loadingLayer = nil;
    }
    if (self.errorLayer) {
        [self.errorLayer removeFromSuperlayer];
        self.errorLayer = nil;
    }
    if (self.commonLayer) {
        [self.commonLayer removeFromSuperlayer];
        self.commonLayer = nil;
    }
}

- (instancetype)init
{
    if (self == [super init]) {
        
        CGRect viewSize;
        viewSize.size.width = viewSize.size.height = layerViewWH;
        self.frame = viewSize;
        self.backgroundColor = [UIColor clearColor];
        
    }
    return self;
}


//LoadingAnimation
- (void)showLoadingFirst
{
    CABasicAnimation * AnimationFirst = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    AnimationFirst.fromValue = @(0.0);
    AnimationFirst.toValue = @(1.0);
    AnimationFirst.duration = animationDuration * 0.5;
    AnimationFirst.beginTime = 0.0f;
    AnimationFirst.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
    
    CABasicAnimation * AnimationSecond = [CABasicAnimation animationWithKeyPath:@"strokeStart"];
    AnimationSecond.fromValue = @(0.0);
    AnimationSecond.toValue = @(1.0);
    AnimationSecond.duration = animationDuration * 0.5;
    AnimationSecond.beginTime = animationDuration * 0.5;
    AnimationSecond.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    
    CAAnimationGroup * animationGroup = [CAAnimationGroup animation];
    animationGroup.duration = animationDuration;
    animationGroup.repeatCount = HUGE;
    animationGroup.fillMode = kCAFillModeForwards;
    animationGroup.animations = @[AnimationFirst,AnimationSecond];
    
    UIBezierPath * loadingBezier = [UIBezierPath bezierPathWithArcCenter:CGPointMake(bezierCenter, bezierCenter) radius:circleRadius startAngle: - M_PI_2 endAngle:- M_PI_2 + 2 * M_PI clockwise:YES];
    self.loadingLayer.path = loadingBezier.CGPath;
    [animationGroup setValue:@"loadingAnimation" forKey:@"Animation"];
    [self.loadingLayer addAnimation:animationGroup forKey:nil];
    
}

//SuccessAnimation
- (void)showSuccessFirst
{
    UIBezierPath * successBezier = [UIBezierPath bezierPathWithArcCenter:CGPointMake(bezierCenter, bezierCenter) radius:circleRadius startAngle: - M_PI_2 endAngle: -M_PI_2 + 1.5 * M_PI clockwise:YES];
    CAKeyframeAnimation * successAnimation = [CAKeyframeAnimation animationWithKeyPath:@"strokeEnd"];
    self.loadingLayer.path = successBezier.CGPath;
    successAnimation.delegate = self;
    successAnimation.values = @[@(0.0),@(1.0)];
    successAnimation.removedOnCompletion = NO;
    successAnimation.fillMode = kCAFillModeForwards;
    successAnimation.duration = animationDuration * 0.33;
    successAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    [successAnimation setValue:@"successAnimationFirst" forKey:@"Animation"];
    [self.loadingLayer addAnimation:successAnimation forKey:nil];
}

- (void)showSuccessSecond
{
    UIBezierPath * successBezier = [UIBezierPath bezierPath];
    //B
    [successBezier moveToPoint:CGPointMake(bezierCenter - circleRadius, bezierCenter)];
    //O
    [successBezier addLineToPoint:CGPointMake(bezierCenter, bezierCenter+ circleRadius * 0.5)];
    //A
    [successBezier addLineToPoint:CGPointMake(bezierCenter + circleRadius * 1.25 * atan(M_PI_4 * (65/90.0)),  bezierCenter - circleRadius * 0.75)];
    
    self.commonLayer.path = successBezier.CGPath;
    self.commonLayer.strokeColor = [UIColor colorWithRed:38/255.0f green:209/255.0f blue:106/255.0f alpha:1].CGColor;
    
    CAKeyframeAnimation * successAnimation = [CAKeyframeAnimation animationWithKeyPath:@"strokeEnd"];
    successAnimation.values = @[@(0.0),@(1.0)];
    successAnimation.duration = animationDuration * 0.33;
    successAnimation.removedOnCompletion = NO;
    successAnimation.fillMode = kCAFillModeForwards;
    successAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
    [successAnimation setValue:@"successAnimationSecond" forKey:@"Animation"];
    [self.commonLayer addAnimation:successAnimation forKey:nil];
}

//errorAnimation
- (void)showErrorFirst
{
    UIBezierPath * errorBezier = [UIBezierPath bezierPathWithArcCenter:CGPointMake(bezierCenter, bezierCenter)
                                                                radius:circleRadius
                                                            startAngle: - M_PI_2
                                                              endAngle: - M_PI_2 + M_PI_4 + 1.5 * M_PI
                                                             clockwise:YES];
    
    CAKeyframeAnimation * errorAnimationFirst = [CAKeyframeAnimation animationWithKeyPath:@"strokeEnd"];
    self.loadingLayer.path = errorBezier.CGPath;
    self.loadingLayer.strokeColor = [UIColor redColor].CGColor;
    
    errorAnimationFirst.delegate = self;
    errorAnimationFirst.values = @[@(0.0),@(1.0)];
    errorAnimationFirst.duration = animationDuration * 0.33;
    errorAnimationFirst.removedOnCompletion = NO;
    errorAnimationFirst.fillMode = kCAFillModeForwards;
    errorAnimationFirst.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    [errorAnimationFirst setValue:@"errorAnimationFirst" forKey:@"Animation"];
    [self.loadingLayer addAnimation:errorAnimationFirst forKey:nil];
}


- (void)showErrorSecond
{
    UIBezierPath * errorBezierFirst = [UIBezierPath bezierPath];
    UIBezierPath * errorBezierSecond = [UIBezierPath bezierPath];
    //A
    [errorBezierFirst moveToPoint:CGPointMake(bezierCenter - circleRadius * cos(M_PI_4), bezierCenter - circleRadius * sin(M_PI_4))];
    //D
    [errorBezierFirst addLineToPoint:CGPointMake(bezierCenter + circleRadius * cos(M_PI_4), bezierCenter + circleRadius * sin(M_PI_4))];
    //B
    [errorBezierSecond moveToPoint:CGPointMake(bezierCenter + circleRadius * cos(M_PI_4), bezierCenter -  circleRadius * sin(M_PI_4))];
    //C
    [errorBezierSecond addLineToPoint:CGPointMake(bezierCenter - circleRadius * cos(M_PI_4), bezierCenter + circleRadius * sin(M_PI_4))];
    
    self.commonLayer.path = errorBezierFirst.CGPath;
    self.errorLayer.path = errorBezierSecond.CGPath;
    self.commonLayer.strokeColor = [UIColor redColor].CGColor;
    self.errorLayer.strokeColor = [UIColor redColor].CGColor;
    
    CAKeyframeAnimation * errorAnimationSecond = [CAKeyframeAnimation animationWithKeyPath:@"strokeEnd"];
    errorAnimationSecond.values = @[@(0.0),@(1.0)];
    errorAnimationSecond.duration = animationDuration * 0.33;
    errorAnimationSecond.removedOnCompletion = NO;
    errorAnimationSecond.fillMode = kCAFillModeForwards;
    errorAnimationSecond.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    [self.commonLayer addAnimation:errorAnimationSecond forKey:nil];
    [self.errorLayer addAnimation:errorAnimationSecond forKey:nil];
}



//commonHiden
- (void)hideCircle
{
    CAKeyframeAnimation * loadingAnimation = [CAKeyframeAnimation animationWithKeyPath:@"strokeStart"];
    loadingAnimation.delegate = self;
    loadingAnimation.values = @[@(0.0),@(1.0)];
    loadingAnimation.removedOnCompletion = NO;
    loadingAnimation.fillMode = kCAFillModeForwards;
    loadingAnimation.duration = animationDuration * 0.33;
    loadingAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    [loadingAnimation setValue:@"hideLoadingAnimtion" forKey:@"Animation"];
    [self.loadingLayer addAnimation:loadingAnimation forKey:nil];
}


// delegate
- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag
{
    if ([[anim valueForKey:@"Animation"] isEqualToString:@"loadingAnimation"]) {
    }
    if ([[anim valueForKey:@"Animation"] isEqualToString:@"successAnimationFirst"]) {
        [self showSuccessSecond];
        [self hideCircle];
    }
    if ([[anim valueForKey:@"Animation"] isEqualToString:@"errorAnimationFirst"]) {
        [self hideCircle];
        [self showErrorSecond];
    }
    if ([[anim valueForKey:@"Animation"] isEqualToString:@"hideLoadingAnimtion"]) {
        
    }
    if ([[anim valueForKey:@"Animation"] isEqualToString:@"successAnimationSecond"]) {
        [self hideCircle];
        
    }
    
}

@end
