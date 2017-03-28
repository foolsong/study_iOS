//  ************************************************************************
//
//  LineDemoView.m
//  DomeLineView
//
//  Created by 宋永建 on 17/3/28.
//  Copyright © 2017年 宋永建. All rights reserved.
//
//  Main function:
//
//  Other specifications:
//
//  ************************************************************************

#import "LineDemoView.h"

@implementation LineDemoView{
    CAShapeLayer *_graphLayer;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        [self setupGraphLayer];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
//    [self refreshGraphLayer];
}

- (void)drawRect:(CGRect)rect {
    // 1.获取上下文
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    // --------------------------实心圆
    // 2.画图
    CGContextAddEllipseInRect(ctx, CGRectMake(10, 10, 50, 50));
    [[UIColor greenColor] set];
    
    // 3.渲染
    CGContextFillPath(ctx);
}

- (void)setupGraphLayer{
    _graphLayer = [CAShapeLayer layer];
    [_graphLayer setBackgroundColor:[UIColor grayColor].CGColor];
    [_graphLayer setFrame:[self bounds]];
    [_graphLayer setGeometryFlipped:YES];
    [_graphLayer setStrokeColor:[[UIColor orangeColor] CGColor]];
    [_graphLayer setFillColor:nil];
    [_graphLayer setLineWidth:2.0f];
    [_graphLayer setLineJoin:kCALineJoinBevel];
    [[self layer] addSublayer:_graphLayer];
}

- (void)refreshGraphLayer{
    
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint:CGPointMake(0.0, 0.0)];
    NSUInteger numberOfPoints = 10;
    CGFloat xPosition = 0.0;
    CGFloat yMargin = 0.0;
    CGFloat yPosition = 0.0;
    
    [_graphLayer setStrokeColor:[[UIColor redColor] CGColor]];
    
//    CGPoint lastPoint = CGPointMake(0, 0);
    for(NSUInteger i = 0; i<numberOfPoints;i++){
        CGFloat value = arc4random_uniform(60);
        CGFloat minGridValue = 10;
        
        xPosition += 20;
        yPosition = value;//yMargin + floor((value-minGridValue) * 15);
        
        CGPoint newPosition = CGPointMake(xPosition, yPosition);
        [path addLineToPoint:newPosition];
        
        //        CALayer *circle = [self circleLayerForPointAtRow:i];
        //        CGPoint oldPosition = [circle.presentationLayer position];
        //        oldPosition.x = newPosition.x;
        //        [circle setPosition: newPosition];
        //        lastPoint = newPosition;
    }
    [path stroke];
}

//- (CALayer*)circleLayerForPointAtRow:(NSUInteger)row{
//    NSUInteger totalNumberOfCircles = [[_graphLayer sublayers] count];
//    if(row >=  totalNumberOfCircles){
//        CALayer *circleLayer = [self newCircleLayer];
//        [_graphLayer addSublayer:circleLayer];
//    }
//
//    return [_graphLayer sublayers][row];
//}

//- (CALayer*)newCircleLayer{
//    CALayer *newCircleLayer = [CALayer layer];
////    UIImage *img = [self circleImage];
//    [newCircleLayer setContents:(id)img.CGImage];
//    [newCircleLayer setFrame:CGRectMake(0, 0, img.size.width, img.size.height)];
//    [newCircleLayer setGeometryFlipped:YES];
//    return newCircleLayer;
//}

//- (UIImage*)circleImage{
//    if(!_circleImage){
//        CGSize imageSize = CGSizeMake(CIRCLE_SIZE, CIRCLE_SIZE);
//        CGFloat strokeWidth = 2;
//
//        UIGraphicsBeginImageContextWithOptions(imageSize, NO, 0.0);//[UIImage imageNamed:@"circle"];
//        CGContextRef context = UIGraphicsGetCurrentContext();
//
//        [[UIColor clearColor] setFill];
//        CGContextFillRect(context, (CGRect){CGPointZero, imageSize});
//
//        UIBezierPath* ovalPath = [UIBezierPath bezierPathWithOvalInRect: (CGRect){CGPointMake(strokeWidth/2.0, strokeWidth/2.0),
//            CGSizeMake(CIRCLE_SIZE-strokeWidth, CIRCLE_SIZE-strokeWidth)}];
//        CGContextSaveGState(context);
//        [[self.chartContainer elementFillColor] setFill];
//        [ovalPath fill];
//        CGContextRestoreGState(context);
//
//        [[self.chartContainer elementStrokeColor] setStroke];
//        [ovalPath setLineWidth:strokeWidth];
//        [ovalPath stroke];
//
//        _circleImage = UIGraphicsGetImageFromCurrentImageContext();
//        UIGraphicsEndImageContext();
//    }
//    return _circleImage;
//}


@end
