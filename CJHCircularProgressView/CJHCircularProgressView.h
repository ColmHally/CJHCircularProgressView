//
//  CJHCircularProgressView.h
//  CJHCircularProgressView
//
//  Created by Colm Hally on 06/10/2013.
//  Copyright (c) 2013 Colm Hally. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CJHCircularProgressViewDelegate;

@interface CJHCircularProgressView : UIView

@property (nonatomic, assign) CGFloat progress;
@property (nonatomic, assign) CGFloat radius;
@property (nonatomic, assign) CGFloat angleOffset;
@property (nonatomic, assign) CGFloat lineWidth;
@property (nonatomic, strong) UIColor* lineColor;
@property (nonatomic, assign) UIImage* insetImage;

@property (nonatomic, strong) id <CJHCircularProgressViewDelegate> delegate;

@end

@protocol CJHCircularProgressViewDelegate <NSObject>

@optional

- (void) progressViewDidGoToCompletion: (CJHCircularProgressView*) view;

@end
