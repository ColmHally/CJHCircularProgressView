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
@property (nonatomic, assign) CALayer* imageLayer;
@property (nonatomic, assign) CALayer* maskLayer;
@property (nonatomic, strong) UIImage* imageStore;

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
        
        self.imageLayer = [CALayer layer];
        self.imageLayer.frame = [self imageLayerFrame];
        [self.layer addSublayer: self.imageLayer];
        
        self.maskLayer = [CALayer layer];
        self.maskLayer.frame = self.imageLayer.frame;
        self.imageLayer.mask = self.maskLayer;
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
    
    [self.circleLayer removeFromSuperlayer];
    [self updateProgress];
    
    self.insetImage = self.imageStore;
    [self setNeedsDisplay];
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
    CGImageRef image = [insetImage CGImage];
    
    CGImageRef clippedImage = CGImageCreateWithImageInRect(image, self.imageLayer.bounds);
    
    _imageStore = insetImage;
    
    self.imageLayer.contents = (__bridge id)clippedImage;
}

#pragma mark -
#pragma mark Updating Animations

- (void) updateProgress
{
    [CATransaction begin];
    
    [CATransaction setAnimationDuration: 0.25f];
    
    self.circleLayer.strokeEnd = self.progress;
    self.circleLayer.lineWidth = self.lineWidth;
    self.circleLayer.strokeColor = [self.lineColor CGColor];
    
    [CATransaction commit];
}

- (void) layoutSubviews
{
    [super layoutSubviews];
    
    [self createCircleLayer];
    
    UIGraphicsBeginImageContextWithOptions(self.imageLayer.bounds.size, NO, [[UIScreen mainScreen] scale]);
    
    [[self circlePath] fill];
    [self.maskLayer setContents: (id)[UIGraphicsGetImageFromCurrentImageContext() CGImage]];
    
    UIGraphicsEndImageContext();
}

- (UIBezierPath*) circlePath
{
    return [UIBezierPath bezierPathWithArcCenter: CGPointMake(self.bounds.size.width / 2, self.bounds.size.height / 2)
                                    radius: self.radius - (self.lineWidth / 2)
                                startAngle: self.angleOffset
                                  endAngle: (2 * M_PI) + self.angleOffset
                                 clockwise: YES];
}

- (CGRect) imageLayerFrame
{
    return CGRectMake((self.bounds.size.width / 2) - self.radius,
                      (self.bounds.size.height / 2) - self.radius,
                      self.radius * 2,
                      self.radius * 2);
}

#pragma mark -
#pragma mark Layer Interactions

- (void) createCircleLayer
{
    CAShapeLayer *circle = [CAShapeLayer layer];
    
    circle.path = [[self circlePath] CGPath];
    
    circle.fillColor = [[UIColor clearColor] CGColor];
    circle.strokeColor = [self.lineColor CGColor];
    circle.lineWidth = self.lineWidth;
    circle.strokeEnd = 0.0f;
    
    self.circleLayer = circle;
    
    [self.layer addSublayer: self.circleLayer];
}

@end
