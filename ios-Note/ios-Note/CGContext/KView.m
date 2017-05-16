//
//  KView.m
//  CGContextObject


#import "KView.h"
#import "CGContextObject.h"
#import "RedGradientColor.h"

@interface KView ()

@property (nonatomic, strong) CGContextObject  *contextObject;

@end

@implementation KView

- (instancetype)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

- (void)drawRect:(CGRect)rect {
    
    switch ([self.type integerValue]) {
        case 1:
            [self type_One];
            break;
        case 2:
            [self type_two];
            break;
        case 3:
            [self type_Three];
            break;
        case 4:
            [self type_Four];
            break;
        case 5:
            [self type_Five];
            break;
        default:
            break;
    }
}

#pragma mark - Custom Accessors
- (NSNumber *)type {
    if (!_type) {
        _type = @1;
    }
    return _type;
}

- (CGContextObject *)contextObject {
    if (!_contextObject) {
        _contextObject = [[CGContextObject alloc] initWithCGContext:UIGraphicsGetCurrentContext()];
    }
    return _contextObject;
}

- (void)type_One {

    CGFloat height = self.frame.size.height;
    
    // 获取操作句柄
//    _contextObject = [[CGContextObject alloc] initWithCGContext:UIGraphicsGetCurrentContext()];
    
    
    // 开始绘图
    for (int count = 0; count < 12; count++) {
        
        // 获取随机高度
        CGFloat lineHeight = arc4random() % (int)(height - 20);
        
        // 绘制矩形
        [self.contextObject drawFillBlock:^(CGContextObject *contextObject) {
            _contextObject.fillColor = [RGBColor randomColorWithAlpha:1];
            [_contextObject addRect:CGRectMake(count * 30, height - lineHeight, 15, lineHeight)];
            
        }];
        
        // 绘制文字
        [_contextObject drawString:[NSString stringWithFormat:@"%.f", lineHeight]
                           atPoint:CGPointMake(2 + count * 30, height - lineHeight - 12)
                    withAttributes:@{NSFontAttributeName            : [UIFont fontWithName:@"AppleSDGothicNeo-UltraLight" size:10.f],
                                     NSForegroundColorAttributeName : [UIColor grayColor]}];
#warning 不知道这个api有什么效果。
        // 绘制图片
        [_contextObject drawImage:[UIImage imageNamed:@"source"] inRect:CGRectMake(count * 30, height - lineHeight, 15, 15)];

    }
}

- (void)type_two {

    CGFloat height = self.frame.size.height;
    
//    _contextObject = [[CGContextObject alloc] initWithCGContext:UIGraphicsGetCurrentContext()];
    CGFloat offSetY = 90;
    
    // 绘制直线(Stroke)
    [self.contextObject drawStrokeBlock:^(CGContextObject *contextObject) {
        
        _contextObject.strokeColor = [RGBColor randomColorWithAlpha:1];
        _contextObject.lineWidth   = 2;
        [_contextObject moveToStartPoint:CGPointMake(10, 10+offSetY)];
        [_contextObject addLineToPoint:CGPointMake(height, height)];
    }];
    
    // 绘制矩形(Stroke)
    [_contextObject drawStrokeBlock:^(CGContextObject *contextObject) {
        
        _contextObject.strokeColor = [RGBColor randomColorWithAlpha:1];
        _contextObject.lineWidth   = 1.f;
        [_contextObject addRect:CGRectMake(0, 0+offSetY, 100, 100)];
    }];
    
    // 绘制椭圆(Stroke)
    [_contextObject drawStrokeBlock:^(CGContextObject *contextObject) {
        
        _contextObject.strokeColor = [RGBColor randomColorWithAlpha:1];
        _contextObject.lineWidth   = 1.f;
        _contextObject.fillColor   = [RGBColor randomColorWithAlpha:1];
        [_contextObject addEllipseInRect:CGRectMake(0, 0+offSetY, 100, 100)];
    }];
    
    // 绘制椭圆(Fill)
    [_contextObject drawFillBlock:^(CGContextObject *contextObject) {
        
        _contextObject.fillColor = [RGBColor randomColorWithAlpha:1];
        [_contextObject addEllipseInRect:CGRectMake(10, 10+offSetY, 30, 30)];
    }];
    
    // 绘制椭圆(Stroke + Fill)
    [_contextObject drawStrokeAndFillBlock:^(CGContextObject *contextObject) {
        
        _contextObject.fillColor   = [RGBColor randomColorWithAlpha:1];
        _contextObject.strokeColor = [RGBColor randomColorWithAlpha:1];
        _contextObject.lineWidth   = 4.f;
        [_contextObject addEllipseInRect:CGRectMake(70, 70+offSetY, 100, 100)];
    }];
    
    // 绘制文本
    [_contextObject drawString:@"绘制文本"
                       atPoint:CGPointZero
                withAttributes:@{NSFontAttributeName            : [UIFont fontWithName:@"AppleSDGothicNeo-UltraLight" size:24.0f],
                                 NSForegroundColorAttributeName : [RGBColor randomColor].color}];
}

