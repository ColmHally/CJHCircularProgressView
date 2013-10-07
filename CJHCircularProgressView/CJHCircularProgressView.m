//
//  CJHCircularProgressView.m
//  CJHCircularProgressView
//
//  Created by Colm Hally on 06/10/2013.
//  Copyright (c) 2013 Colm Hally. All rights reserved.
//

#import "CJHCircularProgressView.h"

#import <QuartzCore/QuartzCore.h>
#import <math.h>

@interface CJHCircularProgressView ()

@property (nonatomic, assign) CGFloat prevProgress;

@property (nonatomic, assign) CAShapeLayer* circleLayer;
@property (nonatomic, assign) CAShapeLayer* imageMaskLayer;
@property (nonatomic, strong) UIImageView* insetImageView;

@end

@implementation CJHCircularProgressView

@dynamic insetImage;

- (id) initWithFrame: (CGRect)frame
{
    self = [super initWithFrame: frame];
    
    if (self) {
        _progress = 0.0f;
        _prevProgress = 0.0f;
        _angleOffset = -1 * M_PI_2;
        _radius = floor(MIN(self.bounds.size.width, self.bounds.size.height) / 2);
        _lineWidth = 3.0f;
        _lineColor = [UIColor whiteColor];
        
        self.backgroundColor = [UIColor clearColor];
        
        self.insetImageView = [[UIImageView alloc] initWithFrame: CGRectMake((self.bounds.size.width / 2) - self.radius,
                                                                             (self.bounds.size.height / 2) - self.radius,
                                                                             self.radius * 2,
                                                                             self.radius * 2)];
        self.insetImageView.clipsToBounds = YES;
        
        self.insetImageView.contentMode = UIViewContentModeScaleAspectFill; //! TODO: Investigate what happens for a landscape photo
        
        [self addSubview: self.insetImageView];
    }
    
    return self;
}

#pragma mark -
#pragma mark Data Accessors

- (void) setProgress: (CGFloat) progress
{
    NSAssert(progress >= 0.0f && progress <= 1.0f, @"Progress must be a float between 0.0 and 1.0");
    
    self.prevProgress = _progress;
    
    _progress = progress;
    
    [self updateProgress];
    
    if (self.progress == 1.0
        && self.delegate
        && [self.delegate respondsToSelector: @selector(progressViewDidGoToCompletion:)])
    {
        [self.delegate progressViewDidGoToCompletion: self];
    }
}

- (void) setRadius: (CGFloat)radius
{
    _radius = radius;
    
    self.insetImageView.frame = CGRectMake((self.bounds.size.width / 2) - self.radius,
                                           (self.bounds.size.height / 2) - self.radius,
                                           self.radius * 2,
                                           self.radius * 2);
    
    [self.imageMaskLayer removeFromSuperlayer];
    self.imageMaskLayer = nil;
    [self createInsetImageMask];
    
    [self.circleLayer removeFromSuperlayer];
    self.circleLayer = nil;
    
    [self updateProgress];
}

- (void) setAngleOffset: (CGFloat)angleOffset
{
    _angleOffset = angleOffset;
    
    [self updateProgress];
}

- (void) setLineWidth: (CGFloat)lineWidth
{
    _lineWidth = lineWidth;
    
    [self updateProgress];
}

- (void) setLineColor: (UIColor *) lineColor
{
    _lineColor = lineColor;
    
    [self updateProgress];
}

- (void) setInsetImage: (UIImage *)insetImage
{
    self.insetImageView.image = insetImage;
    
    [self.insetImageView setNeedsDisplay];
    
    if (!self.imageMaskLayer) {
        [self createInsetImageMask];
    }
}

- (UIImage *) insetImage {
    return self.insetImageView.image;
}

#pragma mark -
#pragma mark Updating Animations

- (void) updateProgress
{
    if (!self.circleLayer) {
        self.circleLayer = [self createCircleLayer];
        
        [self.layer addSublayer: self.circleLayer];
    }
    
    [CATransaction begin];
    
    [CATransaction setAnimationDuration: 0.25f];
    
    self.circleLayer.strokeEnd = self.progress;
    self.circleLayer.lineWidth = self.lineWidth;
    self.circleLayer.strokeColor = [self.lineColor CGColor];
    
    [CATransaction commit];
}

- (void) createInsetImageMask
{
    CAShapeLayer *circleShapeMask = [CAShapeLayer layer];
    
    circleShapeMask.actions = [[NSDictionary alloc] initWithObjectsAndKeys:[NSNull null], @"path", nil];
    circleShapeMask.fillColor = [[UIColor blackColor] CGColor];
    circleShapeMask.fillRule = kCAFillRuleEvenOdd;
    circleShapeMask.frame = self.insetImageView.bounds;
    
    [self.insetImageView.layer addSublayer: circleShapeMask];
    
    CGMutablePathRef circleRegionPath = CGPathCreateMutable();
    CGPathAddRect(circleRegionPath, NULL, self.insetImageView.bounds);
    CGPathAddEllipseInRect(circleRegionPath, NULL, CGRectMake(self.insetImageView.bounds.origin.x,
                                                              self.insetImageView.bounds.origin.y,
                                                              self.insetImageView.frame.size.width,
                                                              self.insetImageView.frame.size.height));
    
    circleShapeMask.path = circleRegionPath;
    
    CGPathRelease(circleRegionPath);
    
    self.imageMaskLayer = circleShapeMask;
}

#pragma mark -
#pragma mark Layer Interactions

- (CAShapeLayer*) createCircleLayer
{
    CAShapeLayer *circle = [CAShapeLayer layer];
    
    circle.path = [[UIBezierPath bezierPathWithArcCenter: CGPointMake(self.bounds.size.width / 2, self.bounds.size.height / 2)
                                                  radius: self.radius - (self.lineWidth / 2)
                                              startAngle: self.angleOffset
                                                endAngle: (2 * M_PI) + self.angleOffset
                                               clockwise: YES] CGPath];
    
    circle.fillColor = [[UIColor clearColor] CGColor];
    circle.strokeColor = [self.lineColor CGColor];
    circle.lineWidth = self.lineWidth;
    
    return circle;
}

@end
