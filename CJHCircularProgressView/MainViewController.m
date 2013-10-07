//
//  ViewController.m
//  CJHCircularProgressView
//
//  Created by Colm Hally on 06/10/2013.
//  Copyright (c) 2013 Colm Hally. All rights reserved.
//

#import "MainViewController.h"

#import "CJHCircularProgressView.h"

static const CGFloat progressContainerWidth = 75.0f;
static const CGFloat progressContainerHeight = 75.0f;

@interface MainViewController () <CJHCircularProgressViewDelegate>

@property (nonatomic, strong) CJHCircularProgressView* progressView;

@end

@implementation MainViewController

+ (instancetype) shared
{
    static MainViewController* sharedInstance = nil;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        sharedInstance = [[MainViewController alloc] init];
    });
    
    return sharedInstance;
}

- (id) init
{
    if (self = [super init]) {
        self.view.backgroundColor = [UIColor whiteColor];
        
        CGRect screenBounds = [[UIScreen mainScreen] bounds];
        
        self.progressView = [[CJHCircularProgressView alloc] initWithFrame: CGRectMake((screenBounds.size.width - progressContainerWidth) / 2,
                                                                                       (screenBounds.size.height - progressContainerHeight) / 2,
                                                                                       progressContainerWidth,
                                                                                       progressContainerHeight)];
        
//        self.progressView.radius = self.progressView.radius - 7.5;
        self.progressView.delegate = self;
        self.progressView.lineColor = [UIColor grayColor];
        
        [self.view addSubview: self.progressView];
        
        [self performSelector: @selector(testUpdate1)
                   withObject: self
                   afterDelay: 1.0f];
        
        [self performSelector: @selector(testUpdate2)
                   withObject: self
                   afterDelay: 1.3f];
        
        [self performSelector: @selector(testUpdate3)
                   withObject: self
                   afterDelay: 1.7f];
        
        [self performSelector: @selector(testUpdate4)
                   withObject: self
                   afterDelay: 2.5f];
        
        [self performSelector: @selector(testUpdate5)
                   withObject: self
                   afterDelay: 2.7f];
        
        [self performSelector: @selector(testUpdate6)
                   withObject: self
                   afterDelay: 3.2f];
        
    }
    
    return self;
}

- (void) willRotateToInterfaceOrientation: (UIInterfaceOrientation) toInterfaceOrientation
                                 duration: (NSTimeInterval) duration
{
    CGRect screenBounds = [[UIScreen mainScreen] bounds];
    CGRect currentFrame = self.progressView.frame;
    
    if (UIInterfaceOrientationIsPortrait(toInterfaceOrientation)) {
        self.progressView.frame = CGRectMake((screenBounds.size.width - currentFrame.size.width) / 2,
                                             (screenBounds.size.height - currentFrame.size.height) / 2,
                                             CGRectGetWidth(currentFrame),
                                             CGRectGetHeight(currentFrame));
    
    } else {
        self.progressView.frame = CGRectMake((screenBounds.size.height - currentFrame.size.width) / 2,
                                             (screenBounds.size.width - currentFrame.size.height) / 2,
                                             CGRectGetWidth(currentFrame),
                                             CGRectGetHeight(currentFrame));
        
    }
}

- (void) viewDidLoad
{
    [super viewDidLoad];
}

- (void) didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void) testUpdate1
{
    [self.progressView setProgress: 0.05];
}

- (void) testUpdate2
{
    [self.progressView setProgress: 0.15];
    
    self.progressView.lineColor = [UIColor lightGrayColor];
}

- (void) testUpdate3
{
    self.progressView.insetImage = [UIImage imageNamed: @"test"];
    [self.progressView setProgress: 0.30];
}

- (void) testUpdate4
{
    [self.progressView setProgress: 0.50];
    self.progressView.radius = self.progressView.radius - 7.5;
}

- (void) testUpdate5
{
    self.progressView.insetImage = [UIImage imageNamed: @"test2"];
    [self.progressView setProgress: 0.95];
}

- (void) testUpdate6
{
    [self.progressView setProgress: 1.0];
}

#pragma mark -
#pragma mark CJHProgressViewDelegate

- (void) progressViewDidGoToCompletion: (CJHCircularProgressView *)view
{
    DbgLog(@"Progress View Completed!");
}


@end
