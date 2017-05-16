//
//  GradientColor.m
//  CGContextObject
//

#import "GradientColor.h"

@implementation GradientColor

- (void)createColor {

    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();

    //////////////////////////////////////////////////////////
    
    size_t count        = 3;
    
    CGFloat locations[] = {0.0, 0.5, 1.0};
    
    CGFloat colorComponents[] = {
        //red, green, blue, alpha
        0.254, 0.599, 0.82,  1.0,
        0.192, 0.525, 0.75,  1.0,
        0.096, 0.415, 0.686, 1.0
    };
    
    //////////////////////////////////////////////////////////
    
    _gradientRef = CGGradientCreateWithColorComponents(colorSpace, colorComponents, locations, count);
    
    CGColorSpaceRelease(colorSpace);
}

+ (instancetype)createColorWithStartPoint:(CGPoint)startPoint endPoint:(CGPoint)endPoint {
    
    GradientColor *color = [[[self class] alloc] init];
    
    color.gradientStartPoint = startPoint;
    color.gradientEndPoint   = endPoint;
    
    [color createColor];
    
    return color;
}

- (void)dealloc {
    
    CGGradientRelease(_gradientRef);
    
}

@end
