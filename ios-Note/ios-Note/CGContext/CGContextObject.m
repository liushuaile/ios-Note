//
//  CGContextObject.m
//  DrawRect


#import "CGContextObject.h"

@interface CGContextObject ()

@end

@implementation CGContextObject

- (void)dealloc {
    NSLog(@"CGContextObject dealloc %p",self);
}

- (instancetype)initWithCGContext:(CGContextRef)context {
    
    self = [super init];
    if (self) {
        
        self.context = context;
    }
    
    return self;
}

- (void)moveToStartPoint:(CGPoint)point {
    
    if (_context) {
        CGContextMoveToPoint(_context, point.x, point.y);
    }
}

- (void)addLineToPoint:(CGPoint)point {
    
    if (_context) {
        CGContextAddLineToPoint(_context, point.x, point.y);
    }
}

- (void)addCurveToPoint:(CGPoint)point controlPointOne:(CGPoint)pointOne controlPointTwo:(CGPoint)pointTwo {

    if (_context) {
        CGContextAddCurveToPoint(_context, pointOne.x, pointOne.y, pointTwo.x, pointTwo.y, point.x, point.y);
    }
}

- (void)addQuadCurveToPoint:(CGPoint)point controlPoint:(CGPoint)controlPoint {
    
    if (_context) {
        CGContextAddQuadCurveToPoint(_context, controlPoint.x, controlPoint.y, point.x, point.y);
    }
}

- (void)drawLinearGradientAtClipToRect:(CGRect)rect gradientColor:(GradientColor *)gradientColor {
    
    [self saveStateToStack];
    
    
    if (_context) {
        
        CGContextClipToRect(_context, rect);
        
        CGContextDrawLinearGradient(_context,
                                    gradientColor.gradientRef,
                                    gradientColor.gradientStartPoint,
                                    gradientColor.gradientEndPoint, kCGGradientDrawsBeforeStartLocation);
    }
    
    
    [self restoreStateFromStack];
}

- (void)addRect:(CGRect)rect {

    if (_context) {
        CGContextAddRect(_context, rect);
    }
}

- (void)addEllipseInRect:(CGRect)rect {
    
    if (_context) {
        CGContextAddEllipseInRect(_context, rect);
    }
}

- (void)drawString:(NSString *)string atPoint:(CGPoint)point withAttributes:(NSDictionary *)attributes {

    [string drawAtPoint:point withAttributes:attributes];
}

- (void)drawString:(NSString *)string inRect:(CGRect)rect withAttributes:(NSDictionary *)attributes {

    [string drawInRect:rect withAttributes:attributes];
}

- (void)drawAttributedString:(NSAttributedString *)string atPoint:(CGPoint)point {

    [string drawAtPoint:point];
}

- (void)drawAttributedString:(NSAttributedString *)string inRect:(CGRect)rect {

    [string drawInRect:rect];
}

- (void)beginPath {
    
    if (_context) {
        CGContextBeginPath(_context);
    }
}

- (void)closePath {

    if (_context) {
        CGContextClosePath(_context);
    }
}

- (void)strokePath {

    if (_context) {
        CGContextStrokePath(_context);
    }
}

- (void)fillPath {

    if (_context) {
        CGContextFillPath(_context);
    }
}

- (void)strokeAndFillPath {

    if (_context) {
        CGContextDrawPath(_context, kCGPathFillStroke);
    }
}

- (void)drawStrokeBlock:(CGContextObjectDrawBlock_t)block {

    [self beginPath];
    
    __weak CGContextObject *weakSelf = self;
    
    block(weakSelf);
    
    [self closePath];
    
    [self strokePath];
}

- (void)drawFillBlock:(CGContextObjectDrawBlock_t)block {
    
    [self beginPath];
    
    __weak CGContextObject *weakSelf = self;
    
    block(weakSelf);
    
    [self closePath];
    
    [self fillPath];
}

- (void)drawStrokeAndFillBlock:(CGContextObjectDrawBlock_t)block {

    [self beginPath];
    
    __weak CGContextObject *weakSelf = self;
    
    block(weakSelf);
    
    [self closePath];
    
    [self strokeAndFillPath];
}

- (void)drawStrokeBlock:(CGContextObjectDrawBlock_t)block closePath:(BOOL)closePath {

    [self beginPath];
    
    __weak CGContextObject *weakSelf = self;
    
    block(weakSelf);
    
    if (closePath) {
        [self closePath];
    }
    
    [self strokePath];
}

- (void)drawFillBlock:(CGContextObjectDrawBlock_t)block closePath:(BOOL)closePath {

    [self beginPath];
    
    __weak CGContextObject *weakSelf = self;
    
    block(weakSelf);
    
    if (closePath) {
        [self closePath];
    }
    
    [self fillPath];
}

- (void)drawStrokeAndFillBlock:(CGContextObjectDrawBlock_t)block closePath:(BOOL)closePath {

    [self beginPath];
    
    __weak CGContextObject *weakSelf = self;
    
    block(weakSelf);
    
    if (closePath) {
        [self closePath];
    }
    
    [self strokeAndFillPath];
}

- (void)drawImage:(UIImage *)image atPoint:(CGPoint)point {

    [image drawAtPoint:point];
}

- (void)drawImage:(UIImage *)image atPoint:(CGPoint)point blendMode:(CGBlendMode)blendMode alpha:(CGFloat)alpha {

    [image drawAtPoint:point blendMode:blendMode alpha:alpha];
}

- (void)drawImage:(UIImage *)image inRect:(CGRect)rect {

    [image drawInRect:rect];
}

- (void)drawImage:(UIImage *)image inRect:(CGRect)rect blendMode:(CGBlendMode)blendMode alpha:(CGFloat)alpha {

    [image drawInRect:rect blendMode:blendMode alpha:alpha];
}

- (void)drawImage:(UIImage *)image asPatternInRect:(CGRect)rect {

    [image drawAsPatternInRect:rect];
}

- (void)saveStateToStack {
    
    if (_context) {
        CGContextSaveGState(_context);
    }
}

- (void)restoreStateFromStack {
    
    if (_context) {
        CGContextRestoreGState(_context);
    }
}

#pragma mark - 重写setter,getter方法
//边线颜色
@synthesize strokeColor = _strokeColor;
- (void)setStrokeColor:(RGBColor *)strokeColor {

    if (_context) {
        
        _strokeColor = strokeColor;
        CGContextSetRGBStrokeColor(_context, strokeColor.red, strokeColor.green, strokeColor.blue, strokeColor.alpha);
    }
}
- (RGBColor *)strokeColor {

    return _strokeColor;
}

//填充颜色
@synthesize fillColor = _fillColor;
- (void)setFillColor:(RGBColor *)fillColor {
    
    if (_context) {
        
        _fillColor = fillColor;
        CGContextSetRGBFillColor(_context, fillColor.red, fillColor.green, fillColor.blue, fillColor.alpha);
    }
}
- (RGBColor *)fillColor {
    
    return _fillColor;
}

@synthesize lineWidth = _lineWidth;
- (void)setLineWidth:(CGFloat)lineWidth {
    
    if (_context) {
        
        _lineWidth = lineWidth;
        CGContextSetLineWidth(_context, lineWidth);
    }
}
- (CGFloat)lineWidth {
    
    return _lineWidth;
}

@synthesize lineCap = _lineCap;
- (void)setLineCap:(CGLineCap)lineCap {
    
    if (_context) {
    
        _lineCap = lineCap;
        CGContextSetLineCap(_context, lineCap);
    }
    
}
- (CGLineCap)lineCap {

    return _lineCap;
}

@end
