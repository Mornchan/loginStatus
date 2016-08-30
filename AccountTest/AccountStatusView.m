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
@interface AccountStatusView ()

@property(strong,nonatomic) CAShapeLayer * commonLayer;
@property(strong,nonatomic) CAShapeLayer * errorLayer;
@property(strong,nonatomic) CAShapeLayer * circleLayer;
@property(strong,nonatomic) CAShapeLayer * loadingLayer;

@end

@implementation AccountStatusView


- (CAShapeLayer *)commonLayer
{
    if (_commonLayer == nil) {
        _commonLayer = [CAShapeLayer layer];
        _commonLayer.lineWidth = 2;
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
        _errorLayer.lineWidth = 2;
        _errorLayer.strokeColor = [UIColor blueColor].CGColor;
        _errorLayer.fillColor = [UIColor clearColor].CGColor;
        _errorLayer.lineCap = kCALineCapRound;
        _errorLayer.lineJoin = kCALineJoinRound;
        [self.layer addSublayer:_errorLayer];
    }
    return _errorLayer;
}

- (CAShapeLayer *)circleLayer
{
    if (_circleLayer == nil) {
        _circleLayer = [CAShapeLayer layer];
        _circleLayer.lineWidth = MCLineWidth;
        _circleLayer.lineCap = kCALineCapRound;
        _circleLayer.strokeColor = [UIColor blueColor].CGColor;
        _circleLayer.strokeColor = [UIColor colorWithRed:87/255.0f green:192/255.0f blue:255/255.0f alpha:1].CGColor;
        _circleLayer.fillColor = [UIColor clearColor].CGColor;
        [self.layer addSublayer:_circleLayer];

    }
    return _circleLayer;
}