- (void)type_Three {
        
    // 获取操作句柄
//    _contextObject = [[CGContextObject alloc] initWithCGContext:UIGraphicsGetCurrentContext()];
    
    // 绘制二次贝塞尔曲线
    [self.contextObject drawStrokeBlock:^(CGContextObject *contextObject) {
        
        _contextObject.strokeColor = [RGBColor randomColorWithAlpha:1];
        _contextObject.lineWidth   = 2;
        
        [_contextObject moveToStartPoint:CGPointMake(0, 100)];
        [_contextObject addCurveToPoint:CGPointMake(200, 100) controlPointOne:CGPointMake(50, 0) controlPointTwo:CGPointMake(150, 200)];
    } closePath:NO];
    
    
    // 绘制一次贝塞尔曲线
    [_contextObject drawStrokeBlock:^(CGContextObject *contextObject) {
        
        _contextObject.strokeColor = [RGBColor randomColorWithAlpha:1];
        _contextObject.lineWidth   = 1;
        
        [_contextObject moveToStartPoint:CGPointMake(100, 0)];
        [_contextObject addQuadCurveToPoint:CGPointMake(100, 200) controlPoint:CGPointMake(0, arc4random() % 200)];
    } closePath:NO];
    
    
    // 绘制图片
    [_contextObject drawImage:[UIImage imageNamed:@"source"] atPoint:CGPointZero];
}

- (void)type_Four {
    
    // 获取操作句柄
//    _contextObject = [[CGContextObject alloc] initWithCGContext:UIGraphicsGetCurrentContext()];
    
    // 绘制彩色矩形1
    GradientColor *color1 = [GradientColor createColorWithStartPoint:CGPointMake(100, 100) endPoint:CGPointMake(200, 200)];
    [self.contextObject drawLinearGradientAtClipToRect:CGRectMake(100, 100, 100, 100) gradientColor:color1];
    
    // 绘制彩色矩形2
    GradientColor *color2 = [RedGradientColor createColorWithStartPoint:CGPointMake(0, 0) endPoint:CGPointMake(0, 100)];
    [_contextObject drawLinearGradientAtClipToRect:CGRectMake(0, 0, 100, 100) gradientColor:color2];
}

- (void)type_Five {

    CGFloat height = self.frame.size.height;
    
    // 获取操作句柄
//    _contextObject = [[CGContextObject alloc] initWithCGContext:UIGraphicsGetCurrentContext()];
    
    
    // 开始绘图
    for (int count = 0; count < 50; count++) {
        
        // 获取随机高度
        CGFloat lineHeight = arc4random() % (int)(height - 20);
        
        if (lineHeight > 100) {

            GradientColor *color = [RedGradientColor createColorWithStartPoint:CGPointMake(count * 4, height - lineHeight) endPoint:CGPointMake(count * 4, height)];
            [self.contextObject drawLinearGradientAtClipToRect:CGRectMake(count * 4, height - lineHeight, 2, lineHeight) gradientColor:color];
            
        } else {
            
            GradientColor *color = [GradientColor createColorWithStartPoint:CGPointMake(count * 4, height - lineHeight) endPoint:CGPointMake(count * 4, height)];
            [self.contextObject drawLinearGradientAtClipToRect:CGRectMake(count * 4, height - lineHeight, 2, lineHeight) gradientColor:color];
        }
        
    }
}

- (void)dealloc {
    NSLog(@"KView dealloc %p",self);
}

@end