- (CAShapeLayer *)loadingLayer
{
    if (_loadingLayer == nil) {
        _loadingLayer = [CAShapeLayer layer];
        _loadingLayer.lineWidth = 2;
        _loadingLayer.strokeColor = self.backgroundColor.CGColor;
        _loadingLayer.fillColor = [UIColor clearColor].CGColor;
        _loadingLayer.lineCap = kCALineCapRound;
        _loadingLayer.lineJoin = kCALineJoinRound;
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
    if (self.circleLayer) {
        [self.circleLayer removeFromSuperlayer];
        self.circleLayer = nil;
    }
    if (self.errorLayer) {
        [self.errorLayer removeFromSuperlayer];
        self.errorLayer = nil;
    }
    if (self.commonLayer) {
        [self.commonLayer removeFromSuperlayer];
        self.commonLayer = nil;
    }
    if (self.loadingLayer) {
        [self.loadingLayer removeFromSuperlayer];
        self.loadingLayer = nil;
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
    CABasicAnimation * circleAnimationFirst = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    circleAnimationFirst.fromValue = @(0.0);
    circleAnimationFirst.toValue = @(1.0);
    circleAnimationFirst.duration = animationDuration * 0.5;
    circleAnimationFirst.beginTime = 0.0f;
    circleAnimationFirst.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
    
    CABasicAnimation * circleAnimationSecond = [CABasicAnimation animationWithKeyPath:@"strokeStart"];
    circleAnimationSecond.fromValue = @(0.0);
    circleAnimationSecond.toValue = @(1.0);
    circleAnimationSecond.duration = animationDuration * 0.5;
    circleAnimationSecond.beginTime = animationDuration * 0.5;
    circleAnimationSecond.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];

    CAAnimationGroup * animationGroup = [CAAnimationGroup animation];
    animationGroup.duration = animationDuration;
    animationGroup.repeatCount = HUGE;
    animationGroup.fillMode = kCAFillModeForwards;
    animationGroup.animations = @[circleAnimationFirst,circleAnimationSecond];
    
    UIBezierPath * loadingBezier = [UIBezierPath bezierPathWithArcCenter:CGPointMake(bezierCenter, bezierCenter) radius:circleRadius startAngle:- M_PI_2 endAngle:- M_PI_2 + 2 * M_PI clockwise:YES];
    self.circleLayer.path = loadingBezier.CGPath;
    [animationGroup setValue:@"loadingAnimation" forKey:@"circleAnimation"];
    [self.circleLayer addAnimation:animationGroup forKey:@"cc"];
    
}

//SuccessAnimation
- (void)showSuccessFirst
{
    UIBezierPath * successBezier = [UIBezierPath bezierPathWithArcCenter:CGPointMake(bezierCenter, bezierCenter) radius:circleRadius startAngle:M_PI * 1.5 endAngle:M_PI * 3.0 clockwise:YES];
    CAKeyframeAnimation * successAnimation = [CAKeyframeAnimation animationWithKeyPath:@"strokeEnd"];
    self.circleLayer.path = successBezier.CGPath;
    successAnimation.delegate = self;
    successAnimation.values = @[@(0.0),@(1.0)];
    successAnimation.removedOnCompletion = NO;
    successAnimation.fillMode = kCAFillModeForwards;
    successAnimation.duration = animationDuration * 0.33;
    successAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    [successAnimation setValue:@"successAnimationFirst" forKey:@"circleAnimation"];
    [self.circleLayer addAnimation:successAnimation forKey:nil];
}

- (void)showSuccessSecond
{
    UIBezierPath * successBezier = [UIBezierPath bezierPath];
    //B
    [successBezier moveToPoint:CGPointMake(bezierCenter - circleRadius * acos(M_PI_2 * 0.333), bezierCenter)];
    //O
    [successBezier addLineToPoint:CGPointMake(bezierCenter, bezierCenter+ circleRadius * 0.5)];
    //A
    [successBezier addLineToPoint:CGPointMake(bezierCenter + circleRadius * cos(M_PI_4),  circleRadius * 0.25 - circleRadius * sin(M_PI_4 * 0.5) - 2)];
    self.commonLayer.path = successBezier.CGPath;
    self.commonLayer.strokeColor = [UIColor colorWithRed:38/255.0f green:209/255.0f blue:106/255.0f alpha:1].CGColor;
    
    CAKeyframeAnimation * successAnimation = [CAKeyframeAnimation animationWithKeyPath:@"strokeEnd"];
    successAnimation.values = @[@(0.0),@(1.0)];
    successAnimation.duration = animationDuration * 0.33;
    successAnimation.removedOnCompletion = NO;
    successAnimation.fillMode = kCAFillModeForwards;
    successAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
    [successAnimation setValue:@"successAnimationSecond" forKey:@"circleAnimation"];
    [self.commonLayer addAnimation:successAnimation forKey:nil];
}

//errorAnimation
- (void)showErrorFirst
{
    UIBezierPath * errorBezier = [UIBezierPath bezierPathWithArcCenter:CGPointMake(bezierCenter, bezierCenter) radius:circleRadius startAngle:M_PI * 1.5 endAngle:M_PI * 3.5 - M_PI_4  clockwise:YES];
    
    CAKeyframeAnimation * errorAnimationFirst = [CAKeyframeAnimation animationWithKeyPath:@"strokeEnd"];
    self.circleLayer.path = errorBezier.CGPath;
    self.circleLayer.strokeColor = [UIColor redColor].CGColor;
    
    errorAnimationFirst.delegate = self;
    errorAnimationFirst.values = @[@(0.0),@(1.0)];
    errorAnimationFirst.duration = animationDuration * 0.33;
    errorAnimationFirst.removedOnCompletion = NO;
    errorAnimationFirst.fillMode = kCAFillModeBackwards;
    errorAnimationFirst.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    [errorAnimationFirst setValue:@"errorAnimationFirst" forKey:@"circleAnimation"];
    [self.circleLayer addAnimation:errorAnimationFirst forKey:nil];
    
}

- (void)showErrorSecond
{
    UIBezierPath * errorBezierFirst = [UIBezierPath bezierPath];
    [errorBezierFirst moveToPoint:CGPointMake(bezierCenter - circleRadius * cos(M_PI_4), bezierCenter - circleRadius * sin(M_PI_4))];
    [errorBezierFirst addLineToPoint:CGPointMake(bezierCenter + circleRadius * cos(M_PI_4), bezierCenter + circleRadius * sin(M_PI_4))];
    
    UIBezierPath * errorBezierSecond = [UIBezierPath bezierPath];
    [errorBezierSecond moveToPoint:CGPointMake(bezierCenter + circleRadius * cos(M_PI_4), bezierCenter -  circleRadius * sin(M_PI_4))];
    [errorBezierSecond addLineToPoint:CGPointMake(bezierCenter - circleRadius * cos(M_PI_4), bezierCenter + circleRadius * sin(M_PI_4))];
    
    self.commonLayer.path = errorBezierFirst.CGPath;
    self.errorLayer.path = errorBezierSecond.CGPath;
    self.commonLayer.strokeColor = [UIColor redColor].CGColor;
    self.errorLayer.strokeColor = [UIColor redColor].CGColor;
    
    CAKeyframeAnimation * errorAnimationFirst = [CAKeyframeAnimation animationWithKeyPath:@"strokeEnd"];
    errorAnimationFirst.values = @[@(0.0),@(1.0)];
    errorAnimationFirst.duration = animationDuration * 0.33;
    errorAnimationFirst.removedOnCompletion = NO;
    errorAnimationFirst.fillMode = kCAFillModeForwards;
    errorAnimationFirst.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    [self.commonLayer addAnimation:errorAnimationFirst forKey:nil];
    [self.errorLayer addAnimation:errorAnimationFirst forKey:nil];
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
    [loadingAnimation setValue:@"hideLoadingAnimtion" forKey:@"circleAnimation"];
    [self.circleLayer addAnimation:loadingAnimation forKey:nil];
}


// delegate
- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag
{
    if ([[anim valueForKey:@"circleAnimation"] isEqualToString:@"loadingAnimation"]) {
    }
    if ([[anim valueForKey:@"circleAnimation"] isEqualToString:@"successAnimationFirst"]) {
        [self showSuccessSecond];
        [self hideCircle];
    }
    if ([[anim valueForKey:@"circleAnimation"] isEqualToString:@"errorAnimationFirst"]) {
        [self hideCircle];
        [self showErrorSecond];
    }
    if ([[anim valueForKey:@"circleAnimation"] isEqualToString:@"hideLoadingAnimtion"]) {
        
    }
    if ([[anim valueForKey:@"circleAnimation"] isEqualToString:@"successAnimationSecond"]) {
        [self hideCircle];
        
    }
    
}

@end
